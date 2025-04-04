#!/usr/bin/env python2
# -*- coding: utf-8 -*-
# pylint: disable=print-statement

"""司法大数据接口类，从法研院接口获取案件数据。可按需使用全量或新增案件接口，若获取失败则自动按页重试。

修改历史：
    2024-10-12: 性能优化    张晨晖
    2024-09-20: 初始版本    张晨晖


用法：
    ```
    import datetime
    from JudicialBigData import JudicialBigData

    jbd = JudicialBigData("司法大数据配置.json")

    if datetime.date.today().weekday() in (5, 6): # 周末全量
        jbd.import_cases(incremental=False)
    else:
        jbd.import_cases(incremental=True)        # 工作日增量
    ```

配置文件：司法大数据配置文件.json
配置文件样例：
    ```json
{
    "connection": {
      "全量案件": "https://qyss.cjbdi.com/qyss/qyss/enterlit/queryNewAllCase",  # 法研院接口
      "新增立案": "https://qyss.cjbdi.com/qyss/qyss/enterlit/queryNewLaCase",
      "新增结案": "https://qyss.cjbdi.com/qyss/qyss/enterlit/queryNewJaCase",
      "loginName": "zgwk2",
      "passWord": "shesu@2022&0198$",
      "key": "wkjtC@ntdGscsoqc",
      "ticket": "1LyM07LLxWpTBFnTqHGMdp1vHqGTYBF9Ck289X7P8ionseKdd62lHH3gxvJPr0wx",
      "db.host": "10.201.132.224",      # 数据库连接信息（doris）
      "db.user": "python_script_user",
      "db.password": "python_script_user@WuKuang",
      "db.database": "ods_prod",
      "db.port": 9030,
      "retries": 3,         # 失败重试次数
      "pageSize": 50,       # 使用增量接口时，每页获取案件的条数
      "pageSizeFactor": 10  # 使用全量接口时，每页获取案件的条数 = pageSize * pageSizeFactor
    },
    "companies": [          # 需要获取案件的公司列表
      "中国五矿集团有限公司",
      "中国五矿股份有限公司",
      "..."
    ],
    "columns": {}           # 案件接口字段信息，和表字段对应
    ```
"""



from __future__ import print_function
from collections import deque, namedtuple, defaultdict
import json
import base64
import requests
from Crypto.Cipher import AES
from Crypto.Util.Padding import pad, unpad
import pymysql
import logging
import time
import logging
from time import sleep
from functools import wraps


class AESB64:
    def __init__(self, key):
        self.cipher = AES.new(key.encode('utf-8'), AES.MODE_ECB)

    def encrypt(self, cleartext):
        padded = pad(cleartext.encode('utf-8'), AES.block_size)
        encrypted = self.cipher.encrypt(padded)
        b64str = base64.b64encode(encrypted)
        return b64str

    def decrypt(self, b64str):
        encrypted = base64.b64decode(b64str)
        padded = self.cipher.decrypt(encrypted)
        cleartext = unpad(padded, AES.block_size).decode('utf-8')
        return cleartext
    

class JudicialBigData:
    def __init__(self, config_fname):
        with open(config_fname, 'r') as jsonfile:
            conf = json.load(jsonfile)        # 加载配置数据
        self.conn = conf['connection']        # 连接信息
        self.columns = conf['columns']        # 数据库表字段信息
        self.companies = conf['companies']    # 企业名单
        self.cipher = AESB64(self.conn['key'])                


    def request_page(self, url, company, pageNum, pageSize):
        payload = {
            "loginName": self.conn['loginName'],
            "passWord": self.conn['passWord'],
            "company": company,
            "pageNum": pageNum,
            "pageSize": pageSize,
            "flag": 1 # 1全量 2结案时间为空的
        }
        
        response = requests.post(
            url, 
            data=self.cipher.encrypt(json.dumps(payload)),
            headers={
                "Content-Type": "application/json",
                "ticket": self.conn['ticket']
            }
        )
        
        if response.status_code != 200: 
            raise ValueError("请求失败。status code：{}".format(response.status_code))
        encrypted = response.text.encode('utf-8')
        if encrypted.startswith('{"msg":'):
            raise ValueError("异常应答（未解密）：{}".format(encrypted))
        decrypted = json.loads(self.cipher.decrypt(encrypted))
        if decrypted.get('code', 0) != 1000:
            raise ValueError("异常应答（解密）：{}".format(decrypted))
        data = decrypted.get('data')        
        if not data:
            raise ValueError("应答中无数据（data）。公司名称“{}”是否有误？".format(company))
    
        cases = data.get('hashMap', {})
        pages = data.get('pages', 0)
        
        return cases, pages


    def request_cases(self, incremental=True):
        api_types = ['新增立案', '新增结案'] if incremental else  ['全量案件']
        pageSize = self.conn['pageSize'] if incremental else self.conn['pageSize'] * self.conn['pageSizeFactor']
    
        Task = namedtuple('Task', ['api_type', 'url', 'company', 'pageNum', 'pages', 'retry'])
        tasks = deque([
            Task(
                api_type=api_type,
                url=self.conn[api_type.decode('utf-8')], 
                company=company.encode('utf-8'),
                pageNum=1, 
                pages=None,    # unknown for now
                retry=0
            )
            for company in self.companies
            for api_type in api_types
        ])

        all_cases = defaultdict(list)
        while tasks:
            t = tasks.popleft()
            print("[{}]：{} 第 {}{} 页 {}".format(
                t.api_type,
                t.company,
                t.pageNum,
                "/{}".format(t.pages) if t.pages >= 0 else '',
                "（重试 {}）".format(t.retry) if t.retry > 0 else ''
            ))

            try:
                cases, pages = self.request_page(
                    url=t.url,
                    company=t.company,
                    pageNum=t.pageNum,
                    pageSize=pageSize
                )
            except ValueError as e: # retries
                print(e)
                if t.retry < self.conn['retries']:
                    tasks.append(t._replace(retry=1+t.retry))
                continue
            
            if t.pageNum == 1 and pages > 1:
                tasks.extendleft([t._replace(pageNum=p, pages=pages, retry=0) 
                              for p in range(pages, 1, -1)])
                
            for label, rows in cases.items():
                all_cases[label].extend(rows)
                
        return all_cases


    def save_cases(self, cases):
        dbconn = pymysql.connect(
            host=self.conn['db.host'],
            user=self.conn['db.user'],
            password=self.conn['db.password'],
            database=self.conn['db.database'],
            port=self.conn['db.port']
        )
        
        try:
            with dbconn.cursor() as cursor:
                for label, rows in cases.items():
                    if not rows:     # empty data
                        continue
                    label = label[:-4].upper()
                    table = "ODS_FL_XZLA" +  label
                    fields = self.columns[label]
                    placeholders =  ['%s'] * len(fields)
                    data = [[row.get(field) for field in fields] for row in rows]
                    sql = "INSERT INTO {} ({}) VALUES ({})".format(
                        table, 
                        ', '.join(fields), 
                        ', '.join(placeholders))
                                        
                    try:
                        cursor.executemany(sql, data)
                    except Exception as e:
                        print("数据库插入表{}错误：{}".format(table, e))

            dbconn.commit()
        finally:
            dbconn.close()


    def import_cases(self, incremental=True):
        cases = self.request_cases(incremental)
        self.save_cases(cases)

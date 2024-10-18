# coding: utf-8

import json
import base64
import requests
from Crypto.Cipher import AES
from Crypto.Util.Padding import pad, unpad
import pymysql


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
    

def fetch_api(config, all=True, pageSize=100):
    conn = config['connection']
    schema = config['schema']
    companies = config['companies'][:20]
    
    cipher = AESB64(conn['key'])
    
    api_data = {t.lower() + 'List': [] for t in schema['tables'].keys()}
    
    if all: # 全量数据
        urls = [conn['url.all']]
        print "收集全量案件。"
    else:   # 增量立案、结案
        urls = [conn['url.newLA'], conn['url.newJA']]
        print "收集增量案件。"
        
    for url in urls:
        for company in companies:
            pageNum = 1
            while True: # iterate over all pages
                print "URL: {} \n公司：{}， 第 {} 页".format(url, company, pageNum)

                request_payload = {
                    "loginName": conn['loginName'],
                    "passWord": conn['passWord'],
                    "company": company,
                    "pageNum": pageNum,
                    "pageSize": pageSize,
                    "flag": 1
                }

                response = requests.post(
                    url, 
                    data=cipher.encrypt(json.dumps(request_payload)),
                    headers={
                        "Content-Type": "application/json",
                        "ticket": conn['ticket']
                    }
                )

                if response.status_code != 200:
                    print "Request failed with status code {} for page {}.".format(response.status_code, pageNum)
                    break

                try:
                    decrypted_response = cipher.decrypt(response.text)
                except Exception as e:
                    print "Decryption failed for page {}. Response text: {}".format(pageNum, response.text)
                    break

                response_data = json.loads(decrypted_response)

                if "code" not in response_data or response_data["code"] != 1000:
                    print "Error in response: {}".format(response_data.get('msg', 'No message'))
                    print "Full response: {}".format(response_data)
                    break

                data = response_data.get("data")
                if not data:
                    print "No data field in response"
                    break

                hashMap = data.get("hashMap")
                if not hashMap:
                    print "No hashMap field in data"
                    break

                for table_name in api_data.keys():
                    table_data = hashMap.get(table_name)
                    if table_data:
                        api_data[table_name].extend(table_data)

                if pageNum >= data.get("pages", 0):
                    break

                pageNum += 1

    return api_data


def insert_db(api_data, config, batch_size=1000):
    conn = config['connection']
    schema = config['schema']

    list_to_table = {k.lower() + 'List': v for k, v in schema['tables'].items()}
    field_mappings = {schema['tables'][k]: v for k, v in schema['columns'].items()}

    connection = pymysql.connect(
        host=conn['db.host'],
        user=conn['db.user'],
        password=conn['db.password'],
        database=conn['db.database'],
        port=conn['db.port']
    )

    cursor = connection.cursor()

    # print(field_mappings)
    
    for list_name, data in api_data.items():
        table_name = list_to_table.get(list_name)
        if not table_name:
            print "No table mapping for list {}.".format(list_name)
            continue

        field_mapping = field_mappings.get(table_name)
        if not field_mapping:
            print "No field mapping for table {}.".format(table_name)
            continue

        total_records = len(data)
        for i in range(0, total_records, batch_size):
            batch = data[i:i + batch_size]
            values_list = []

            for record in batch:
                values = [record.get(field) for field in field_mapping.keys()]
                values_list.append(values)

            columns = ', '.join(field_mapping.values())
            placeholders = ','.join(['%s'] * len(field_mapping))
            sql = "INSERT INTO {} ({}) VALUES ({})".format(table_name, columns, placeholders)

            try:
                cursor.executemany(sql, values_list)
            except Exception as e:
                print "Error inserting data into {}: {}".format(table_name, e)
                print "Batch start index: {}".format(i)

    connection.commit()
    cursor.close()
    connection.close()


with open("司法大数据配置.json", 'r') as config_json:
    config = json.load(config_json)  # 加载配置数据
    
data = fetch_api(config, all=True)

insert_db(data, config)
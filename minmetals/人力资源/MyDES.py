# coding: utf-8

"""解密数据表中用 MySQL 的 DES_ENCRYPT() 函数加密过的字段，并将解密结果写入指定列。

修改历史：
    2023-11-11: 性能优化    张晨晖
    2024-11-06: 初始版本    张晨晖


用法：
    ```
    from MyDES import MyDES
        
    mydes = MyDES("解密配置.json")
    mydes.update()
    ```


配置文件样例：
    ```json
    {
        "connection": {                             # 数据库连接信息，需要写入权限
            "db.host": "localhost",
            "db.user": "root",
            "db.password": "xxx",
            "db.database": "ods_prod",
            "db.port": 3306
        },
        "fields": [
            {
                "table_name": "ODS_BUS_EMPLOYEE",   # 需要解密的表名
                "unique_key": "EMP_ID",             # 表的唯一键（必须有）
                "ciphertext": "EMP_NAME",           # 被加密的列名
                "cleartext": "EMP_NAME_CLEAR",      # 解密后存放的列名
                "password": "83BCE225D9FD151A"      # 解密用的密码
            },
            {
                "table_name": "ODS_BUS_EMPLOYEE",   # 可以一次解密多个表的多个列
                "unique_key": "EMP_ID",
                "ciphertext": "MOBILE_PHONE",
                "cleartext": "MOBILE_PHONE_CLEAR",
                "password": "83BCE225D9FD151A"
            }
        ]
    }
    ```
"""

import json
from binascii import unhexlify
from hashlib import md5

from Crypto.Cipher import DES3
import pymysql


class MyDES:
    def __init__(self, config_fname):
        with open(config_fname, 'r') as jsonfile:
            conf = json.load(jsonfile)  # 加载配置数据
        self.conn = conf['connection']  # 数据库连接信息
        self.fields = conf['fields']    # 待解密表字段信息
    
    
    @staticmethod
    def mysql_des_decrypt(hexstr, password):
        """
        https://stackoverflow.com/a/36849093/7129176
        """
        password = password.encode()
        key =  md5(password).digest()           # 16 bytes 
        key += md5(key + password).digest()     # extend to 32 bytes 
        key = DES3.adjust_key_parity(key[:24])  # take first 24
            
        des3 = DES3.new(key, DES3.MODE_CBC, iv=chr(0) * 8)
        ciphertext = unhexlify(hexstr)
        cleartext = des3.decrypt(ciphertext[1:])
        return cleartext[:-ord(cleartext[-1])]


    def update_field(self, field, cursor):
        """
        解密单个列
        """
        sql_drop_temp = """
            DROP TABLE IF EXISTS `TEMP_MYDES`
        """
        sql_create_temp = """
            CREATE TABLE `TEMP_MYDES`
            UNIQUE KEY(`UID`) AS
            SELECT `{}` AS `UID`, `{}` AS `CLEARTEXT`
            FROM `{}`
            WHERE FALSE
        """.format(
            field['unique_key'],
            field['cleartext'],
            field['table_name']
        )
        sql_select = """
            SELECT `{}`, `{}`
            FROM `{}`
            WHERE `{}` IS NULL and `{}` LIKE 'FF%'
        """.format(
            field['unique_key'],
            field['ciphertext'],
            field['table_name'],
            field['cleartext'],
            field['ciphertext']
        )
        sql_insert = """
            INSERT INTO TEMP_MYDES VALUES(%s, %s)
        """
        sql_update = """
            UPDATE `{}` AS T
            SET T.`{}` = S.`CLEARTEXT`
            FROM `TEMP_MYDES` AS S
            WHERE T.`{}` = S.`UID`
        """.format(
            field['table_name'],
            field['cleartext'],
            field['unique_key']
        )

        try:
            cursor.execute(sql_drop_temp)
            cursor.execute(sql_create_temp)
            cursor.execute(sql_select)
            result = [(uid, self.mysql_des_decrypt(text, field['password']))
                      for uid, text in cursor.fetchall()]
            records = cursor.executemany(sql_insert, result)
            records = cursor.execute(sql_update)
            if records:
                print "{}.{} 有 {} 条记录完成解密。".format(
                    field['table_name'],
                    field['ciphertext'],
                    records
                )
        finally:
            cursor.execute(sql_drop_temp)        
    
    
    def update(self):
        """
        按配置文件顺序解密多个列
        """
        dbconn = pymysql.connect(
            host=self.conn['db.host'],
            user=self.conn['db.user'],
            password=self.conn['db.password'],
            database=self.conn['db.database'],
            port=self.conn['db.port']
        )
        
        try:
            with dbconn.cursor() as cursor:
                for field in self.fields:
                    self.update_field(field, cursor)
                    dbconn.commit()
        finally:
            dbconn.close()
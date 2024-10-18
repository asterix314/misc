import json
import base64
import requests
from Crypto.Cipher import AES
import pymysql


class AESCipher:
    def __init__(self, key):
        self.key = key.encode('utf-8')
        self.mode = AES.MODE_ECB

    def pad(self, data):
        block_size = AES.block_size
        padding = block_size - len(data) % block_size
        return data + (chr(padding) * padding).encode('utf-8')

    def unpad(self, data):
        return data[:-data[-1]]

    def encrypt(self, raw):
        raw = self.pad(raw.encode('utf-8'))
        cipher = AES.new(self.key, self.mode)
        encrypted = base64.b64encode(cipher.encrypt(raw))
        return encrypted.decode('utf-8')

    def decrypt(self, enc):
        enc_bytes = base64.b64decode(enc)
        cipher = AES.new(self.key, self.mode)
        decrypted = self.unpad(cipher.decrypt(enc_bytes))
        return decrypted.decode('utf-8')


def fetch_data(api_url, key, ticket, company, loginName, passWord, pageSize=100):
    aes_cipher = AESCipher(key)
    pageNum = 1
    all_data = {table: [] for table in [
        "msysList", "xzysList", "mszsList", "msesList", "xsesList",
        "sczxList", "xszsList", "xzzsList", "ccbqzxList", "xzesList",
        "hfzxList", "zxyyList", "xsysList"
    ]}

    while True:
        request_payload = {
            "loginName": loginName,
            "passWord": passWord,
            "company": company,
            "pageNum": pageNum,
            "pageSize": pageSize,
            "flag": 1
        }

        encrypted_payload = aes_cipher.encrypt(json.dumps(request_payload))
        headers = {
            "Content-Type": "application/json",
            "ticket": ticket
        }

        response = requests.post(api_url, data=encrypted_payload, headers=headers)

        if response.status_code != 200:
            print(f"Request failed with status code {response.status_code}")
            break

        try:
            decrypted_response = aes_cipher.decrypt(response.text)
        except Exception as e:
            print(f"Decryption failed for page {pageNum}")
            print(f"Response text: {response.text}")
            break

        response_data = json.loads(decrypted_response)

        if "code" not in response_data or response_data["code"] != 1000:
            print(f"Error in response: {response_data.get('msg', 'No message')}")
            print(f"Full response:  {response_data}")
            break

        data = response_data.get("data")
        if not data:
            print("No data field in response")
            break

        hashMap = data.get("hashMap")
        if not hashMap:
            print("No hashMap field in data")
            break

        for table_name in all_data.keys():
            table_data = hashMap.get(table_name)
            if table_data:
                all_data[table_name].extend(table_data)

        if pageNum >= data.get("pages", 0):
            break

        pageNum += 1

    return all_data


def insert_data_to_doris(all_data, db_config, mappings, batch_size=1000):
    connection = pymysql.connect(
        host=db_config['host'],
        user=db_config['user'],
        password=db_config['password'],
        database=db_config['database'],
        port=db_config['port']
    )

    cursor = connection.cursor()

    list_to_table = mappings.get("list_to_table", {})
    field_mappings = mappings.get("field_mappings", {})

    # print(field_mappings)
    for list_name, data in all_data.items():
        table_name = list_to_table.get(list_name)
        if not table_name:
            print(f"No table mapping for list {list_name}")
            continue

        field_mapping = field_mappings.get(table_name)
        if not field_mapping:
            print(f"No field mapping for table {table_name}")
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
            sql = f"INSERT INTO {table_name} ({columns}) VALUES ({placeholders})"
            
            try:
                cursor.executemany(sql, values_list)
            except Exception as e:
                print(f"Error inserting data into {table_name}: {e}")
                print(f"Batch start index: {i}")

    connection.commit()
    cursor.close()
    connection.close()


# Example usage
api_url = "https://qyss.cjbdi.com/qyss/qyss/enterlit/queryNewAllCase"
key = "wkjtC@ntdGscsoqc"
ticket = "1LyM07LLxWpTBFnTqHGMdp1vHqGTYBF9Ck289X7P8ionseKdd62lHH3gxvJPr0wx"
companies = ["五矿二十三冶建设集团有限公司", "中国一冶集团有限公司", "中国华冶科工集团有限公司",
             "长沙五矿商业管理有限公司"]
loginName = "zgwk"
passWord = "shesu@2022&0198$"

all_data = {table: [] for table in [
    "msysList", "xzysList", "mszsList", "msesList", "xsesList",
    "sczxList", "xszsList", "xzzsList", "ccbqzxList", "xzesList",
    "hfzxList", "zxyyList", "xsysList"
]}

for company in companies:
    company_data = fetch_data(api_url, key, ticket, company, loginName, passWord)
    for table_name in all_data.keys():
        all_data[table_name].extend(company_data[table_name])

# 将原本的mappings.json内容直接放入代码中
mappings = {
    "list_to_table": {
        "msysList": "ODS_FL_XZLAMSYS",
        "xzysList": "ODS_FL_XZLAXZYS",
        "mszsList": "ODS_FL_XZLAMSZS",
        "msesList": "ODS_FL_XZLAMSES",
        "xsesList": "ODS_FL_XZLAXSES",
        "sczxList": "ODS_FL_XZLASCZX",
        "xszsList": "ODS_FL_XZLAXSZS",
        "xzzsList": "ODS_FL_XZLAXZZS",
        "ccbqzxList": "ODS_FL_XZLACCBQZX",
        "xzesList": "ODS_FL_XZLAXZES",
        "hfzxList": "ODS_FL_XZLAHFZX",
        "zxyyList": "ODS_FL_XZLAZXYY",
        "xsysList": "ODS_FL_XZLAXSYS"
    },
    "field_mappings": {
        "ODS_FL_XZLAMSYS": {
            "id": "id",
            "ccompany": "ccompany",
            "cajmc": "cajmc",
            "cjafs": "cjafs",
            "regionDm": "regionDm",
            "cfbdm": "cfbdm",
            "cgroupname": "cgroupname",
            "jabdje": "jabdje",
            "baseSpare": "baseSpare",
            "cfsbg": "cfsbg",
            "ktxx": "ktxx",
            "cfsyg": "cfsyg",
            "dJarq": "dJarq",
            "dXgsj": "dXgsj",
            "labdje": "labdje",
            "jabdjeSpare": "jabdjeSpare",
            "cqtdsr": "cqtdsr",
            "cbaah": "cbaah",
            "cbg": "cbg",
            "cdsr": "cdsr",
            "cdwmc": "cdwmc",
            "cfymc": "cfymc",
            "cyg": "cyg",
            "ifCall": "ifCall",
            "njabdje": "njabdje",
            "dSarq": "dSarq",
            "region": "region",
            "nbdse": "nbdse",
            "claaymc": "claaymc",
            "cssdw": "cssdw"
        },
        "ODS_FL_XZLAXZYS": {
            "id": "id",
            "ccompany": "ccompany",
            "cjafs": "cjafs",
            "cfbdm": "cfbdm",
            "cgroupname": "cgroupname",
            "jabdje": "jabdje",
            "baseSpare": "baseSpare",
            "ktxx": "ktxx",
            "dJarq": "dJarq",
            "dXgsj": "dXgsj",
            "labdje": "labdje",
            "jabdjeSpare": "jabdjeSpare",
            "cqtdsr": "cqtdsr",
            "cbaah": "cbaah",
            "cbg": "cbg",
            "cdsr": "cdsr",
            "cdwmc": "cdwmc",
            "cfymc": "cfymc",
            "cyg": "cyg",
            "ifCall": "ifCall",
            "superior": "superior",
            "njabdje": "njabdje",
            "dSarq": "dSarq",
            "region": "region",
            "nbdse": "nbdse",
            "claaymc": "claaymc",
            "cssdw": "cssdw"
        },
        "ODS_FL_XZLAMSZS": {
            "id": "id",
            "ccompany": "ccompany",
            "cjafs": "cjafs",
            "cfbdm": "cfbdm",
            "cgroupname": "cgroupname",
            "cqyzsajah": "cqyzsajah",
            "csensr": "csensr",
            "jabdje": "jabdje",
            "bdseSpare": "bdseSpare",
            "ktxx": "ktxx",
            "dJarq": "dJarq",
            "dXgsj": "dXgsj",
            "cssr": "cssr",
            "labdje": "labdje",
            "jabdjeSpare": "jabdjeSpare",
            "czssqr": "czssqr",
            "cbaah": "cbaah",
            "czsssr": "czsssr",
            "czsscajah": "czsscajah",
            "cdsr": "cdsr",
            "cdwmc": "cdwmc",
            "cfymc": "cfymc",
            "ifCall": "ifCall",
            "cbssr": "cbssr",
            "cbsqr": "cbsqr",
            "czsbssr": "czsbssr",
            "njabdje": "njabdje",
            "dSarq": "dSarq",
            "cbsensr": "cbsensr",
            "region": "region",
            "nbdse": "nbdse",
            "claaymc": "claaymc",
            "cssdw": "cssdw"
        },
        "ODS_FL_XZLAMSES": {
            "id": "id",
            "ccompany": "ccompany",
            "cjafs": "cjafs",
            "cfbdm": "cfbdm",
            "cgroupname": "cgroupname",
            "cysah": "cysah",
            "jabdje": "jabdje",
            "bdseSpare": "bdseSpare",
            "ktxx": "ktxx",
            "dJarq": "dJarq",
            "dXgsj": "dXgsj",
            "cysyg": "cysyg",
            "cssr": "cssr",
            "labdje": "labdje",
            "jabdjeSpare": "jabdjeSpare",
            "cqtdsr": "cqtdsr",
            "cysdsr": "cysdsr",
            "cbaah": "cbaah",
            "cysbg": "cysbg",
            "cysbsqr": "cysbsqr",
            "cdwmc": "cdwmc",
            "cfymc": "cfymc",
            "ifCall": "ifCall",
            "cbssr": "cbssr",
            "njabdje": "njabdje",
            "dSarq": "dSarq",
            "cyssqr": "cyssqr",
            "region": "region",
            "nbdse": "nbdse",
            "claaymc": "claaymc",
            "cssdw": "cssdw"
        },
        "ODS_FL_XZLAXSES": {
            "id": "id",
            "ccompany": "ccompany",
            "cjafs": "cjafs",
            "cfbdm": "cfbdm",
            "cgroupname": "cgroupname",
            "cfhajah": "cfhajah",
            "cyslhgxr": "cyslhgxr",
            "cysah": "cysah",
            "cysfdmsssbg": "cysfdmsssbg",
            "jabdje": "jabdje",
            "cysfdmsssyg": "cysfdmsssyg",
            "ktxx": "ktxx",
            "dJarq": "dJarq",
            "dXgsj": "dXgsj",
            "cssr": "cssr",
            "labdje": "labdje",
            "cqtdsr": "cqtdsr",
            "cysfsr": "cysfsr",
            "csqfyr": "csqfyr",
            "cbaah": "cbaah",
            "cysbg": "cysbg",
            "cysbsqr": "cysbsqr",
            "cdwmc": "cdwmc",
            "cfymc": "cfymc",
            "cmswfsdscah": "cmswfsdscah",
            "ifCall": "ifCall",
            "superior": "superior",
            "cysfsbgr": "cysfsbgr",
            "njabdje": "njabdje",
            "dSarq": "dSarq",
            "region": "region",
            "cfzxyr": "cfzxyr",
            "nbdse": "nbdse",
            "claaymc": "claaymc",
            "cssdw": "cssdw"
        },
        "ODS_FL_XZLASCZX": {
            "id": "id",
            "ccompany": "ccompany",
            "cjafs": "cjafs",
            "cfbdm": "cfbdm",
            "cgroupname": "cgroupname",
            "cbzxr": "cbzxr",
            "bdseSpare": "bdseSpare",
            "cawr": "cawr",
            "dJarq": "dJarq",
            "dXgsj": "dXgsj",
            "nsqcylxlx": "nsqcylxlx",
            "cyyr": "cyyr",
            "labdje": "labdje",
            "jabdjeSpare": "jabdjeSpare",
            "csqfyr": "csqfyr",
            "cbaah": "cbaah",
            "nsqzxze": "nsqzxze",
            "csqzxr": "csqzxr",
            "cdsr": "cdsr",
            "cfymc": "cfymc",
            "clhgxr": "clhgxr",
            "cbsqr": "cbsqr",
            "dSarq": "dSarq",
            "region": "region",
            "nbdse": "nbdse",
            "claaymc": "claaymc",
            "csqr": "csqr",
            "csqzxbdzl": "csqzxbdzl",
            "jabdje": "jabdje",
            "sqcylxj": "sqcylxj",
            "cqtdsr": "cqtdsr",
            "sqzxze": "sqzxze",
            "czxyjajah": "czxyjajah",
            "cdwmc": "cdwmc",
            "ifCall": "ifCall",
            "nsqcylxj": "nsqcylxj",
            "superior": "superior",
            "njabdje": "njabdje",
            "sqzxzeSpare": "sqzxzeSpare",
            "sqcylxlx": "sqcylxlx",
            "cssdw": "cssdw"
        },
        "ODS_FL_XZLAXSZS": {
            "id": "id",
            "ccompany": "ccompany",
            "cjafs": "cjafs",
            "cesajah": "cesajah",
            "cfbdm": "cfbdm",
            "cgroupname": "cgroupname",
            "cqyzsajah": "cqyzsajah",
            "csensr": "csensr",
            "jabdje": "jabdje",
            "ktxx": "ktxx",
            "dJarq": "dJarq",
            "dXgsj": "dXgsj",
            "cssr": "cssr",
            "labdje": "labdje",
            "cqtdsr": "cqtdsr",
            "czssqr": "czssqr",
            "csqfyr": "csqfyr",
            "cbaah": "cbaah",
            "czsssr": "czsssr",
            "czsscajah": "czsscajah",
            "cdwmc": "cdwmc",
            "cfymc": "cfymc",
            "ifCall": "ifCall",
            "superior": "superior",
            "cbssr": "cbssr",
            "czsbsqr": "czsbsqr",
            "czsbssr": "czsbssr",
            "njabdje": "njabdje",
            "dSarq": "dSarq",
            "cbsensr": "cbsensr",
            "region": "region",
            "nbdse": "nbdse",
            "claaymc": "claaymc",
            "cssdw": "cssdw"
        },
        "ODS_FL_XZLAXZZS": {
            "id": "id",
            "ccompany": "ccompany",
            "cjafs": "cjafs",
            "cfbdm": "cfbdm",
            "cgroupname": "cgroupname",
            "cqyzsajah": "cqyzsajah",
            "csensr": "csensr",
            "jabdje": "jabdje",
            "ktxx": "ktxx",
            "dJarq": "dJarq",
            "dXgsj": "dXgsj",
            "cssr": "cssr",
            "labdje": "labdje",
            "cqtdsr": "cqtdsr",
            "czssqr": "czssqr",
            "cbaah": "cbaah",
            "czsssr": "czsssr",
            "czsscajah": "czsscajah",
            "cdwmc": "cdwmc",
            "cfymc": "cfymc",
            "ifCall": "ifCall",
            "superior": "superior",
            "cbssr": "cbssr",
            "cbsqr": "cbsqr",
            "czsbssr": "czsbssr",
            "njabdje": "njabdje",
            "dSarq": "dSarq",
            "cbsensr": "cbsensr",
            "region": "region",
            "nbdse": "nbdse",
            "claaymc": "claaymc",
            "cssdw": "cssdw"
        },
        "ODS_FL_XZLACCBQZX": {
            "id": "id",
            "ccompany": "ccompany",
            "cjafs": "cjafs",
            "cfbdm": "cfbdm",
            "cgroupname": "cgroupname",
            "csccbqajah": "csccbqajah",
            "jabdje": "jabdje",
            "cbzxr": "cbzxr",
            "cawr": "cawr",
            "dJarq": "dJarq",
            "dXgsj": "dXgsj",
            "cyyr": "cyyr",
            "labdje": "labdje",
            "cqtdsr": "cqtdsr",
            "csqfyr": "csqfyr",
            "cbaah": "cbaah",
            "csqzxr": "csqzxr",
            "cdsr": "cdsr",
            "cdwmc": "cdwmc",
            "cfymc": "cfymc",
            "clhgxr": "clhgxr",
            "ifCall": "ifCall",
            "superior": "superior",
            "cbsqr": "cbsqr",
            "njabdje": "njabdje",
            "dSarq": "dSarq",
            "region": "region",
            "nbdse": "nbdse",
            "claaymc": "claaymc",
            "cssdw": "cssdw",
            "csqr": "csqr"
        },
        "ODS_FL_XZLAXZES": {
            "id": "id",
            "ccompany": "ccompany",
            "cjafs": "cjafs",
            "cfbdm": "cfbdm",
            "cgroupname": "cgroupname",
            "jabdje": "jabdje",
            "cxzysah": "cxzysah",
            "ktxx": "ktxx",
            "cmsysah": "cmsysah",
            "dJarq": "dJarq",
            "dXgsj": "dXgsj",
            "cysyg": "cysyg",
            "cssr": "cssr",
            "labdje": "labdje",
            "cqtdsr": "cqtdsr",
            "cysdsr": "cysdsr",
            "cbaah": "cbaah",
            "cysbg": "cysbg",
            "cdwmc": "cdwmc",
            "cfymc": "cfymc",
            "ifCall": "ifCall",
            "superior": "superior",
            "cbssr": "cbssr",
            "njabdje": "njabdje",
            "dSarq": "dSarq",
            "region": "region",
            "nbdse": "nbdse",
            "claaymc": "claaymc",
            "cssdw": "cssdw"
        },
        "ODS_FL_XZLAHFZX": {
            "id": "id",
            "ccompany": "ccompany",
            "cjafs": "cjafs",
            "cfbdm": "cfbdm",
            "cgroupname": "cgroupname",
            "jabdje": "jabdje",
            "cbzxr": "cbzxr",
            "bdseSpare": "bdseSpare",
            "cawr": "cawr",
            "dJarq": "dJarq",
            "dXgsj": "dXgsj",
            "sqcylxj": "sqcylxj",
            "cyyr": "cyyr",
            "labdje": "labdje",
            "cqtdsr": "cqtdsr",
            "csqfyr": "csqfyr",
            "cbaah": "cbaah",
            "csqzxr": "csqzxr",
            "czxyjajah": "czxyjajah",
            "cdsr": "cdsr",
            "cdwmc": "cdwmc",
            "cfymc": "cfymc",
            "clhgxr": "clhgxr",
            "ifCall": "ifCall",
            "superior": "superior",
            "cbsqr": "cbsqr",
            "dSarq": "dSarq",
            "region": "region",
            "nbdse": "nbdse",
            "sqcylxlx": "sqcylxlx",
            "claaymc": "claaymc",
            "cssdw": "cssdw",
            "csqr": "csqr",
            "jabdjeSpare": "jabdjeSpare",
            "njabdje": "njabdje",
            "nsqcylxj": "nsqcylxj",
            "nsqcylxlx": "nsqcylxlx"
        },
        "ODS_FL_XZLAZXYY": {
            "id": "id",
            "ccompany": "ccompany",
            "cjafs": "cjafs",
            "cyyhsqrlx": "cyyhsqrlx",
            "cfbdm": "cfbdm",
            "cgroupname": "cgroupname",
            "jabdje": "jabdje",
            "dJarq": "dJarq",
            "dXgsj": "dXgsj",
            "labdje": "labdje",
            "cbaah": "cbaah",
            "cdwmc": "cdwmc",
            "cfymc": "cfymc",
            "ifCall": "ifCall",
            "superior": "superior",
            "njabdje": "njabdje",
            "dSarq": "dSarq",
            "region": "region",
            "nbdse": "nbdse",
            "claaymc": "claaymc"
        },
        "ODS_FL_XZLAXSYS": {
            "id": "id",
            "ccompany": "ccompany",
            "cjafs": "cjafs",
            "cfdmsssbg": "cfdmsssbg",
            "cfdmsssfsbg": "cfdmsssfsbg",
            "cfbdm": "cfbdm",
            "cgroupname": "cgroupname",
            "jabdje": "jabdje",
            "ktxx": "ktxx",
            "cfdmsssyg": "cfdmsssyg",
            "dJarq": "dJarq",
            "cfsbgr": "cfsbgr",
            "dXgsj": "dXgsj",
            "labdje": "labdje",
            "cqtdsr": "cqtdsr",
            "cbgr": "cbgr",
            "cbaah": "cbaah",
            "cfsr": "cfsr",
            "cdwmc": "cdwmc",
            "cfymc": "cfymc",
            "ifCall": "ifCall",
            "superior": "superior",
            "njabdje": "njabdje",
            "czsr": "czsr",
            "dSarq": "dSarq",
            "region": "region",
            "cfdmsssfsyg": "cfdmsssfsyg",
            "nbdse": "nbdse",
            "claaymc": "claaymc",
            "cssdw": "cssdw"
        }
    }

}

# db_config = {
#     'host': '10.201.132.8',
#     'user': 'zhangyc6',
#     'password': 'zhangyc6@123456',
#     'database': 'dw_ods_dsep',
#     'port': 9030
# }

db_config = {
    'host': 'localhost',
    'user': 'root',
    'password': '',
    'database': 'ods_prod',
    'port': 3306
}

insert_data_to_doris(all_data, db_config, mappings)

print("finished.")
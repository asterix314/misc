from hashlib import md5 
from Crypto.Cipher import DES3
from binascii import unhexlify


class MySQLDES:
    def __init__(self, password):
        key =  md5(password).digest()           # 16 bytes 
        key += md5(key + password).digest()     # extend to 32 bytes 
        key = DES3.adjust_key_parity(key[:24])  # take first 24
        self.cipher = DES3.new(
            key, 
            DES3.MODE_CBC,
            iv=chr(0) * 8) 
        
 
    def decrypt(self, hexstr): 
        ciphertext = unhexlify(hexstr) 
        cleartext = self.cipher.decrypt(ciphertext[1:])
        cleartext = cleartext[:-ord(cleartext[-1])]
        
        return cleartext
    

des = MySQLDES('83BCE225D9FD151A')
print des.decrypt('FF83664DF1A2B16623D558CE6A37C90548')
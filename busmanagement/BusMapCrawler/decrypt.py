from Crypto.Cipher import AES
from Crypto.Util.Padding import unpad

class BusMapDecrypt:

    def __init__(self, key: str):
        self.key = key.encode("utf-8")

    def decrypt(self, encrypted_hex: str):

        encrypted_hex = encrypted_hex.strip()

        if encrypted_hex.startswith('"'):
            encrypted_hex = encrypted_hex[1:-1]

        raw = bytes.fromhex(encrypted_hex)

        iv = raw[:16]
        ciphertext = raw[16:]

        cipher = AES.new(self.key, AES.MODE_CBC, iv)

        plaintext = unpad(cipher.decrypt(ciphertext), AES.block_size)

        return plaintext.decode("utf-8")
import uuid
import json
import requests

from decrypt import BusMapDecrypt


class BusMap:

    BASE = "https://api-web.busmap.vn"

    def __init__(self):

        self.headers = {
            "language": "vi",
            "client-version": "web",
            "device-id": str(uuid.uuid4()),
            "User-Agent": "Mozilla/5.0"
        }

        self.key = self.get_key()

        self.decryptor = BusMapDecrypt(self.key)

    def get_key(self):

        r = requests.get(
            self.BASE + "/web/public/auth/decrypt_key",
            headers=self.headers
        )

        key = r.text.strip()

        if key.startswith('"'):
            key = key[1:-1]

        return key

    def get(self, url, params=None):

        r = requests.get(
            self.BASE + url,
            headers=self.headers,
            params=params
        )

        encrypted = r.json()

        decrypted = self.decryptor.decrypt(encrypted)

        return json.loads(decrypted)
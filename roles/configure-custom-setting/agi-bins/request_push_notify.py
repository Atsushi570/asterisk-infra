#!/usr/bin/python3
import http.client
import base64

# 接続先の設定
host = "192.168.1.8:8000"
url = "/resources"
username = "user"
password = "password"

auth = f"{username}:{password}"
encoded_auth = base64.b64encode(auth.encode()).decode("ascii")
headers = {"Authorization": f"Basic {encoded_auth}"}

conn = http.client.HTTPConnection(host)
conn.request("GET", url, headers=headers)

response = conn.getresponse()

print(response.status, response.reason)
print(response.read().decode())

conn.close()

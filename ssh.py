import os.path
import requests

keys = requests.get("https://breq.dev/keys/ssh.txt").text.split("\n")

keyfile = os.path.expanduser("~/.ssh/authorized_keys")

try:
    with open(keyfile, "r") as f:
        existing = [key.strip() for key in f.readlines()]
except FileNotFoundError:
    existing = []

new = [key for key in keys if key not in existing]

with open(keyfile, "a") as f:
    f.writelines([key + "\n" for key in new])

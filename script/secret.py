import random
import base64
import sys
import os
import re

assert len(sys.argv) > 3

pattern = re.compile(r'secret\[(.*)\]\{(.*)\}', re.M | re.S | re.A)
key = None
if "dotfile_encrypt_key" in os.environ:
    key = os.environ["dotfile_encrypt_key"]


def encryptFile(input, output):
    if key == None:
        assert os.system(
            'gpg --no-symkey-cache -o "{}" -c "{}"'.format(output, input)) == 0
    else:
        assert os.system(
            'gpg --no-symkey-cache --batch --passphrase "{}" -o "{}" -c "{}"'.format(key, output, input)) == 0


def decryptFile(input, output):
    if key == None:
        assert os.system(
            'gpg --no-symkey-cache -o "{}" -d "{}"'.format(output, input)) == 0
    else:
        assert os.system(
            'gpg --no-symkey-cache --batch --passphrase "{}" -o "{}" -d "{}"'.format(key, output, input)) == 0


def encryptText(text):
    print("Encrypt block: {}".format(text))
    fileName = "/tmp/{}.tmp".format(str(random.randint(10**3, 10**8)))
    resultFile = fileName + ".encrypt"
    # print(fileName)
    # print(resultFile)
    with open(fileName, "w") as output:
        output.write(text)
    encryptFile(fileName, resultFile)
    os.remove(fileName)
    with open(resultFile, "rb") as result:
        t = result.read()
        os.remove(resultFile)
        return str(base64.encodebytes(t), encoding='utf-8').strip().replace('\n', '')


def decryptText(text):
    print("Decrypt text:" + text)
    fileName = "/tmp/{}.tmp".format(str(random.randint(10**3, 10**8)))
    resultFile = fileName + ".decrypt"
    # print(fileName)
    # print(resultFile)
    with open(fileName, "wb") as file:
        file.write(base64.decodebytes(text.encode('utf-8')))
    decryptFile(fileName, resultFile)
    os.remove(fileName)
    with open(resultFile, "r") as result:
        t = result.read()
        os.remove(resultFile)
        return t


def encryptPartFile(text):
    return pattern.sub(lambda x: "secret[" + x.group(1)+"]{" + encryptText(x.group(2))+"}", text)


def decryptPartFile(text):
    return pattern.sub(lambda x: "secret[" + x.group(1)+"]{" + decryptText(x.group(2))+"}", text)


if sys.argv[1] == "--ef":
    # encrypt whole file
    encryptFile(sys.argv[2], sys.argv[3])
elif sys.argv[1] == "--df":
    # decrypt whole file
    decryptFile(sys.argv[2], sys.argv[3])
elif sys.argv[1] == "--el":
    # encrypt a line and add it with comment
    with open(sys.argv[2]) as f:
        content = encryptPartFile(f.read())
        with open(sys.argv[3], "w") as o:
            o.write(content)
elif sys.argv[1] == "--dl":
    # encrypt a line and add it with comment
    with open(sys.argv[2]) as f:
        content = decryptPartFile(f.read())
        with open(sys.argv[3], "w") as o:
            o.write(content)

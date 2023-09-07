import os
import zipfile
import tarfile

# Developed by DevTae@2023
# 전체 압축 파일에 대한 자동 스크립트 제작을 위한 파이썬 코드입니다.
# 1. python make_extract_all_sh.py
# 2. bash extract_all.sh

def extract_cmd(path, file):
    if file.endswith(".zip"):
        ext = ".zip"
        file = os.path.join(path, file).replace(" ", "\\ ")
        directory = file.replace(ext, "")
        cmd = "mkdir -p " + directory + "\n"
        return cmd + "unzip -n " + file + " -d " + directory

    elif file.endswith(".tar"):
        ext = ".tar"
        file = os.path.join(path, file).replace(" ", "\\ ")
        directory = file.replace(ext, "")
        cmd = "mkdir -p " + directory + "\n"
        return cmd + "tar -xvfk " + file + " -C " + directory

    elif file.endswith(".tar.gz"):
        ext = ".tar.gz"
        file = os.path.join(path, file).replace(" ", "\\ ")
        directory = file.replace(ext, "")
        cmd = "mkdir -p " + directory + "\n"
        return cmd + "tar -zxvfk " + file + " -C " + directory

    return None


with open("extract_all.sh", "w") as f:
    for idx, (path, folder, files) in enumerate(os.walk(os.getcwd())):
        if file != []:
            for file in files:
                cmd = extract_cmd(path, file)
                if cmd != None:
                    print(cmd)
                    f.write(cmd + "\n")


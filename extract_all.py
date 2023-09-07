import os
import zipfile
import tarfile

# Developed by DevTae@2023
# .zip, .tar, .tar.gz 에 대한 모든 압축 파일을 해제하는 코드입니다.

def extract(path, file):
    if file.endswith(".zip"):
        ext = ".zip"
        with zipfile.ZipFile(os.path.join(path, file), 'r') as zip_ref:
            directory = file.replace(ext, "")
            directory = os.path.join(path, directory)
            os.mkdir(directory)
            zip_ref.extractall(directory)
        return True
    elif file.endswith(".tar"):
        ext = ".tar"
        with tarfile.open(os.path.join(path, file), 'r') as tar:
            directory = file.replace(ext, "")
            directory = os.path.join(path, directory)
            os.mkdir(directory)
            tar.extractall(directory)
        return True
    elif file.endswith(".tar.gz"):
        ext = ".tar.gz"
        with tarfile.open(os.path.join(path, file), 'r:gz') as tar:
            directory = file.replace(ext, "")
            directory = os.path.join(path, directory)
            os.mkdir(directory)
            tar.extractall(directory)
        return True

    return False


for idx, (path, folder, files) in enumerate(os.walk(os.getcwd())):
    if file != []:
        for file in files:
            if extract(path, file) == True:
                print(idx, path, file)
        

    
   

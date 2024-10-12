# LinuxScripts

- Bash Script List
  - `extract_all.py`
    - .zip, .tar, .tar.gz 에 대한 모든 압축 파일을 해제하는 스크립트
  - `make_extract_all_sh.py`
    - 전체 압축 파일에 대한 자동 스크립트 제작을 위한 파이썬 코드
  - `tar_gz_part.sh`
    - 용량 등의 이유로 .tar.gz.part* 에 대한 압축해제와 압축 파일 삭제를 동시에 진행하고 싶을 때 사용할 수 있는 스크립트
  - `unzip_all.sh`
    - 경로에 상관 없이 모든 압축 파일의 내부 파일들에 대하여 현재 디렉토리에 압축 하제하는 스크립트
  - `get-xwindow.sh`
    - x-window user access 를 얻기 위한 xauth cache config 설정 스크립트
  - `user_add_batch.sh`
    - **리눅스 사용자 자동 등록, 디렉토리 생성 및 Docker 권한 설정** 스크립트
  - `user_del_batch.sh`
    - **리눅스 사용자 제거, 디렉토리 제거 및 Docker 권한 해제 설정** 스크립트
  - `nvidia-smi.sh`
    - **GPU 메모리 사용량 모니터링** 스크립트
  - `gpu_slack_alert.sh`
    - **GPU 메모리 모니터링 및 위험 알림** 스크립트

+) Dependabot 추가
  
-----

# MILab Server Setting Manual (written by DevTae)

## Rufus 기반으로 부팅 usb 제작
 - ubuntu server 20.04 다운로드 및 rufus 프로그램을 바탕으로 부팅 usb 를 제작한다.

## 바이오스 설정 기반으로 우분투 서버 다운로드
 - halt -p 하여 종료한 후, usb 꽂고 부팅.
 - Del 및 별도의 버튼을 눌러 바이오스 세팅에 들어가서 부팅 순위 1위를 usb 로 설정한다.
 - 언어 - English 설정하고 done.
 - 네트워크 설정 (상세한 옵션은 아래에 표시해놨음) 이후 done, continue without updating 진행. 
 - storage configuration 에서 mount point / 를 unmount 한 뒤, unmount 된 ubuntu-lv 에 max 1.816T 를 할당하고 / 에 mount 한다.
 - your name : a, your server's name : milab, pick a username : a, choose a password : 1111, confirm your password : 1111 으로 입력 후, done.
 - Install OpenSSH Server 체크 후, done.
 - featured server snaps 에서 선택하지 않고 done.
 - 서버 설치 진행.
 - reboot now. usb 뽑고 enter.
 - a / 1111 로 로그인 한 뒤에, ssh 포트 설정부터 다시 진행하자.

## 네트워크 설정
- ipv4 - manual 설정
```
subnetmask : 255.255.255.255 // x
subnet : {subnet-mask}/24
ip : {ip}
gateway : {gateway}
name server : 8.8.8.8
search server : 8.8.4.4
```

- 만약 설치할 때, dhcp 로 설정하였다면 다음과 같이 설정한다. 설치 때 잘 설정했다면 패스해도 된다.

```
vi /etc/netplan/00-installer-config.yaml

network:
  ethernets:
    enp4s0:
      addresses:
      - {ip}/24
      gateway4: {gateway}
      nameservers:
        addresses:
        - 8.8.8.8
        search:
        - 8.8.4.4
  version: 2

netplan apply
sudo reboot
```

- 여기까지가 ubuntu server 20.04 설치 완료 단계임.

-----

## ssh 포트 변경
- sudo vi /etc/ssh/sshd_config
- #Port 22 -> Port 12345 # 주석 해제한 후 22 를 12345 로 변경.
- 저장한 뒤에, sudo systemctl restart ssh 실행. sudo systemctl status ssh 를 통해, 실행 여부를 확인한다.

## 랩실 사용자 추가 및 사용자별 실행 권한 설정
- user_add_batch.sh 파일 scp 를 통하여 전송하고, 실행하여 유저들을 등록한다. (스크립트를 사용하지 않는다면 랩 인원에 대한 아이디와 비밀번호를 통해 직접 adduser 한 후에 /etc/sudoers.d 에 대한 처리도 해주어야 한다.)
- scp -P 12345 C:/user_add_batch.sh a@{ip}:/home/a 를 통하여 파일을 전송한다.
- root 계정(sudo -s)으로 chmod +x user_add_batch.sh 하고 bash user_add_batch.sh 하면 된다.
- +) 만약 \r 관련 에러가 발생한다면 dos2unix user_add_batch.sh 한 후에 다시 bash user_add_batch.sh 를 실행한다.
- +) 만약 계정을 삭제하고 싶다면 user_del_batch.sh 를 사용하자.

## 디스크 마운트 및 권한 설정
- fdisk -l 를 통하여 하드디스크를 탐지한다. dev 폴더 내에 매핑되어 있는 경로를 기억하고 다음과 같은 명령어를 실행한다.
 (계획)
  - / : 루트 디렉토리 (1.819T)
  - /hdd1 : 도커 이미지 다운로드 (따라서, root 만 권한) (각각 10.914T)
  - /hdd2 : 개인 별 데이터셋 다운로드 및 공유디렉토리로써 사용 (모든 사용자에게 권한 줌) (각각 10.914T)
  - sudo blkid -o list 실행하면 연결된 디스크들이 나오게 됨. 11TB 디스크 두 개를 선택.
  - /etc/fstab 에서 내용을 추가한다. (mount 시킨 후에 수정해도 됨.)
  - 열게 되면, 장치 이름, Mount 위치, File System Type, 옵션 및 권한, Dump 여부, 검사 여부가 순서대로 적혀 있다.
  - 여기서 옵션 및 권한만 설정하면 된다. (mount 하고 수정하거나@@ (이게 편할 듯), 바로 fstab 에 추가하는 방식으로 진행하자..)
  - ex) UUID={disk에 대한 uuid}	/hdd1	ext4	rw,nouser,auto,exec,suid	0	0
  - ex) UUID={disk에 대한 uuid}	/hdd2	ext4	rw,user,auto,exec,suid	0	0
  -> 그냥 defaults 로 설정

- 정리
  - sudo fdisk -l 를 통하여 디스크 두 개 경로 확인 (ex. /dev/sda1, /dev/sdb1)
  - cd /
  - sudo mkdir hdd1
  - sudo mkdir hdd2
  - sudo vi /etc/fstab 한 뒤에 다음 
  - /dev/sda1	/hdd1	ext4	defaults	0	0
  - /dev/sdb1	/hdd2	ext4	defaults	0	0
  - 두 줄을 추가해주고 reboot 를 해준다.
  - 그리고선, 다음 세 줄을 실행해준다.
  - sudo chmod 700 -R /hdd1
  - sudo chmod 777 -R /hdd2 // -R 옵션이 recursive 하게 모든 폴더에 적용하도록 함.
  - cp -r /home/* /hdd2
  - 이렇게 되면 /hdd2/{user_name} 이 각자의 디렉토리가 될 것이다.

## 그래픽카드 드라이버 및 CUDA 설치
 - CUDA 12.0 + nvidia dirver 525 다운로드 진행
 - CUDA 를 설치하면서 자동으로 nvidia driver 가 설치되는 것이 가장 안정적임.
   - 추가적으로, 현재 cuda 기반으로 깔았을 때, 문제가 발생할 수 있음이 발견되었다.
   - 해당 경우에, sudo apt-get --purge remove *nvidia* 후에 sudo apt-get install nvidia-driver-525 를 진행하여 재설치한 후 재부팅까지 진행하여 다시 설치하도록 하자.
 - https://developer.nvidia.com/cuda-12-0-0-download-archive?target_os=Linux&target_arch=x86_64
 - 다음 명령어들을 실행하자.
 - sudo apt-get install build-essential
 - wget https://developer.download.nvidia.com/compute/cuda/12.0.0/local_installers/cuda_12.0.0_525.60.13_linux.run
 - sudo bash cuda_12.0.0_525.60.13_linux.run
 - 그래픽카드 드라이버까지 설치하자.
 - sudo -s
 - vi ~/.bashrc
 - 아랫줄에 다음 두 줄 추가 한 뒤에, source ~/.bashrc 진행
 - export PATH="/usr/local/cuda-12.0/bin:$PATH"
 - export LD_LIBRARY_PATH="/usr/local/cuda-12.0/lib64:$LD_LIBRARY_PATH"


## 도커 설치 (root directory 변경)
 - https://dongle94.github.io/docker/docker-ubuntu-install/ 설치
 - sudo apt update
 - sudo apt-get install -y ca-certificates curl software-properties-common apt-transport-https gnupg lsb-release
 - sudo mkdir -p /etc/apt/keyrings
 - curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
 - echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
 - sudo apt update
 - sudo apt install docker-ce docker-ce-cli containerd.io
 - distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
   && curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add - \
   && curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
 - sudo apt update
 - sudo apt install nvidia-docker2
 - su {일반유저}
 - cuda 이미지 가져와서 테스트 진행 (--gpus all 옵션 있어야 함)

## Docker 루트 디렉토리 변경
 - sudo -s
 - service docker stop
 - mv /var/lib/docker /hdd1/docker
 - vi /etc/docker/daemon.json 에 들어가서,
   - "runtimes" 키 말고 하나 더 "data-root": "/hdd1/docker"를 추가한다.
 - service docker start
 - service docker status
 - docker info 를 통하여 확인할 수 있다.

## containerd 루트 디렉토리 변경
 - sudo -s
 - systemctl stop containerd
 - mv /var/lib/containerd /hdd1/containerd
 - vi /etc/containerd/config.toml
   - containerd  설정 파일이 없는 경우 !
   - mkdir -p /etc/containerd
   - containerd config default > /etc/containerd/config.toml
 - root = "/var/lib/containerd" -> "/hdd1/containerd" 로 변경
 - systemctl start containerd

## 자동절전 해제 
- 출처 : https://heekangpark.github.io/linux/ubuntu-server-sleep

- 현재 서버에 절전 모드가 설정되어 있는지를 확인해 보고 싶다면 다음 명령어를 입력해 보면 된다.
- systemctl status sleep.target suspend.target hibernate.target hybrid-sleep.target

- Loaded가 loaded로 되어 있다면 절전 모드 설정이 되어 있는 것이다. 서버 모드에 왜 디폴트로 절전 모드 설정이 되어 있는지는 도저히 이해가 되지 않지만, 해결법은 다음과 같다.
- sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target

- 이제 다시 systemctl status 명령어로 설정값을 확인해 보면 다음과 같이 나온다.
- systemctl status sleep.target suspend.target hibernate.target hybrid-sleep.target

- 만약 (이해할 순 없지만) 다시 절전모드 설정을 되돌리고 싶다면 다음 명령어를 입력하면 된다.
- sudo systemctl unmask sleep.target suspend.target hibernate.target hybrid-sleep.target

## 전파 메뉴얼
- 서버 다시 가동했습니다! 원하시는 데이터셋을 /hdd2/{username} 에 저장한 뒤에 다음 명령어로 docker 이미지 실행하시면 다운 받은 데이터를 docker 이미지 안에서 이용할 수 있습니다.
- sudo docker --it --gpus all -v /hdd2/{username}:/data {imagename}

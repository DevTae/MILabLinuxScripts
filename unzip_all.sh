#!/bin/bash
# 경로에 상관 없이 모든 압축 파일의 내부 파일들에 대하여 현재 디렉토리에 압축 하제하는 스크립트입니다.

ext="*.zip"

for zipfile in $(find . -name $ext | sort)
do
    unzip $zipfile
done

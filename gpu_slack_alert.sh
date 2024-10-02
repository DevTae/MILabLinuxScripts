#!/bin/bash

WEBHOOK_URL="your_webhook_url"

gpu_process_count=$(nvidia-smi --query-compute-apps=pid --format=csv,noheader | wc -l)

if [ "$gpu_process_count" -gt 1 ]; then
    message="[Warning] 2 개 이상의 프로세스에서 학습을 진행합니다. 최근 학습 시작한 연구원은 학습 프로세스를 종료하시길 바랍니다."

    curl -X POST -H 'Content-type: application/json' --data "{
        \"text\": \"$message\"
    }" $WEBHOOK_URL

    # 종료하지 않으면 프로세스 kill 진행
    # todo
fi

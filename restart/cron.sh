#!/bin/sh

DATE=$(date +%Y-%m-%d-%H-%M-%S)

DISCORD_WEBHOOK_URL="https://discord.com/api/webhooks/1279141999332823053/yTts_zBdBG1rvjV58Q8rlxVwT5SYnF-Kd-pvticaP_TIwa28S4z8FiwuSy-mrv4QklUt"

send_restart_notification() {
  local server_name=$1
  local timestamp=$(date --utc +"%Y-%m-%dT%H:%M:%SZ")
  local payload=$(cat <<EOF
{
  "content": "",
  "embeds": [{
    "title": "サーバー (${server_name}) の再起動を開始します",
    "description": "再起動が完了するまでしばらくお待ちください",
    "color": "45973",
    "timestamp": "$timestamp"
    }
  ]
}
EOF
)
  # Send POST request to Discord Webhook
  curl -H "Content-Type: application/json" -X POST -d "$payload" $DISCORD_WEBHOOK_URL
}

send_complete_notification() {
  local server_name=$1
  local elapsed_time=$2
  local timestamp=$(date --utc +"%Y-%m-%dT%H:%M:%SZ")
  local payload=$(cat <<EOF
{
  "content": "",
  "embeds": [{
    "title": "サーバー (${server_name}) の再起動が完了しました",
    "description": "ログインが可能になるまで数分かかる場合があります",
    "color": "45973",
    "timestamp": "$timestamp",
    "fields": [
        {
          "name": "再起動に掛かった時間",
          "value": "${elapsed_time}秒",
          "inline": true
        }
      ]
    }
  ]
}
EOF
)
  # Send POST request to Discord Webhook
  curl -H "Content-Type: application/json" -X POST -d "$payload" $DISCORD_WEBHOOK_URL
}

send_restart_notification "alpha"
start_time=$(date +%s)
docker-compose -f /host-rootfs/infrastructure/minecraft/compose.yaml restart alpha
end_time=$(date +%s)
elapsed_time=$(( end_time - start_time ))
send_complete_notification "alpha" $elapsed_time

send_restart_notification "beta"
start_time=$(date +%s)
docker-compose -f /host-rootfs/infrastructure/minecraft/compose.yaml restart beta
end_time=$(date +%s)
elapsed_time=$(( end_time - start_time ))
send_complete_notification "beta" $elapsed_time

send_restart_notification "gamma"
start_time=$(date +%s)
docker-compose -f /host-rootfs/infrastructure/minecraft/compose.yaml restart gamma
end_time=$(date +%s)
elapsed_time=$(( end_time - start_time ))
send_complete_notification "gamma" $elapsed_time
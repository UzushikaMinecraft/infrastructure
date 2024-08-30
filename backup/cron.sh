#!/bin/sh

DATE=$(date +%Y-%m-%d-%H-%M-%S)

DISCORD_WEBHOOK_URL="https://discord.com/api/webhooks/1269212346677723157/gOCRwxryLQ-tgqa3BfTnn42IwNMQwpta2t1-oUUCuf45gmPHtpEtgX9Z5R2KElSYYAcj"

send_discord_notification() {
  local message=$1
  local elapsed_time=$2
  local data_size=$3
  local timestamp=$(date --utc +"%Y-%m-%dT%H:%M:%SZ")
  local payload=$(cat <<EOF
{
  "content": "",
  "embeds": [{
    "title": "サーバーデータのバックアップ",
    "description": "$message",
    "color": "45973",
    "timestamp": "$timestamp",
    "fields": [
        {
          "name": "サーバーデータ容量",
          "value": "${data_size}B",
          "inline": true
        },
        {
          "name": "書き込みに掛かった時間",
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


send_disk_info() {
  local disk_info_1=$(df -h "/host-rootfs/mnt/storage1" | tail -1)
  local total_1=$(echo "$disk_info_1" | awk '{print $2}')
  local used_1=$(echo "$disk_info_1" | awk '{print $3}')
  local available_1=$(echo "$disk_info_1" | awk '{print $4}')
  local percent_used_1=$(echo "$disk_info_1" | awk '{print $5}' | sed 's/%//')
  local percent_free_1=$((100 - percent_used_1))

  local disk_info_2=$(df -h "/host-rootfs/mnt/storage2" | tail -1)
  local total_2=$(echo "$disk_info_2" | awk '{print $2}')
  local used_2=$(echo "$disk_info_2" | awk '{print $3}')
  local available_2=$(echo "$disk_info_2" | awk '{print $4}')
  local percent_used_2=$(echo "$disk_info_2" | awk '{print $5}' | sed 's/%//')
  local percent_free_2=$((100 - percent_used_2))

  local timestamp=$(date --utc +"%Y-%m-%dT%H:%M:%SZ")
  local payload=$(cat <<EOF
{
  "content": "",
  "embeds": [{
    "title": "ストレージ情報",
    "description": "$message",
    "color": "45973",
    "timestamp": "$timestamp",
    "fields": [
        {
          "name": "プライマリストレージ: /mnt/storage1",
          "value": "${used_1}B / ${total_1}B (${percent_used_1}% 使用中 / ${percent_free_1}% 使用可能)",
          "inline": true
        },
        {
          "name": "セカンダリストレージ: /mnt/storage2",
          "value": "${used_2}B / ${total_2}B (${percent_used_2}% 使用中 / ${percent_free_2}% 使用可能)",
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

get_directory_size() {
    local directory="$1"

    # Check if the directory exists
    if [ ! -d "$directory" ]; then
        echo "Error: Directory $directory does not exist."
        return 1
    fi

    # Get the total size of the directory in human-readable format
    local size=$(du -sh "$directory" | awk '{print $1}')

    # Return the size
    echo "$size"
}

data_size=$(get_directory_size "/host-rootfs/infrastructure/minecraft/")

mkdir -p /host-rootfs/mnt/storage1/backup/minecraft/${DATE}
start_time=$(date +%s)
cp -R /host-rootfs/infrastructure/minecraft/ /host-rootfs/mnt/storage1/backup/minecraft/${DATE}
end_time=$(date +%s)
elapsed_time=$(( end_time - start_time ))
send_discord_notification "プライマリストレージへの書き込みが完了しました" $elapsed_time $data_size

mkdir -p /host-rootfs/mnt/storage2/backup/minecraft/${DATE}
start_time=$(date +%s)
cp -R /host-rootfs/infrastructure/minecraft/ /host-rootfs/mnt/storage2/backup/minecraft/${DATE}
end_time=$(date +%s)
elapsed_time=$(( end_time - start_time ))
send_discord_notification "セカンダリストレージへの書き込みが完了しました" $elapsed_time $data_size

send_disk_info
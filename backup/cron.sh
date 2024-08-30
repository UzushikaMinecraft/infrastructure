#!/bin/sh

DATE=$(date +%Y-%m-%d-%H-%M-%S)

discord_url="https://discord.com/api/webhooks/1269212346677723157/gOCRwxryLQ-tgqa3BfTnn42IwNMQwpta2t1-oUUCuf45gmPHtpEtgX9Z5R2KElSYYAcj"

send_discord_notification() {
  local message=$1
  
  # Construct payload
  local payload=$(cat <<EOF
{
  "content": "$message"
}
EOF
)

  # Send POST request to Discord Webhook
  curl -H "Content-Type: application/json" -X POST -d "$payload" $discord_url
}

mkdir -p /mnt/storage1/backup/minecraft/alpha/${DATE}
cp -R /app/alpha/world* /mnt/storage1/backup/minecraft/alpha/${DATE}
send_discord_notification "ワールドデータ alpha (world, world_nether, world_the_end) のバックアップ: /mnt/storage1/backup/minecraft/alpha/${DATE} (プライマリストレージ) への保存が完了しました"
mkdir -p /mnt/storage2/backup/minecraft/alpha/${DATE}
cp -R /app/alpha/world* /mnt/storage2/backup/minecraft/alpha/${DATE}
send_discord_notification "ワールドデータ alpha (world, world_nether, world_the_end) のバックアップ: /mnt/storage2/backup/minecraft/alpha/${DATE} (セカンダリストレージ) への保存が完了しました"

mkdir -p /mnt/storage1/backup/minecraft/beta/${DATE}
cp -R /app/beta/world* /mnt/storage1/backup/minecraft/beta/${DATE}
send_discord_notification "ワールドデータ beta (world, world_nether, world_the_end) のバックアップ: /mnt/storage1/backup/minecraft/beta/${DATE} (プライマリストレージ) への保存が完了しました"
mkdir -p /mnt/storage2/backup/minecraft/${DATE}
cp -R /app/beta/world* /mnt/storage2/backup/minecraft/beta/${DATE}
send_discord_notification "ワールドデータ beta (world, world_nether, world_the_end) のバックアップ: /mnt/storage2/backup/minecraft/beta/${DATE} (セカンダリストレージ) への保存が完了しました"

mkdir -p /mnt/storage1/backup/minecraft/gamma/${DATE}
cp -R /app/beta/world* /mnt/storage1/backup/minecraft/gamma/${DATE}
send_discord_notification "ワールドデータ gamma (world, world_nether, world_the_end) のバックアップ: /mnt/storage1/backup/minecraft/gamma/${DATE} (プライマリストレージ) への保存が完了しました"
mkdir -p /mnt/storage2/backup/minecraft/${DATE}
cp -R /app/gamma/world* /mnt/storage2/backup/minecraft/gamma/${DATE}
send_discord_notification "ワールドデータ gamma (world, world_nether, world_the_end) のバックアップ: /mnt/storage2/backup/minecraft/gamma/${DATE} (セカンダリストレージ) への保存が完了しました"
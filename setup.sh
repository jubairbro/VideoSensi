#!/data/data/com.termux/files/usr/bin/bash

# ┌──────────────────────────────────────────────────────────────┐
# │                    VideoSensi Setup                         │
# │──────────────────────────────────────────────────────────────│
# │    Installs dependencies and configures the tool            │
# └──────────────────────────────────────────────────────────────┘

echo -e "\033[1;34m[⚡] Installing VideoSensi...\033[0m"

# Install dependencies
pkg update -y
pkg install curl wget ffmpeg bc -y

# Create directories
mkdir -p /sdcard/VideoSensi /sdcard/VideoSensi/logs /sdcard/VideoSensi/backups

# Install videosensi globally
cp videosensi /data/data/com.termux/files/usr/bin/videosensi
chmod +x /data/data/com.termux/files/usr/bin/videosensi

# Create default config if not exists
if [[ ! -f "/data/data/com.termux/files/home/.videosensi.conf" ]]; then
    cat > /data/data/com.termux/files/home/.videosensi.conf << EOF
THEME="Neon"
NOTIFY="y"
WATERMARK_TEXT="@JubairZ"
WATERMARK_POS="top-left"
WATERMARK_COLOR="white"
EOF
fi

echo -e "\033[1;32m[✓] VideoSensi installed! Run '\033[1;33mvideosensi\033[1;32m' to start.\033[0m"

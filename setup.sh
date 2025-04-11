# ┌──────────────────────────────────────────────────────────────┐
# │                    VideoSensi Setup                         │
# │──────────────────────────────────────────────────────────────│
# │    Installs dependencies and configures the tool            │
# └──────────────────────────────────────────────────────────────┘

#!/data/data/com.termux/files/usr/bin/bash

#=======================#[ VideoSensi Setup Script ]#=======================#
# Description : Sets up VideoSensi globally with all dependencies.
# Author      : JubairBro
# GitHub      : https://github.com/jubairbro/VideoSensi
#========================================================================#

# Colors
red="\e[31m"; green="\e[32m"; yellow="\e[33m"; blue="\e[34m"; reset="\e[0m"
bold="\e[1m"

# Banner
clear
echo -e "${blue}${bold}╔════════════════════════════════════════════════════╗"
echo -e "║               WELCOME TO VIDEOSENSI              ║"
echo -e "╚════════════════════════════════════════════════════╝${reset}"

# Check storage
if [ ! -d "/sdcard" ]; then
  echo -e "${red}Error: /sdcard not found. Please grant storage permission.${reset}"
  termux-setup-storage
  exit 1
fi

# Create output directory
mkdir -p /sdcard/VideoSensi/

# Remove old global version if exists
if [ -f "/data/data/com.termux/files/usr/bin/videosensi" ]; then
  echo -e "${yellow}Old videosensi version found. Replacing...${reset}"
  rm -f /data/data/com.termux/files/usr/bin/videosensi
fi

# Copy videosensi script to bin
cp videosensi /data/data/com.termux/files/usr/bin/videosensi
chmod +x /data/data/com.termux/files/usr/bin/videosensi

# FFmpeg installation
if ! command -v ffmpeg &> /dev/null; then
  echo -e "${yellow}Installing FFmpeg...${reset}"
  pkg update -y && pkg upgrade -y
  pkg install ffmpeg -y
fi

# Update checker block
echo -e "${blue}${bold}\nChecking for updates...${reset}"
LATEST_VERSION="$(cat update.txt | grep 'Version:' | awk '{print $2}')"
echo -e "${green}Installed Version: ${LATEST_VERSION}${reset}"

# Complete message
echo -e "\n${green}VideoSensi setup completed successfully!${reset}"
echo -e "${bold}You can now run the tool by typing: ${yellow}videosensi${reset}"

# Refresh shell
hash -r
exit 0

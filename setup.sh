#!/bin/bash

#=========================
#   VideoSensi Installer
#=========================

bold=$(tput bold)
normal=$(tput sgr0)
cyan="\e[96m"
green="\e[92m"
red="\e[91m"
yellow="\e[93m"
purple="\e[95m"
blue="\e[94m"
gray="\e[90m"
reset="\e[0m"

clear
printf "${cyan}${bold}"
echo "┌──────────────────────────────────────────────┐"
echo "│        Installing VideoSensi v1.0           │"
echo "└──────────────────────────────────────────────┘"
printf "${reset}"
sleep 1

# Create folders
mkdir -p /sdcard/VideoSensi/logs > /dev/null 2>&1

# Copy videosensi to /data/data/com.termux/files/usr/bin
cp videosensi /data/data/com.termux/files/usr/bin/
chmod +x /data/data/com.termux/files/usr/bin/videosensi

# Update checker
printf "${blue}Checking for updates...${reset}\n"
git clone --depth=1 https://github.com/jubairbro/videosensi temp_update 2>/dev/null
if [[ -f temp_update/update.txt ]]; then
    current="v1.0"
    latest=$(cat temp_update/update.txt | head -n 1)
    if [[ "$current" != "$latest" ]]; then
        printf "${yellow}New version available: $latest${reset}\n"
    else
        printf "${green}You have the latest version.${reset}\n"
    fi
fi
rm -rf temp_update

# FFmpeg Check
printf "${blue}Checking FFmpeg...${reset}\n"
if ! command -v ffmpeg &> /dev/null; then
    printf "${yellow}FFmpeg not found. Installing...${reset}\n"
    pkg install ffmpeg -y || {
        echo "${red}Failed to install FFmpeg. Try again manually.${reset}"
        exit 1
    }
fi

printf "${green}Setup complete! Run with: videosensi${reset}\n"
echo

# Telegram prompt
echo -e "${purple}Join Telegram Channel: https://t.me/JubairFF${reset}"
echo

exit 0

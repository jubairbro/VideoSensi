#!/data/data/com.termux/files/usr/bin/bash

# Colors
red="\e[1;91m"
green="\e[1;92m"
cyan="\e[1;96m"
reset="\e[0m"

# Banner
echo -e "${cyan}"
echo "====================================================="
echo "            VIDEO SENSI INSTALLATION SCRIPT          "
echo "====================================================="
echo -e "${reset}"

# Check if ffmpeg is installed
echo -e "${cyan}Checking for FFmpeg...${reset}"
if ! command -v ffmpeg &> /dev/null; then
    echo -e "${red}FFmpeg not found. Installing...${reset}"
    pkg update -y && pkg install ffmpeg -y
else
    echo -e "${green}FFmpeg is already installed.${reset}"
fi

# Make videosensi executable
echo -e "${cyan}Setting permissions...${reset}"
chmod +x videosensi

# Remove old global videosensi if exists
if [ -f "/data/data/com.termux/files/usr/bin/videosensi" ]; then
    echo -e "${red}Removing existing global videosensi...${reset}"
    rm -f /data/data/com.termux/files/usr/bin/videosensi
fi

# Copy to global bin
echo -e "${cyan}Installing videosensi globally...${reset}"
cp videosensi /data/data/com.termux/files/usr/bin/
chmod 755 /data/data/com.termux/files/usr/bin/videosensi

# Create output directory if not exist
mkdir -p /sdcard/VideoSensi

# Display update info
if [ -f "update.txt" ]; then
    echo -e "${cyan}Checking for updates...${reset}"
    grep "Version:" update.txt | head -1
fi

echo -e "${green}"
echo "VideoSensi setup completed successfully!"
echo -e "${reset}You can now run the tool by typing: ${cyan}videosensi${reset}"

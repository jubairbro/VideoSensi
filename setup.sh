#!/data/data/com.termux/files/usr/bin/bash

clear
echo -e "\e[1;35mSetting up videosensi tool...\e[0m"

# Grant storage access
termux-setup-storage

# Install ffmpeg if not installed
if ! command -v ffmpeg >/dev/null 2>&1; then
    echo -e "\e[1;33mInstalling ffmpeg...\e[0m"
    pkg update -y && pkg install ffmpeg -y
fi

# Set up bin path
mkdir -p ~/.videosensi
cp videosensi.sh ~/.videosensi/videosensi
cp update.sh ~/.videosensi/update

# Make executable
chmod +x ~/.videosensi/videosensi
chmod +x ~/.videosensi/update

# Add to .bashrc for global command
if ! grep -q 'videosensi' ~/.bashrc; then
    echo 'alias videosensi="bash ~/.videosensi/videosensi"' >> ~/.bashrc
    echo 'alias videosensi-update="bash ~/.videosensi/update"' >> ~/.bashrc
fi

echo -e "\n\e[1;32mSetup complete! Type \e[1;34mvideosensi\e[1;32m to start using the tool.\e[0m"
#!/data/data/com.termux/files/usr/bin/bash

# ===============================
#  VideoSensi Installer (setup)
#  Powered by: t.me/JubairFF
# ===============================

# Terminal colors
green='\e[92m'
red='\e[91m'
blue='\e[94m'
yellow='\e[93m'
nc='\e[0m'

# Clear and show logo
clear
echo -e "${blue}"
cat << 'EOF'
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
oooooo     oooo  o8o        .o8                      
 `888.     .8'   `"'       "888                      
  `888.   .8'   oooo   .oooo888   .ooooo.   .ooooo.  
   `888. .8'    `888  d88' `888  d88' `88b d88' `88b 
    `888.8'      888  888   888  888ooo888 888   888 
     `888'       888  888   888  888    .o 888   888 
      `8'       o888o `Y8bod88P" `Y8bod8P' `Y8bod8P' 
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 
      VideoSensi - Overpowered Compressor
            t.me/JubairFF
EOF
echo -e "${nc}"

# Step 1: Set permissions
echo -e "${green}[*] Setting executable permissions...${nc}"
chmod +x videosensi

# Step 2: Move to bin path
echo -e "${green}[*] Installing as global command...${nc}"
rm -f /data/data/com.termux/files/usr/bin/videosensi &>/dev/null
cp videosensi /data/data/com.termux/files/usr/bin/videosensi

# Step 3: Create config folders
mkdir -p /sdcard/VideoSensi

# Step 4: Save update info
echo "Version: 1.0.0" > update.txt

# Step 5: Finish
echo -e "\n${yellow}[✓] VideoSensi setup completed successfully!${nc}"
echo -e "${blue}You can now run the tool by typing: ${green}videosensi${nc}"

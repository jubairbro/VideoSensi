#!/data/data/com.termux/files/usr/bin/bash

echo -e "\e[1;36mChecking for updates...\e[0m"
cd ~
rm -rf videosensi-latest
git clone https://github.com/jubairbro/videosensi videosensi-latest

if [ -f videosensi-latest/videosensi.sh ]; then
    cp videosensi-latest/videosensi.sh ~/.videosensi/videosensi
    cp videosensi-latest/update.sh ~/.videosensi/update
    chmod +x ~/.videosensi/videosensi ~/.videosensi/update
    echo -e "\e[1;32m[✔] videosensi updated successfully!\e[0m"
else
    echo -e "\e[1;31m[✘] Update failed! Check internet or repo.\e[0m"
fi
rm -rf videosensi-latest
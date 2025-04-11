#!/data/data/com.termux/files/usr/bin/bash

# Branding
clear
echo -e "\e[1;35m╔════════════════════════════════════════════════════╗"
echo -e "\e[1;35m║             WELCOME TO JUBAIR BRO TOOLS            ║"
echo -e "\e[1;35m╚════════════════════════════════════════════════════╝\e[0m"
echo -e "\e[1;36m             Advanced Video Compressor for Termux\e[0m\n"

# Check if ffmpeg is installed
if ! command -v ffmpeg >/dev/null 2>&1; then
    echo -e "\e[1;31m[ERROR] ffmpeg is not installed. Please install it using: pkg install ffmpeg\e[0m"
    exit 1
fi

# Input path
read -p $'\e[1;33mEnter full path of your video: \e[0m' input
if [ ! -f "$input" ]; then
    echo -e "\e[1;31m[ERROR] File not found!\e[0m"
    exit 1
fi

# Output directory
read -p $'\e[1;33mEnter output directory (default: /storage/emulated/0/Download/): \e[0m' output_dir
output_dir="${output_dir:-/storage/emulated/0/Download/}"
mkdir -p "$output_dir"

# Compression menu
echo -e "\n\e[1;32mChoose compression level:\e[0m"
echo -e "  \e[1;34m1)\e[0m Compress 10% (Best Quality)"
echo -e "  \e[1;34m2)\e[0m Compress 20%"
echo -e "  \e[1;34m3)\e[0m Compress 30%"
echo -e "  \e[1;34m4)\e[0m Compress 40%"
echo -e "  \e[1;34m5)\e[0m Compress 50% (Smallest Size)"
read -p $'\n\e[1;33mEnter choice (1-5): \e[0m' choice

case $choice in
  1) crf=23 ;;
  2) crf=26 ;;
  3) crf=28 ;;
  4) crf=30 ;;
  5) crf=32 ;;
  *) echo -e "\e[1;31mInvalid choice. Exiting.\e[0m"; exit 1 ;;
esac

# Output name
filename=$(basename "$input")
name="${filename%.*}"
output="${output_dir}/${name}_JUBAIR.mp4"

# Compress
echo -e "\n\e[1;36m[*] Compressing with CRF=$crf ...\e[0m"
ffmpeg -i "$input" -vcodec libx264 -crf $crf -preset fast -acodec aac -b:a 128k -pix_fmt yuv420p -r 30 -movflags +faststart "$output"

# Result
if [ $? -eq 0 ]; then
    echo -e "\n\e[1;32m[✔] Compression complete!\e[0m"
    echo -e "\e[1;33m[→] Saved to: \e[1;4;92m$output\e[0m"
    echo -e "\e[1;90mvideo path: $input\e[0m"
else
    echo -e "\n\e[1;31m[✘] Compression failed!\e[0m"
    exit 1
fi

# Telegram info
echo -e "\n\e[1;36m╔══════════════════════════════════════╗"
echo -e "║     Join Telegram: t.me/JubairFF     ║"
echo -e "╚══════════════════════════════════════╝\e[0m"

read -p $'\e[1;33mPress ENTER to return...\e[0m'
clear
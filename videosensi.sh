#!/data/data/com.termux/files/usr/bin/bash

#==========================[ VideoSensi Main Script ]===========================#
# Description : A flashy, animated, feature-rich video compression tool.
# Author      : JubairBro
# GitHub      : https://github.com/jubairbro/VideoSensi
#==============================================================================#

# DO NOT EDIT ASCII LOGO BELOW — AS PER USER INSTRUCTION
clear
echo -e "\e[34m"
cat << 'EOF'
╔════════════════════════════════════════════════════════════════════╗
║                            VIDEO SENSI                            ║
║                Flashy & Powerful Termux Video Compressor          ║
╚════════════════════════════════════════════════════════════════════╝
EOF
echo -e "\e[0m"

# Variables
OUT_DIR="/sdcard/VideoSensi"
LOG_FILE="$OUT_DIR/log.txt"
LINK="https://t.me/JubairFF"

# Ensure output directory exists
mkdir -p "$OUT_DIR"

# Compression Function
compress_video() {
  local input="$1"
  local level="$2"
  local filename=$(basename "$input")
  local output="$OUT_DIR/${filename%.*}_JubairFF.mp4"

  echo -e "\e[33mCompressing...\e[0m"

  case "$level" in
    1) ffmpeg -i "$input" -vcodec libx264 -crf 35 -preset veryfast -pix_fmt yuv420p -r 30 "$output";;
    2) ffmpeg -i "$input" -vcodec libx264 -crf 28 -preset faster -pix_fmt yuv420p -r 30 "$output";;
    3) ffmpeg -i "$input" -vcodec libx264 -crf 23 -preset fast -pix_fmt yuv420p -r 30 "$output";;
    4) ffmpeg -i "$input" -vcodec libx264 -crf 18 -preset medium -pix_fmt yuv420p -r 30 "$output";;
    5) ffmpeg -i "$input" -vcodec libx264 -crf 15 -preset slow -pix_fmt yuv420p -r 30 "$output";;
    *) echo -e "\e[31mInvalid compression level!\e[0m"; return;;
  esac

  echo -e "\e[32mCompression complete!\e[0m"
  echo "video path: $output"
  echo "[ $(date) ] Compressed: $input -> $output" >> "$LOG_FILE"
}

# Main Menu
while true; do
  clear
  echo -e "\e[36m===================[ VIDEO SENSI MAIN MENU ]===================\e[0m"
  echo -e "\e[35m[1] Compress Video"
  echo -e "[2] Telegram Channel"
  echo -e "[3] View Log"
  echo -e "[4] Exit\e[0m"
  echo -n "\nChoose an option: "
  read opt

  case "$opt" in
    1)
      echo -n "Enter full path of video: "
      read vpath
      if [ ! -f "$vpath" ]; then echo -e "\e[31mFile not found!\e[0m"; read; continue; fi

      echo -e "\nChoose compression level (1-5):"
      echo "1 = Lowest (Tiny size)"
      echo "2 = Low"
      echo "3 = Medium"
      echo "4 = High"
      echo "5 = Best (Big size)"
      echo -n "> "
      read lvl

      compress_video "$vpath" "$lvl"
      read -p "Press Enter to return to menu..."
      ;;

    2)
      echo -e "\nJoin Telegram: $LINK"
      termux-open-url "$LINK"
      read -p "Press Enter to return..."
      ;;

    3)
      echo -e "\nLog file ($LOG_FILE):"
      cat "$LOG_FILE" || echo "No logs yet."
      read -p "Press Enter to return..."
      ;;

    4)
      echo -e "\e[34mExiting VideoSensi...\e[0m"
      exit 0
      ;;

    *)
      echo -e "\e[31mInvalid option!\e[0m"
      sleep 1
      ;;
  esac
done

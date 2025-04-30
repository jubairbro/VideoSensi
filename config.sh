#!/bin/bash

# Configuration for VideoSensi Pro

# Initialize variables
VERSION="3.3.1"
AUTHOR="Jubair Bro"
TOOL_NAME="VideoSensi Pro"
BASE_DIR="$HOME/.videosensi"
HIDDEN_DIR="/sdcard/VideoSensi/.JubairVault"
OUTPUT_DIR="/sdcard/VideoSensi"
OP_LOG="$HIDDEN_DIR/operation_$(date +%Y%m%d).log"
ERROR_LOG="$HIDDEN_DIR/ffmpeg_error.log"
UPDATE_URL="https://raw.githubusercontent.com/jubairbro/VideoSensi/main/videosensi"
TELEGRAM_LINK="https://t.me/JubairFF"
PROGRESS_FILE="$HIDDEN_DIR/progress"

# Color definitions
COLORS=('\033[1;34m' '\033[1;32m' '\033[1;33m' '\033[1;35m' '\033[1;36m')
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
MAGENTA='\033[1;35m'
CYAN='\033[1;36m'
RESET='\033[0m'

# Get random color
get_random_color() {
    echo "${COLORS[$RANDOM % ${#COLORS[@]}]}"
}
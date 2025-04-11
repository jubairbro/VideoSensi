#!/data/data/com.termux/files/usr/bin/bash

# ╔═══════════════════════════════════════════════╗
# ║         VideoSensi Main Script v1.0           ║
# ║      Video Compression with Style             ║
# ╚═══════════════════════════════════════════════╝

# Set variables
VERSION="1.0"
OUTPUT_DIR="/sdcard/VideoSensi"
LOG_DIR="$OUTPUT_DIR/logs"
WATERMARK_TEXT="VideoSensi by JubairFF"
LOG_FILE="$LOG_DIR/compression_$(date +%F_%H-%M-%S).log"

# Colors
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
PURPLE='\033[1;35m'
NC='\033[0m'

# Random color for dynamic UI
get_random_color() {
    colors=("$RED" "$GREEN" "$YELLOW" "$BLUE" "$CYAN" "$PURPLE")
    echo "${colors[$RANDOM % ${#colors[@]}]}"
}

# Box drawing functions
draw_box_top() {
    echo -e "${CYAN}╔═══════════════════════════════════════════════╗${NC}"
}

draw_box_bottom() {
    echo -e "${CYAN}╚═══════════════════════════════════════════════╝${NC}"
}

draw_box_line() {
    printf "${CYAN}║${NC} %-45s ${CYAN}║${NC}\n" "$1"
}

# ASCII logo
display_logo() {
    clear
    COLOR=$(get_random_color)
    draw_box_top
    draw_box_line "${COLOR}   ____ ___ ____  ___ ___  ____ ___ ${NC}"
    draw_box_line "${COLOR}  | __ )_ _|  _ \|_ _/ _ \/ ___|_ _|${NC}"
    draw_box_line "${COLOR}  |  _ \| || |_) || | | | \___ \| | ${NC}"
    draw_box_line "${COLOR}  | |_) | ||  _ < | | |_| |___) | | ${NC}"
    draw_box_line "${COLOR}  |____/___|_| \_\___\___/|____/___|${NC}"
    draw_box_line "${COLOR}          VideoSensi v$VERSION           ${NC}"
    draw_box_bottom
    sleep 2
}

# Error handling
error_exit() {
    draw_box_top
    draw_box_line "${RED}Error: $1${NC}"
    draw_box_bottom
    echo "[$(date)] ERROR: $1" >> "$LOG_FILE"
    exit 1
}

# Check if FFmpeg is installed
check_ffmpeg() {
    command -v ffmpeg >/dev/null 2>&1 || error_exit "FFmpeg not installed! Run setup.sh."
}

# Validate video file
validate_video() {
    local file="$1"
    [[ -f "$file" ]] || error_exit "File does not exist!"
    ffprobe "$file" 2>&1 | grep -q "Video" || error_exit "Not a valid video file!"
}

# Get video info
get_video_info() {
    local file="$1"
    DURATION=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$file" | awk '{print int($1/60)":"int($1%60)}')
    SIZE=$(ls -lh "$file" | awk '{print $5}')
    CODEC=$(ffprobe -v error -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "$file" | head -1)
    draw_box_top
    draw_box_line "${YELLOW}Video Info:${NC}"
    draw_box_line "Duration: $DURATION"
    draw_box_line "Size: $SIZE"
    draw_box_line "Codec: $CODEC"
    draw_box_bottom
}

# Animated progress bar
show_progress() {
    local pid=$1
    local msg=$2
    local chars=("█" "▒" "▓")
    local i=0
    while kill -0 "$pid" 2>/dev/null; do
        COLOR=$(get_random_color)
        printf "\r${COLOR}%s [%s]${NC}" "$msg" "${chars[$((i % 3))]}"
        sleep 0.3
        ((i++))
    done
    echo -e "\r${GREEN}$msg [Done]${NC}"
}

# Compression function
compress_video() {
    local input="$1"
    local level="$2"
    local watermark="$3"
    local output="$OUTPUT_DIR/$(basename "${input%.*}")_JubairFF.mp4"

    # Set compression parameters
    case $level in
        1) CRF=28; PRESET="veryfast" ;; # Very Low
        2) CRF=26; PRESET="fast" ;;     # Low
        3) CRF=24; PRESET="medium" ;;   # Medium
        4) CRF=22; PRESET="slow" ;;     # High
        5) CRF=20; PRESET="veryslow" ;; # Ultra
        *) error_exit "Invalid compression level!" ;;
    esac

    # Watermark filter
    local watermark_filter=""
    if [[ "$watermark" == "y" ]]; then
        watermark_filter="drawtext=text='$WATERMARK_TEXT':fontcolor=white:fontsize=20:x=10:y=10"
    fi

    # Run compression
    draw_box_top
    draw_box_line "${YELLOW}Starting compression (Level $level)...${NC}"
    draw_box_line "${YELLOW}কম্প্রেশন শুরু হচ্ছে (লেভেল $level)...${NC}"
    draw_box_bottom

    BEFORE_SIZE=$(ls -l "$input" | awk '{print $5}')
    ffmpeg -i "$input" -vcodec libx264 -crf "$CRF" -preset "$PRESET" \
        ${watermark_filter:+-vf "$watermark_filter"} -acodec aac -y "$output" > /tmp/ffmpeg.log 2>&1 &
    FFMPEG_PID=$!
    show_progress "$FFMPEG_PID" "Processing"
    wait "$FFMPEG_PID" || error_exit "Compression failed! Check logs."

    # Verify output
    [[ -f "$output" ]] || error_exit "Output file not created!"
    AFTER_SIZE=$(ls -l "$output" | awk '{print $5}')
    COMPRESSION_PERCENT=$(awk "BEGIN {print (1-$AFTER_SIZE/$BEFORE_SIZE)*100}")
    draw_box_top
    draw_box_line "${GREEN}Compression successful!${NC}"
    draw_box_line "${GREEN}কম্প্রেশন সফল!${NC}"
    draw_box_line "Before: $((BEFORE_SIZE/1024/1024)) MB"
    draw_box_line "After: $((AFTER_SIZE/1024/1024)) MB"
    draw_box_line "Compression: ${COMPRESSION_PERCENT%%.*}%"
    draw_box_line "Output: $output"
    draw_box_bottom
    echo "[$(date)] Compressed: $input -> $output ($COMPRESSION_PERCENT%)" >> "$LOG_FILE"
}

# Main menu
show_menu() {
    COLOR=$(get_random_color)
    draw_box_top
    draw_box_line "${COLOR}VideoSensi Compression Menu${NC}"
    draw_box_line "${COLOR}ভিডিওসেন্সি কম্প্রেশন মেনু${NC}"
    draw_box_line "1. Very Low Compression"
    draw_box_line "2. Low Compression"
    draw_box_line "3. Medium Compression"
    draw_box_line "4. High Compression"
    draw_box_line "5. Ultra Compression"
    draw_box_line "6. Exit"
    draw_box_bottom
}

# Telegram prompt
show_telegram_prompt() {
    draw_box_top
    draw_box_line "${YELLOW}Join our Telegram channel for updates!${NC}"
    draw_box_line "${YELLOW}আপডেটের জন্য আমাদের টেলিগ্রাম চ্যানেলে যোগ দিন!${NC}"
    draw_box_line "${CYAN}@JubairFF${NC}"
    draw_box_bottom
}

# Main function
main() {
    display_logo
    check_ffmpeg
    mkdir -p "$LOG_DIR" || error_exit "Failed to create log directory!"

    # Trap Ctrl+C
    trap 'error_exit "Process interrupted by user!"' INT

    while true; do
        show_menu
        read -p "$(get_random_color)Select option [1-6]: ${NC}" choice
        [[ "$choice" == 6 ]] && {
            show_telegram_prompt
            exit 0
        }
        [[ "$choice" =~ ^[1-5]$ ]] || {
            draw_box_top
            draw_box_line "${RED}Invalid option!${NC}"
            draw_box_bottom
            continue
        }

        # Get video file
        draw_box_top
        draw_box_line "${YELLOW}Enter video file path:${NC}"
        draw_box_line "${YELLOW}ভিডিও ফাইলের পাথ দিন:${NC}"
        draw_box_bottom
        read -p "$(get_random_color)Path: ${NC}" video_file
        validate_video "$video_file"
        get_video_info "$video_file"

        # Watermark option
        draw_box_top
        draw_box_line "${YELLOW}Add watermark? (y/n)${NC}"
        draw_box_line "${YELLOW}ওয়াটারমার্ক যোগ করবেন? (y/n)${NC}"
        draw_box_bottom
        read -p "$(get_random_color)Choice: ${NC}" watermark_choice
        watermark_choice=${watermark_choice,,}

        # Run compression
        compress_video "$video_file" "$choice" "$watermark_choice"
        show_telegram_prompt
    done
}

# Run main
main

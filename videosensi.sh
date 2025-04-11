#!/data/data/com.termux/files/usr/bin/bash

# ┌──────────────────────────────────────────────────────────────┐
# │                       VideoSensi v2.0                       │
# │──────────────────────────────────────────────────────────────│
# │    Ultimate Bash Video Compressor for Termux by @JubairZ     │
# │    GitHub: https://github.com/jubairbro/                    │
# │    Telegram: https://t.me/jubairFF/                        │
# │──────────────────────────────────────────────────────────────│
# │    "Compress with Style, Impress with Power"                │
# └──────────────────────────────────────────────────────────────┘

set -e

# ┌─────────────────────── Global Variables ──────────────────────┐
# │ Define colors, paths, and configurations                    │
# └──────────────────────────────────────────────────────────────┘
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
MAGENTA='\033[1;35m'
CYAN='\033[1;36m'
WHITE='\033[1;37m'
NC='\033[0m'

OUTPUT_DIR="/sdcard/VideoSensi"
LOG_DIR="/sdcard/VideoSensi/logs"
CONFIG_FILE="/data/data/com.termux/files/home/.videosensi.conf"
BACKUP_DIR="/sdcard/VideoSensi/backups"
mkdir -p "$OUTPUT_DIR" "$LOG_DIR" "$BACKUP_DIR"

LOG_FILE="$LOG_DIR/videosensi_$(date +%F_%H-%M-%S).log"
VERSION="2.0.0"
UPDATE_URL="https://raw.githubusercontent.com/jubairbro/VideoSensi/main/update.txt"

# Default config
THEME="Neon"
NOTIFY="y"
WATERMARK_TEXT="@JubairZ"
WATERMARK_POS="top-left"
WATERMARK_COLOR="white"

# Load config if exists
load_config() {
    if [[ -f "$CONFIG_FILE" ]]; then
        source "$CONFIG_FILE"
        echo -e "$(random_color)Loaded config from $CONFIG_FILE${NC}" | tee -a "$LOG_FILE"
    fi
}

# ┌─────────────────────── Utility Functions ─────────────────────┐
# │ Random colors, animations, and notifications                │
# └──────────────────────────────────────────────────────────────┘
random_color() {
    colors=($RED $GREEN $YELLOW $BLUE $MAGENTA $CYAN)
    echo "${colors[$RANDOM % ${#colors[@]}]}"
}

apply_theme() {
    case $THEME in
        Dark) RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[0;33m'; BLUE='\033[0;34m'; MAGENTA='\033[0;35m'; CYAN='\033[0;36m'; WHITE='\033[0;37m';;
        Light) RED='\033[1;91m'; GREEN='\033[1;92m'; YELLOW='\033[1;93m'; BLUE='\033[1;94m'; MAGENTA='\033[1;95m'; CYAN='\033[1;96m'; WHITE='\033[1;97m';;
        Neon) RED='\033[1;31m'; GREEN='\033[1;32m'; YELLOW='\033[1;33m'; BLUE='\033[1;34m'; MAGENTA='\033[1;35m'; CYAN='\033[1;36m'; WHITE='\033[1;37m';;
    esac
}

notify() {
    [[ "$NOTIFY" == "y" ]] && termux-toast -b black -c white "$1" || true
    echo -e "$(random_color)$1${NC}" | tee -a "$LOG_FILE"
}

animate_text() {
    local text="$1"
    local delay=0.05
    for ((i=0; i<${#text}; i++)); do
        echo -ne "$(random_color)${text:$i:1}${NC}"
        sleep $delay
    done
    echo
}

# ┌─────────────────────── Display Logo ──────────────────────────┐
# │ Animated, colorful logo with branding                       │
# └──────────────────────────────────────────────────────────────┘
display_logo() {
    clear
    apply_theme
    local logo=(
        "┌──────────────────────────────────────────────────────────────┐"
        "│                       VideoSensi v2.0                       │"
        "│──────────────────────────────────────────────────────────────│"
        "│    Ultimate Bash Video Compressor for Termux by @JubairZ     │"
        "│──────────────────────────────────────────────────────────────│"
        "│    GitHub: https://github.com/jubairbro/                    │"
        "│    Telegram: https://t.me/jubairFF/                        │"
        "└──────────────────────────────────────────────────────────────┘"
    )
    for line in "${logo[@]}"; do
        animate_text "$line"
        sleep 0.1
    done
    notify "Welcome to VideoSensi!"
}

# ┌─────────────────────── FFmpeg Checker ────────────────────────┐
# │ Install FFmpeg with 4 backup methods and retry logic        │
# └──────────────────────────────────────────────────────────────┘
check_ffmpeg() {
    if ! command -v ffmpeg &>/dev/null; then
        notify "${RED}FFmpeg not found! Attempting to install...${NC}"
        pkg_install_ffmpeg
    else
        notify "$(random_color)FFmpeg is ready! Version: $(ffmpeg -version | head -1)${NC}"
    fi
}

pkg_install_ffmpeg() {
    local attempts=3
    for method in {1..4}; do
        for attempt in $(seq 1 $attempts); do
            notify "Attempt $attempt of $attempts: Installing FFmpeg (Method $method)..."
            if "pkg_install_ffmpeg_method$method"; then
                notify "$(random_color)FFmpeg installed successfully via Method $method!${NC}"
                return 0
            fi
            notify "${RED}Method $method failed!${NC}"
            sleep 2
        done
    done
    notify "${RED}ERROR: FFmpeg installation failed after $attempts attempts!${NC}"
    exit 1
}

pkg_install_ffmpeg_method1() { pkg update -y && pkg install ffmpeg -y &>>"$LOG_FILE"; }
pkg_install_ffmpeg_method2() { pkg upgrade -y && pkg install ffmpeg -y &>>"$LOG_FILE"; }
pkg_install_ffmpeg_method3() { pkg install wget -y && wget -q https://github.com/termux/termux-packages/releases/download/ffmpeg-installer/ffmpeg-installer.sh && bash ffmpeg-installer.sh &>>"$LOG_FILE"; }
pkg_install_ffmpeg_method4() { pkg install curl -y && curl -sL https://termux.dev/ffmpeg-installer.sh | bash &>>"$LOG_FILE"; }

# ┌─────────────────────── Video Validation ──────────────────────┐
# │ Check file existence, format, size, and duration            │
# └──────────────────────────────────────────────────────────────┘
validate_video() {
    local file="$1"
    if [[ ! -f "$file" ]]; then
        notify "${RED}ERROR: File '$file' does not exist!${NC}"
        return 1
    fi
    if ! ffprobe "$file" &>/dev/null; then
        notify "${RED}ERROR: Invalid video format!${NC}"
        return 1
    fi
    local size=$(ls -l "$file" | awk '{print $5}')
    if [[ $size -lt 1024 ]]; then
        notify "${RED}ERROR: File is too small!${NC}"
        return 1
    fi
    local duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$file" 2>>"$LOG_FILE")
    if [[ -z "$duration" || $(awk "BEGIN {print ($duration < 1)}") -eq 1 ]]; then
        notify "${RED}ERROR: Invalid video duration!${NC}"
        return 1
    fi
    notify "$(random_color)Video validated successfully!${NC}"
    return 0
}

# ┌─────────────────────── Video Info ────────────────────────────┐
# │ Display detailed metadata before compression               │
# └──────────────────────────────────────────────────────────────┘
get_video_info() {
    local file="$1"
    clear
    display_logo
    notify "$(random_color)Video Information:${NC}"
    echo -e "${YELLOW}File Path:${NC} $file"
    local duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$file" | awk '{print int($1/60) " min " int($1%60) " sec"}')
    echo -e "${YELLOW}Duration:${NC} $duration"
    local codec=$(ffprobe -v error -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "$file" | head -1)
    echo -e "${YELLOW}Video Codec:${NC} $codec"
    local audio_codec=$(ffprobe -v error -select_streams a:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "$file" 2>/dev/null || echo "N/A")
    echo -e "${YELLOW}Audio Codec:${NC} $audio_codec"
    local resolution=$(ffprobe -v error -show_entries stream=width,height -of default=noprint_wrappers=1:nokey=1 "$file" | head -2 | paste -sd 'x')
    echo -e "${YELLOW}Resolution:${NC} $resolution"
    local fps=$(ffprobe -v error -select_streams v:0 -show_entries stream=r_frame_rate -of default=noprint_wrappers=1:nokey=1 "$file" | bc 2>/dev/null || echo "N/A")
    echo -e "${YELLOW}FPS:${NC} $fps"
    local bitrate=$(ffprobe -v error -show_entries format=bit_rate -of default=noprint_wrappers=1:nokey=1 "$file" | awk '{print int($1/1000)}' 2>/dev/null || echo "N/A")
    echo -e "${YELLOW}Bitrate:${NC} ${bitrate} kbps"
    local size=$(ls -lh "$file" | awk '{print $5}')
    echo -e "${YELLOW}Size:${NC} $size"
    echo
}

# ┌─────────────────────── Preview Clip ──────────────────────────┐
# │ Generate a 10-second preview before compression            │
# └──────────────────────────────────────────────────────────────┘
generate_preview() {
    local input_file="$1"
    local preview_file="$OUTPUT_DIR/preview_$(basename "$input_file" .mp4).mp4"
    notify "$(random_color)Generating 10-second preview...${NC}"
    ffmpeg -y -i "$input_file" -t 10 -c copy "$preview_file" &>>"$LOG_FILE"
    if [[ $? -eq 0 ]]; then
        notify "$(random_color)Preview saved to $preview_file${NC}"
    else
        notify "${RED}Preview generation failed!${NC}"
    fi
}

# ┌─────────────────────── Progress Bar ──────────────────────────┐
# │ Real-time FFmpeg progress parsing with colors              │
# └──────────────────────────────────────────────────────────────┘
progress_bar() {
    local pid=$1
    local bar_width=50
    while kill -0 $pid 2>/dev/null; do
        local progress=$(tail -n 10 "$LOG_FILE" | grep -oP 'time=\K[0-9:.]+' | tail -1)
        if [[ -n "$progress" ]]; then
            local percent=$(echo "$progress" | awk -F: '{print int(($1*3600+$2*60+$3)/10)}')
            local filled=$((bar_width * percent / 100))
            local empty=$((bar_width - filled))
            local bar=$(printf "%${filled}s" | tr ' ' '█')
            bar+=$(printf "%${empty}s" | tr ' ' ' ')
            echo -ne "\r$(random_color)[⚡] Compressing... [$bar] ${percent}%${NC}"
        fi
        sleep 1
    done
    echo -ne "\r$(random_color)[⚡] Compressing... [██████████████████████████████████████████████████] 100%${NC}\n"
}

# ┌─────────────────────── Backup File ───────────────────────────┐
# │ Save original file before compression                     │
# └──────────────────────────────────────────────────────────────┘
backup_file() {
    local file="$1"
    local backup_path="$BACKUP_DIR/$(basename "$file")_$(date +%F_%H-%M-%S).bak"
    cp "$file" "$backup_path" &>>"$LOG_FILE"
    notify "$(random_color)Backup saved to $backup_path${NC}"
}

# ┌─────────────────────── Compress Video ────────────────────────┐
# │ Main compression logic with watermark and format options   │
# └──────────────────────────────────────────────────────────────┘
compress_video() {
    local input_file="$1"
    local quality="$2"
    local watermark="$3"
    local format="$4"
    local filename=$(basename "$input_file" .${input_file##*.})
    local output_file="$OUTPUT_DIR/${filename}_JubairFF_$(date +%H-%M-%S).${format}"
    local original_size=$(ls -l "$input_file" | awk '{print $5}')
    local start_time=$(date +%s)

    backup_file "$input_file"

    case $quality in
        1) crf=30; scale="1280:720";;  # Low
        2) crf=25; scale="1920:1080";; # Medium
        3) crf=20; scale="1920:1080";; # High
        4) crf=15; scale="2560:1440";; # Ultra
        5) read -p "Enter custom CRF (10-50): " crf; scale="1920:1080";; # Custom
        *) notify "${RED}Invalid quality!${NC}"; return 1;;
    esac

    local ffmpeg_cmd="ffmpeg -y -i \"$input_file\" -c:v libx264 -crf $crf -preset fast -vf scale=$scale"
    if [[ "$watermark" == "y" ]]; then
        ffmpeg_cmd+=" -vf \"drawtext=text='$WATERMARK_TEXT':fontcolor=$WATERMARK_COLOR:fontsize=20:x=10:y=10\""
    fi
    case $format in
        mp4) ffmpeg_cmd+=" -c:a aac -b:a 128k";;
        mkv) ffmpeg_cmd+=" -c:a copy";;
        avi) ffmpeg_cmd+=" -c:a mp3 -b:a 192k";;
        *) notify "${RED}Invalid format!${NC}"; return 1;;
    esac
    ffmpeg_cmd+=" \"$output_file\""

    notify "$(random_color)Starting compression...${NC}"
    eval "$ffmpeg_cmd" &>>"$LOG_FILE" &
    local ffmpeg_pid=$!
    progress_bar $ffmpeg_pid &

    wait $ffmpeg_pid
    if [[ $? -eq 0 ]]; then
        local end_time=$(date +%s)
        local new_size=$(ls -l "$output_file" | awk '{print $5}')
        local compression_pct=$(awk "BEGIN {printf \"%.2f\", (1 - $new_size/$original_size)*100}")
        local duration=$((end_time - start_time))
        notify "$(random_color)Compression Complete!${NC}"
        echo -e "${YELLOW}Output Path:${NC} $output_file"
        echo -e "${YELLOW}New Size:${NC} $(ls -lh "$output_file" | awk '{print $5}')"
        echo -e "${YELLOW}Compression:${NC} $compression_pct%"
        echo -e "${YELLOW}Time Taken:${NC} $duration seconds"
        echo -e "${YELLOW}Duration:${NC} $(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$output_file" | awk '{print int($1/60) " min " int($1%60) " sec"}')"
        notify "Success: Video compressed to $output_file"
    else
        notify "${RED}Compression failed! Check logs at $LOG_FILE${NC}"
        return 1
    fi
}

# ┌─────────────────────── Batch Compression ─────────────────────┐
# │ Process multiple videos in one go                          │
# └──────────────────────────────────────────────────────────────┘
batch_compress() {
    clear
    display_logo
    notify "$(random_color)Batch Compression Mode${NC}"
    echo "Enter video file paths (one per line, press Ctrl+D when done):"
    local files=()
    while IFS= read -r line; do
        [[ -n "$line" ]] && files+=("$line")
    done
    if [[ ${#files[@]} -eq 0 ]]; then
        notify "${RED}No files provided!${NC}"
        return 1
    fi
    local quality watermark format
    echo -e "$(random_color)Select compression quality:${NC}"
    echo "1. Low  2. Medium  3. High  4. Ultra  5. Custom"
    read -p "Choice [1-5]: " quality
    echo -e "$(random_color)Add watermark? (y/n):${NC}"
    read -p "Choice: " watermark
    echo -e "$(random_color)Select output format:${NC}"
    echo "1. MP4  2. MKV  3. AVI"
    read -p "Choice [1-3]: " format_choice
    case $format_choice in
        1) format="mp4";;
        2) format="mkv";;
        3) format="avi";;
        *) format="mp4";;
    esac
    for file in "${files[@]}"; do
        if validate_video "$file"; then
            get_video_info "$file"
            compress_video "$file" "$quality" "$watermark" "$format"
        else
            notify "${RED}Skipping invalid file: $file${NC}"
        fi
    done
}

# ┌─────────────────────── Update Checker ────────────────────────┐
# │ Check for updates via GitHub                               │
# └──────────────────────────────────────────────────────────────┘
check_update() {
    notify "$(random_color)Checking for updates...${NC}"
    local latest_version=$(curl -s "$UPDATE_URL" | grep "version=" | cut -d'=' -f2)
    if [[ -n "$latest_version" && "$latest_version" > "$VERSION" ]]; then
        notify "${YELLOW}Update available! New version: $latest_version (Current: $VERSION)${NC}"
        echo "Visit https://github.com/jubairbro/VideoSensi to update."
    else
        notify "$(random_color)You are up-to-date! Version: $VERSION${NC}"
    fi
}

# ┌─────────────────────── Config Manager ────────────────────────┐
# │ Save and load user preferences                            │
# └──────────────────────────────────────────────────────────────┘
save_config() {
    notify "$(random_color)Saving configuration...${NC}"
    cat > "$CONFIG_FILE" << EOF
THEME="$THEME"
NOTIFY="$NOTIFY"
WATERMARK_TEXT="$WATERMARK_TEXT"
WATERMARK_POS="$WATERMARK_POS"
WATERMARK_COLOR="$WATERMARK_COLOR"
EOF
    notify "$(random_color)Config saved to $CONFIG_FILE${NC}"
}

# ┌─────────────────────── Help Menu ─────────────────────────────┐
# │ Detailed help with all options                            │
# └──────────────────────────────────────────────────────────────┘
show_help() {
    clear
    display_logo
    notify "$(random_color)VideoSensi Help Menu:${NC}"
    echo "Usage: videosensi [option]"
    echo
    echo "Options:"
    echo "  --help        Display this help menu"
    echo "  --tutorial    Start interactive tutorial"
    echo "  (no option)   Start the compression tool"
    echo
    echo "Features:"
    echo "  - 4 quality modes: Low, Medium, High, Ultra + Custom CRF"
    echo "  - Batch compression for multiple files"
    echo "  - Optional watermark with custom text/position/color"
    echo "  - Animated progress bar with real-time updates"
    echo "  - Preview clip generation"
    echo "  - Output formats: MP4, MKV, AVI"
    echo "  - Logs saved to /sdcard/VideoSensi/logs/"
    echo "  - Outputs saved to /sdcard/VideoSensi/"
    echo "  - Backups saved to /sdcard/VideoSensi/backups/"
    echo
    echo "Contact:"
    echo "  GitHub: https://github.com/jubairbro/"
    echo "  Telegram: https://t.me/jubairFF/"
    echo
}

# ┌─────────────────────── Tutorial Mode ─────────────────────────┐
# │ Guided walkthrough for first-time users                    │
# └──────────────────────────────────────────────────────────────┘
tutorial_mode() {
    clear
    display_logo
    notify "$(random_color)Welcome to VideoSensi Tutorial!${NC}"
    echo "This guide will walk you through the basics."
    echo
    echo "1. **Compress a Video**"
    echo "   - Select '1' from the main menu."
    echo "   - Enter a video file path (e.g., /sdcard/video.mp4)."
    echo "   - Choose quality (1-5) and watermark (y/n)."
    echo
    echo "2. **Batch Mode**"
    echo "   - Select '2' to compress multiple videos."
    echo "   - Enter file paths one per line, then press Ctrl+D."
    echo
    echo "3. **Settings**"
    echo "   - Customize theme, notifications, and watermark."
    echo
    notify "$(random_color)Try it now! Press Enter to go to the main menu.${NC}"
    read
}

# ┌─────────────────────── Ctrl+C Trap ───────────────────────────┐
# │ Clean up and exit gracefully                              │
# └──────────────────────────────────────────────────────────────┘
trap_ctrl_c() {
    notify "${RED}Process interrupted! Cleaning up...${NC}"
    rm -f "$OUTPUT_DIR"/temp_*.mp4 2>/dev/null
    save_config
    notify "$(random_color)Thanks for using VideoSensi! Exiting...${NC}"
    exit 0
}

trap trap_ctrl_c SIGINT

# ┌─────────────────────── Main Menu ─────────────────────────────┐
# │ Interactive menu with all options                         │
# └──────────────────────────────────────────────────────────────┘
main_menu() {
    load_config
    apply_theme
    while true; do
        clear
        display_logo
        check_update
        notify "$(random_color)VideoSensi Main Menu:${NC}"
        echo "1. Compress Video"
        echo "2. Batch Compression"
        echo "3. Generate Preview"
        echo "4. Settings"
        echo "5. Exit"
        read -p "Enter choice [1-5]: " choice
        case $choice in
            1)
                clear
                display_logo
                notify "$(random_color)Enter video file path:${NC}"
                read -p "Path: " video_file
                if validate_video "$video_file"; then
                    get_video_info "$video_file"
                    echo -e "$(random_color)Select compression quality:${NC}"
                    echo "1. Low  2. Medium  3. High  4. Ultra  5. Custom"
                    read -p "Choice [1-5]: " quality
                    echo -e "$(random_color)Add watermark? (y/n):${NC}"
                    read -p "Choice: " watermark
                    if [[ "$watermark" == "y" ]]; then
                        echo -e "$(random_color)Enter watermark text [default: $WATERMARK_TEXT]:${NC}"
                        read -p "Text: " wm_text
                        [[ -n "$wm_text" ]] && WATERMARK_TEXT="$wm_text"
                        echo -e "$(random_color)Enter watermark position [default: $WATERMARK_POS]:${NC}"
                        echo "1. top-left  2. top-right  3. bottom-left  4. bottom-right"
                        read -p "Choice [1-4]: " wm_pos
                        case $wm_pos in
                            1) WATERMARK_POS="top-left";;
                            2) WATERMARK_POS="top-right";;
                            3) WATERMARK_POS="bottom-left";;
                            4) WATERMARK_POS="bottom-right";;
                        esac
                        echo -e "$(random_color)Enter watermark color [default: $WATERMARK_COLOR]:${NC}"
                        read -p "Color: " wm_color
                        [[ -n "$wm_color" ]] && WATERMARK_COLOR="$wm_color"
                    fi
                    echo -e "$(random_color)Select output format:${NC}"
                    echo "1. MP4  2. MKV  3. AVI"
                    read -p "Choice [1-3]: " format_choice
                    case $format_choice in
                        1) format="mp4";;
                        2) format="mkv";;
                        3) format="avi";;
                        *) format="mp4";;
                    esac
                    compress_video "$video_file" "$quality" "$watermark" "$format"
                else
                    notify "${RED}Invalid video! Returning to menu...${NC}"
                    sleep 2
                fi
                ;;
            2)
                batch_compress
                ;;
            3)
                clear
                display_logo
                notify "$(random_color)Enter video file path for preview:${NC}"
                read -p "Path: " video_file
                if validate_video "$video_file"; then
                    generate_preview "$video_file"
                else
                    notify "${RED}Invalid video!${NC}"
                fi
                ;;
            4)
                clear
                display_logo
                notify "$(random_color)Settings Menu:${NC}"
                echo "1. Change Theme ($THEME)"
                echo "2. Toggle Notifications ($NOTIFY)"
                echo "3. Back to Main Menu"
                read -p "Choice [1-3]: " setting_choice
                case $setting_choice in
                    1)
                        echo -e "$(random_color)Select Theme:${NC}"
                        echo "1. Dark  2. Light  3. Neon"
                        read -p "Choice [1-3]: " theme_choice
                        case $theme_choice in
                            1) THEME="Dark";;
                            2) THEME="Light";;
                            3) THEME="Neon";;
                        esac
                        save_config
                        ;;
                    2)
                        echo -e "$(random_color)Enable Notifications? (y/n):${NC}"
                        read -p "Choice: " NOTIFY
                        save_config
                        ;;
                    3) continue;;
                esac
                ;;
            5)
                save_config
                notify "$(random_color)Thanks for using VideoSensi!${NC}"
                exit 0
                ;;
            *)
                notify "${RED}Invalid choice!${NC}"
                sleep 2
                ;;
        esac
        notify "$(random_color)Press Enter to continue...${NC}"
        read
    done
}

# ┌─────────────────────── Main Execution ────────────────────────┐
# │ Entry point for the script                                │
# └──────────────────────────────────────────────────────────────┘
if [[ "$1" == "--help" ]]; then
    show_help
    exit 0
elif [[ "$1" == "--tutorial" ]]; then
    tutorial_mode
    main_menu
fi

display_logo
check_ffmpeg
if [[ ! -f "$CONFIG_FILE" ]]; then
    tutorial_mode
fi
main_menu

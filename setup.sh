#!/data/data/com.termux/files/usr/bin/bash

# ╔═══════════════════════════════════════════════╗
# ║         VideoSensi Setup Script v1.0          ║
# ║      Auto-installer with update checker       ║
# ╚═══════════════════════════════════════════════╝

# Set variables
INSTALL_DIR="/data/data/com.termux/files/usr/bin"
SCRIPT_NAME="videosensi"
REPO_URL="https://raw.githubusercontent.com/JubairFF/VideoSensi/main/update.txt"
LOG_DIR="/sdcard/VideoSensi/logs"
VERSION="1.0"

# Colors
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
NC='\033[0m'

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

# Error handling
error_exit() {
    draw_box_top
    draw_box_line "${RED}Error: $1${NC}"
    draw_box_bottom
    exit 1
}

# Check internet connection
check_internet() {
    ping -c 1 google.com &>/dev/null || error_exit "No internet connection!"
}

# Install FFmpeg
install_ffmpeg() {
    draw_box_top
    draw_box_line "${YELLOW}Installing FFmpeg...${NC}"
    draw_box_bottom
    pkg install ffmpeg -y || {
        draw_box_top
        draw_box_line "${RED}FFmpeg installation failed. Retrying...${NC}"
        draw_box_bottom
        sleep 2
        pkg update -y && pkg install ffmpeg -y || error_exit "FFmpeg installation failed!"
    }
}

# Create directories
setup_directories() {
    mkdir -p "$LOG_DIR" || error_exit "Failed to create log directory!"
    mkdir -p "/sdcard/VideoSensi" || error_exit "Failed to create output directory!"
}

# Make script executable
make_executable() {
    draw_box_top
    draw_box_line "${YELLOW}Setting up VideoSensi executable...${NC}"
    draw_box_bottom
    cp videosensi "$INSTALL_DIR/$SCRIPT_NAME" || error_exit "Failed to copy script!"
    chmod +x "$INSTALL_DIR/$SCRIPT_NAME" || error_exit "Failed to make script executable!"
}

# Check for updates
check_updates() {
    check_internet
    draw_box_top
    draw_box_line "${YELLOW}Checking for updates...${NC}"
    draw_box_bottom
    curl -s "$REPO_URL" > /tmp/update.txt || error_exit "Failed to fetch update info!"
    LATEST_VERSION=$(grep "version=" /tmp/update.txt | cut -d'=' -f2)
    if [[ "$LATEST_VERSION" > "$VERSION" ]]; then
        draw_box_top
        draw_box_line "${GREEN}Update available: v$LATEST_VERSION${NC}"
        draw_box_line "${YELLOW}Please visit @JubairFF on Telegram for updates!${NC}"
        draw_box_bottom
    else
        draw_box_top
        draw_box_line "${GREEN}You are running the latest version: v$VERSION${NC}"
        draw_box_bottom
    fi
}

# Main setup function
main_setup() {
    clear
    draw_box_top
    draw_box_line "${BLUE}Welcome to VideoSensi Setup v$VERSION${NC}"
    draw_box_line "${BLUE}স্বাগতম ভিডিওসেন্সি সেটআপে v$VERSION${NC}"
    draw_box_bottom
    sleep 2

    # Update package lists
    draw_box_top
    draw_box_line "${YELLOW}Updating Termux packages...${NC}"
    draw_box_bottom
    pkg update -y || error_exit "Package update failed!"

    # Install dependencies
    install_ffmpeg
    setup_directories
    make_executable
    check_updates

    draw_box_top
    draw_box_line "${GREEN}Setup completed successfully!${NC}"
    draw_box_line "${GREEN}সেটআপ সফলভাবে সম্পন্ন!${NC}"
    draw_box_line "${CYAN}Run 'videosensi' to start!${NC}"
    draw_box_line "${CYAN}'videosensi' চালু করুন শুরু করতে!${NC}"
    draw_box_bottom
}

# Trap Ctrl+C
trap 'error_exit "Setup interrupted by user!"' INT

# Run main setup
main_setup

#!/bin/bash

# VideoSensi Custom Setup Script
# Version: 2.0
# Author: Jubair (@JubairFF)

# Colors
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
PURPLE='\033[1;35m'
CYAN='\033[1;36m'
NC='\033[0m'

# Animation
spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

# Header
header() {
    clear
    echo -e "${PURPLE}"
    echo "╔════════════════════════════════════════════════╗"
    echo "║               VIDEO SENSI SETUP                ║"
    echo "║                  Ultimate Tool                 ║"
    echo "║           For Termux on Android                ║"
    echo "╚════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Check Termux
check_termux() {
    if [ ! -d "$PREFIX" ]; then
        echo -e "${RED}Error: This script must be run in Termux!${NC}"
        echo -e "${YELLOW}Please install Termux from Play Store or F-Droid.${NC}"
        exit 1
    fi
}

# Check Internet
check_internet() {
    echo -e "${BLUE}Checking internet connection...${NC}"
    if ! ping -c 1 google.com &> /dev/null; then
        echo -e "${RED}Error: No internet connection!${NC}"
        echo -e "${YELLOW}Please connect to the internet and try again.${NC}"
        exit 1
    fi
}

# Install Dependencies
install_deps() {
    echo -e "${CYAN}Updating packages...${NC}"
    pkg update -y &> /dev/null &
    spinner $!
    
    echo -e "\n${CYAN}Installing dependencies...${NC}"
    local deps=(ffmpeg git curl wget)
    for dep in "${deps[@]}"; do
        echo -ne "${YELLOW}Installing $dep...${NC}"
        pkg install -y $dep &> /dev/null &
        spinner $!
        echo -e " ${GREEN}Done!${NC}"
    done
    
    # Check if ImageMagick is needed (for watermark feature)
    if ! command -v convert &> /dev/null; then
        echo -ne "${YELLOW}Installing ImageMagick...${NC}"
        pkg install -y imagemagick &> /dev/null &
        spinner $!
        echo -e " ${GREEN}Done!${NC}"
    fi
}

# Download VideoSensi
download_script() {
    echo -e "\n${BLUE}Downloading VideoSensi...${NC}"
    
    # Try GitHub first
    echo -ne "${YELLOW}Trying GitHub...${NC}"
    if curl -sL -o videosensi.sh "https://raw.githubusercontent.com/JubairFF/videosensi/main/videosensi.sh"; then
        echo -e " ${GREEN}Success!${NC}"
    else
        # Fallback to direct download
        echo -e "\n${YELLOW}GitHub failed, trying fallback server...${NC}"
        if curl -sL -o videosensi.sh "https://example.com/videosensi/videosensi.sh"; then
            echo -e " ${GREEN}Success!${NC}"
        else
            echo -e " ${RED}Failed!${NC}"
            echo -e "${RED}Could not download VideoSensi. Please try again later.${NC}"
            exit 1
        fi
    fi
    
    chmod +x videosensi.sh
}

# Install Script
install_script() {
    echo -e "\n${BLUE}Installing VideoSensi...${NC}"
    
    # Check if already installed
    if [ -f "$PREFIX/bin/videosensi" ]; then
        echo -ne "${YELLOW}Removing previous version...${NC}"
        rm -f "$PREFIX/bin/videosensi"
        echo -e " ${GREEN}Done!${NC}"
    fi
    
    # Install new version
    echo -ne "${YELLOW}Setting up global access...${NC}"
    cp videosensi.sh "$PREFIX/bin/videosensi"
    chmod +x "$PREFIX/bin/videosensi"
    echo -e " ${GREEN}Done!${NC}"
    
    # Create config directory
    echo -ne "${YELLOW}Creating config directory...${NC}"
    mkdir -p "$HOME/.videosensi/logs"
    echo -e " ${GREEN}Done!${NC}"
    
    # Create default watermark
    echo -ne "${YELLOW}Creating default watermark...${NC}"
    if command -v convert &> /dev/null; then
        convert -size 200x50 xc:none -fill '#FFFFFF80' -pointsize 20 \
                -gravity center -annotate 0 'JubairFF' \
                "$HOME/.videosensi/watermark.png" &> /dev/null
        echo -e " ${GREEN}Done!${NC}"
    else
        echo -e " ${YELLOW}Skipped (ImageMagick not available)${NC}"
    fi
}

# Post Install
post_install() {
    echo -e "\n${GREEN}Installation Complete!${NC}"
    echo -e "${CYAN}"
    echo "╔════════════════════════════════════════╗"
    echo "║          VIDEO SENSI READY TO USE      ║"
    echo "╚════════════════════════════════════════╝"
    echo -e "${NC}"
    echo -e "${YELLOW}To start VideoSensi, just type:${NC}"
    echo -e "  ${GREEN}videosensi${NC}"
    echo -e "\n${YELLOW}For support, join our Telegram channel:${NC}"
    echo -e "  ${CYAN}https://t.me/JubairFF${NC}"
    
    # Check if we can add alias to bashrc
    if [ -f "$HOME/.bashrc" ]; then
        if ! grep -q "alias vs='videosensi'" "$HOME/.bashrc"; then
            echo -e "\n${YELLOW}Would you like to create a shortcut alias? (y/n)${NC}"
            read -p "Choice: " choice
            if [[ "$choice" =~ ^[Yy] ]]; then
                echo "alias vs='videosensi'" >> "$HOME/.bashrc"
                echo -e "${GREEN}Shortcut created! You can now use 'vs' to launch VideoSensi.${NC}"
                echo -e "${YELLOW}Restart Termux or run: source ~/.bashrc${NC}"
            fi
        fi
    fi
}

# Main Execution
header
check_termux
check_internet
install_deps
download_script
install_script
post_install

# Cleanup
rm -f videosensi.sh &> /dev/null

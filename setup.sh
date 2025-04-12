#!/bin/bash

# VideoSensi Setup Script
# Version: 2.2
# Author: Jubair (@JubairFF)

# Colors
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
PURPLE='\033[1;35m'
CYAN='\033[1;36m'
NC='\033[0m'

# GitHub Repository
REPO_URL="https://github.com/jubairbro/VideoSensi"
RAW_URL="https://raw.githubusercontent.com/jubairbro/VideoSensi/main"

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
    echo -e "${YELLOW}Version: 2.2 | By Jubair (@JubairFF)${NC}"
    echo
}

# Check Termux
check_termux() {
    if [ ! -d "$PREFIX" ]; then
        echo -e "${RED}Error: This script must be run in Termux!${NC}"
        echo -e "${YELLOW}Please install Termux from Play Store or F-Droid.${NC}"
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
    
    if ! command -v convert &> /dev/null; then
        echo -ne "${YELLOW}Installing ImageMagick...${NC}"
        pkg install -y imagemagick &> /dev/null &
        spinner $!
        echo -e " ${GREEN}Done!${NC}"
    fi
}

# Download Files
download_files() {
    echo -e "\n${BLUE}Downloading VideoSensi files...${NC}"
    
    declare -A files=(
        ["videosensi"]="videosensi"
        ["update.txt"]="update.txt"
        ["README.md"]="README.md"
    )
    
    for file in "${!files[@]}"; do
        echo -ne "${YELLOW}Downloading $file...${NC}"
        if ! curl -sL -o "$file" "$RAW_URL/${files[$file]}"; then
            echo -e " ${RED}Failed!${NC}"
            echo -e "${RED}Error downloading ${files[$file]}${NC}"
            exit 1
        fi
        echo -e " ${GREEN}Success!${NC}"
        [ "$file" == "videosensi" ] && chmod +x "$file"
    done
}

# Install Script
install_script() {
    echo -e "\n${BLUE}Installing VideoSensi...${NC}"
    
    if [ -f "$PREFIX/bin/videosensi" ]; then
        echo -ne "${YELLOW}Removing previous version...${NC}"
        rm -f "$PREFIX/bin/videosensi" || {
            echo -e " ${RED}Failed!${NC}"
            exit 1
        }
        echo -e " ${GREEN}Done!${NC}"
    fi
    
    echo -ne "${YELLOW}Setting up global access...${NC}"
    if ! mv videosensi "$PREFIX/bin/" || ! chmod +x "$PREFIX/bin/videosensi"; then
        echo -e " ${RED}Failed!${NC}"
        exit 1
    fi
    echo -e " ${GREEN}Done!${NC}"
    
    echo -ne "${YELLOW}Creating config directory...${NC}"
    mkdir -p "$HOME/.videosensi/logs" || {
        echo -e " ${RED}Failed!${NC}"
        exit 1
    }
    echo -e " ${GREEN}Done!${NC}"
    
    if command -v convert &> /dev/null; then
        echo -ne "${YELLOW}Creating default watermark...${NC}"
        convert -size 200x50 xc:none -fill '#FFFFFF80' -pointsize 20 \
                -gravity center -annotate 0 'JubairFF' \
                "$HOME/.videosensi/watermark.png" &> /dev/null || {
            echo -e " ${YELLOW}Warning: Failed to create watermark${NC}"
        }
        echo -e " ${GREEN}Done!${NC}"
    fi
    
    mv update.txt README.md "$HOME/.videosensi/" || {
        echo -e "${YELLOW}Warning: Failed to move documentation files${NC}"
    }
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
    echo -e "\n${YELLOW}Documentation:${NC}"
    echo -e "  ${BLUE}cat ~/.videosensi/README.md${NC}"
    echo -e "\n${YELLOW}For support:${NC}"
    echo -e "  ${CYAN}https://t.me/JubairFF${NC}"
    echo -e "\n${YELLOW}GitHub Repository:${NC}"
    echo -e "  ${BLUE}https://github.com/jubairbro/VideoSensi${NC}"
}

# Main Execution
header
check_termux
install_deps
download_files
install_script
post_install

# Cleanup
rm -f videosensi update.txt README.md &> /dev/null

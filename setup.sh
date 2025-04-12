#!/bin/bash

# setup.sh for VideoSensi Pro
# Developer: Jubair bro
# Telegram: https://t.me/JubairFF
# GitHub: github.com/jubairbro
# Purpose: Fully automated installer for VideoSensi with animations and GitHub integration
# Version: 1.0

# Configuration
INSTALLER_VERSION="1.0"
TOOL_NAME="VideoSensi Pro"
SCRIPT_VERSION="2.4"
INSTALL_DIR="/data/data/com.termux/files/usr/bin"
SCRIPT_NAME="videosensi"
GITHUB_SCRIPT_URL="https://raw.githubusercontent.com/jubairbro/VideoSensi/main/videosensi"
TEMP_SCRIPT="/tmp/videosensi_temp"
CONFIG_DIR="$HOME/.videosensi"
OUTPUT_DIR="/sdcard/VideoSensi"

# Colors
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
NC='\033[0m'

# Loading animation
loading_animation() {
    local msg="$1"
    local duration="$2"
    echo -ne "${YELLOW}${msg} ${NC}"
    for ((i=0; i<duration; i++)); do
        echo -ne "."
        sleep 0.3
    done
    echo
}

# Show logo
show_logo() {
    clear
    echo -e "${CYAN}"
    echo "┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓"
    echo "┃ ██╗   ██╗██╗██████╗ ███████╗ ██████╗┃"
    echo "┃ ██║   ██║██║██╔══██╗██╔════╝██╔═══██╗┃"
    echo "┃ ██║   ██║██║██║  ██║█████╗  ██║   ██║┃"
    echo "┃ ╚██╗ ██╔╝██║██║  ██║██╔══╝  ██║   ██║┃"
    echo "┃  ╚████╔╝ ██║██████╔╝███████╗╚██████╔╝┃"
    echo "┃   ╚═══╝  ╚═╝╚═════╝ ╚══════╝ ╚═════╝ ┃"
    echo "┠──────────────────────────────────────┨"
    echo "┃ $TOOL_NAME Setup v$INSTALLER_VERSION - by Jubair bro ┃"
    echo "┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛"
    echo -e "${NC}"
    loading_animation "Initializing setup" 3
}

# Draw boxed UI
draw_box() {
    local title="$1"
    echo -e "${CYAN}"
    echo "┌──────────────────────────────────────┐"
    echo "│ ${title^} │"
    echo "└──────────────────────────────────────┘"
    echo -e "${NC}"
}

# Clean previous installations
clean_previous() {
    draw_box "Cleaning Previous Installations"
    loading_animation "Checking for old files" 2
    if [ -f "$INSTALL_DIR/$SCRIPT_NAME" ]; then
        echo -e "${YELLOW}Removing old $SCRIPT_NAME...${NC}"
        if rm -f "$INSTALL_DIR/$SCRIPT_NAME"; then
            echo -e "${GREEN}Old $SCRIPT_NAME removed!${NC}"
        else
            echo -e "${RED}Failed to remove old $SCRIPT_NAME! Check permissions.${NC}"
            exit 1
        fi
    else
        echo -e "${GREEN}No old $SCRIPT_NAME found!${NC}"
    fi
    if [ -d "$CONFIG_DIR" ]; then
        echo -e "${YELLOW}Removing old config directory...${NC}"
        if rm -rf "$CONFIG_DIR"; then
            echo -e "${GREEN}Old config directory removed!${NC}"
        else
            echo -e "${RED}Failed to remove config directory! Check permissions.${NC}"
            exit 1
        fi
    fi
}

# Update and upgrade packages
update_packages() {
    draw_box "Updating Packages"
    loading_animation "Updating Termux packages" 3
    if pkg update -y && pkg upgrade -y; then
        echo -e "${GREEN}Packages updated successfully!${NC}"
    else
        echo -e "${RED}Failed to update packages! Check network or run 'pkg update' manually.${NC}"
        exit 1
    fi
}

# Install dependencies
install_dependencies() {
    draw_box "Installing Dependencies"
    local deps=("ffmpeg" "curl" "git")
    for dep in "${deps[@]}"; do
        loading_animation "Checking $dep" 2
        if ! command -v "$dep" > /dev/null 2>&1; then
            echo -e "${YELLOW}Installing $dep...${NC}"
            if pkg install -y "$dep"; then
                if command -v "$dep" > /dev/null 2>&1; then
                    echo -e "${GREEN}$dep installed successfully!${NC}"
                else
                    echo -e "${RED}$dep installation failed!${NC}"
                    exit 1
                fi
            else
                echo -e "${RED}Failed to install $dep! Run 'pkg install $dep' manually.${NC}"
                exit 1
            fi
        else
            echo -e "${GREEN}$dep already installed!${NC}"
        fi
    done
}

# Setup storage permission
setup_storage() {
    draw_box "Setting Up Storage"
    loading_animation "Checking storage access" 2
    if ! [ -d "/sdcard" ] || ! touch "/sdcard/test.txt" 2>/dev/null; then
        echo -e "${YELLOW}Setting up storage permission...${NC}"
        if termux-setup-storage; then
            sleep 2
            if touch "/sdcard/test.txt" 2>/dev/null; then
                rm -f "/sdcard/test.txt"
                echo -e "${GREEN}Storage permission granted!${NC}"
            else
                echo -e "${RED}Storage access still not granted! Run 'termux-setup-storage' manually.${NC}"
                exit 1
            fi
        else
            echo -e "${RED}Failed to setup storage! Run 'termux-setup-storage' manually.${NC}"
            exit 1
        fi
    else
        rm -f "/sdcard/test.txt" 2>/dev/null
        echo -e "${GREEN}Storage access already granted!${NC}"
    fi
    loading_animation "Creating output directory" 2
    if mkdir -p "$OUTPUT_DIR"; then
        echo -e "${GREEN}Output directory created: $OUTPUT_DIR${NC}"
    else
        echo -e "${RED}Failed to create $OUTPUT_DIR! Check permissions.${NC}"
        exit 1
    fi
}

# Download and install VideoSensi
install_videosensi() {
    draw_box "Installing VideoSensi"
    loading_animation "Downloading VideoSensi v$SCRIPT_VERSION" 3
    if curl -s -o "$TEMP_SCRIPT" "$GITHUB_SCRIPT_URL"; then
        echo -e "${GREEN}Script downloaded to $TEMP_SCRIPT${NC}"
        loading_animation "Installing VideoSensi" 2
        if mv "$TEMP_SCRIPT" "$INSTALL_DIR/$SCRIPT_NAME"; then
            echo -e "${GREEN}Script moved to $INSTALL_DIR/$SCRIPT_NAME${NC}"
            if chmod +x "$INSTALL_DIR/$SCRIPT_NAME"; then
                echo -e "${GREEN}Script made executable!${NC}"
            else
                echo -e "${RED}Failed to make script executable! Run 'chmod +x $INSTALL_DIR/$SCRIPT_NAME' manually.${NC}"
                exit 1
            fi
        else
            echo -e "${RED}Failed to move script to $INSTALL_DIR! Check permissions.${NC}"
            exit 1
        fi
    else
        echo -e "${RED}Failed to download script! Check network or URL: $GITHUB_SCRIPT_URL${NC}"
        exit 1
    fi
}

# Verify installation
verify_installation() {
    draw_box "Verifying Installation"
    loading_animation "Checking installation" 2
    if [ -f "$INSTALL_DIR/$SCRIPT_NAME" ] && [ -x "$INSTALL_DIR/$SCRIPT_NAME" ]; then
        echo -e "${GREEN}VideoSensi v$SCRIPT_VERSION installed successfully at $INSTALL_DIR/$SCRIPT_NAME${NC}"
        echo -e "${YELLOW}Run it using: ${CYAN}videosensi${NC}"
    else
        echo -e "${RED}Installation failed! Script not found or not executable at $INSTALL_DIR/$SCRIPT_NAME${NC}"
        exit 1
    fi
}

# Main setup process
main() {
    show_logo
    clean_previous
    update_packages
    install_dependencies
    setup_storage
    install_videosensi
    verify_installation
    show_logo
    echo -e "${GREEN}Setup completed successfully!${NC}"
    echo -e "${CYAN}Run VideoSensi by typing: ${YELLOW}videosensi${NC}"
    echo -e "${CYAN}Telegram: @JubairFF | github.com/jubairbro${NC}"
}

# Execute main
main

#!/bin/bash

# setup.sh for VideoSensi Pro
# Developer: Jubair bro
# Telegram: https://t.me/JubairFF
# GitHub: github.com/jubairbro
# Installer Version: 1.0
# Purpose: Fully automated installer for VideoSensi with animations

# Configuration
INSTALLER_VERSION="1.0"
TOOL_NAME="VideoSensi Pro"
SCRIPT_VERSION="2.4"
INSTALL_DIR="/data/data/com.termux/files/usr/bin"
SCRIPT_NAME="videosensi"
GITHUB_URL="https://raw.githubusercontent.com/jubairbro/VideoSensi/main/videosensi"
TEMP_SCRIPT="/tmp/videosensi_temp"

# Colors
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
NC='\033[0m'

# Show animated logo
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
    echo "┃ $TOOL_NAME Installer v$INSTALLER_VERSION     ┃"
    echo "┃ by Jubair bro                        ┃"
    echo "┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛"
    echo -e "${NC}"
    local animation=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")
    for i in {1..10}; do
        echo -en "\r${YELLOW}Initializing... ${animation[$((i % 10))]}${NC}"
        sleep 0.2
    done
    echo -e "\r${GREEN}Initialization complete!          ${NC}"
    sleep 1
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

# Remove previous installation
remove_previous() {
    draw_box "Removing Previous Installation"
    if [ -f "$INSTALL_DIR/$SCRIPT_NAME" ]; then
        echo -e "${YELLOW}Removing old $SCRIPT_NAME...${NC}"
        if rm -f "$INSTALL_DIR/$SCRIPT_NAME"; then
            echo -e "${GREEN}Old installation removed!${NC}"
        else
            echo -e "${RED}Failed to remove old $SCRIPT_NAME! Check permissions.${NC}"
            exit 1
        fi
    else
        echo -e "${GREEN}No previous installation found!${NC}"
    fi
    # Clean up old config/logs
    if [ -d "$HOME/.videosensi" ]; then
        echo -e "${YELLOW}Removing old config/logs...${NC}"
        rm -rf "$HOME/.videosensi" && echo -e "${GREEN}Old config/logs removed!${NC}"
    fi
    sleep 1
}

# Update and upgrade packages
update_packages() {
    draw_box "Updating Packages"
    echo -e "${YELLOW}Running pkg update...${NC}"
    if pkg update -y; then
        echo -e "${GREEN}Package update complete!${NC}"
    else
        echo -e "${RED}Failed to update packages! Check network.${NC}"
        exit 1
    fi
    echo -e "${YELLOW}Running pkg upgrade...${NC}"
    if pkg upgrade -y; then
        echo -e "${GREEN}Package upgrade complete!${NC}"
    else
        echo -e "${RED}Failed to upgrade packages! Check network.${NC}"
        exit 1
    fi
    sleep 1
}

# Install dependencies
install_dependencies() {
    draw_box "Installing Dependencies"
    local deps=("ffmpeg" "curl" "git")
    for dep in "${deps[@]}"; do
        echo -e "${YELLOW}Checking $dep...${NC}"
        if ! command -v "$dep" > /dev/null 2>&1; then
            echo -e "${YELLOW}Installing $dep...${NC}"
            local animation=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")
            (pkg install -y "$dep" > /dev/null 2>&1) &
            local pid=$!
            local i=0
            while kill -0 $pid 2>/dev/null; do
                echo -en "\r${YELLOW}Installing $dep... ${animation[$((i % 10))]}${NC}"
                sleep 0.2
                ((i++))
            done
            wait $pid
            if command -v "$dep" > /dev/null 2>&1; then
                echo -e "\r${GREEN}$dep installed successfully!          ${NC}"
            else
                echo -e "\r${RED}Failed to install $dep! Run 'pkg install $dep' manually.${NC}"
                exit 1
            fi
        else
            echo -e "${GREEN}$dep already installed!${NC}"
        fi
    done
    sleep 1
}

# Setup storage permission
setup_storage() {
    draw_box "Setting Up Storage Permission"
    echo -e "${YELLOW}Checking storage permission...${NC}"
    if ! [ -d "/sdcard" ] || ! touch "/sdcard/test.txt" 2>/dev/null; then
        echo -e "${YELLOW}Setting up storage access...${NC}"
        local animation=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")
        (termux-setup-storage > /dev/null 2>&1) &
        local pid=$!
        local i=0
        while kill -0 $pid 2>/dev/null; do
            echo -en "\r${YELLOW}Setting up storage... ${animation[$((i % 10))]}${NC}"
            sleep 0.2
            ((i++))
        done
        wait $pid
        if [ -d "/sdcard" ] && touch "/sdcard/test.txt" 2>/dev/null; then
            rm -f "/sdcard/test.txt"
            echo -e "\r${GREEN}Storage permission granted!          ${NC}"
        else
            echo -e "\r${RED}Failed to setup storage! Run 'termux-setup-storage' manually.${NC}"
            exit 1
        fi
    else
        rm -f "/sdcard/test.txt" 2>/dev/null
        echo -e "${GREEN}Storage access already granted!${NC}"
    fi
    # Create default output directory
    echo -e "${YELLOW}Creating output directory...${NC}"
    if mkdir -p "/sdcard/VideoSensi"; then
        echo -e "${GREEN}Output directory created: /sdcard/VideoSensi${NC}"
    else
        echo -e "${RED}Failed to create /sdcard/VideoSensi! Check permissions.${NC}"
        exit 1
    fi
    sleep 1
}

# Download and install VideoSensi
install_videosensi() {
    draw_box "Installing VideoSensi"
    echo -e "${YELLOW}Downloading VideoSensi v$SCRIPT_VERSION...${NC}"
    local animation=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")
    (curl -s -o "$TEMP_SCRIPT" "$GITHUB_URL" > /dev/null 2>&1) &
    local pid=$!
    local i=0
    while kill -0 $pid 2>/dev/null; do
        echo -en "\r${YELLOW}Downloading... ${animation[$((i % 10))]}${NC}"
        sleep 0.2
        ((i++))
    done
    wait $pid
    if [ -f "$TEMP_SCRIPT" ]; then
        echo -e "\r${GREEN}Script downloaded successfully!          ${NC}"
        # Move to install directory
        echo -e "${YELLOW}Installing to $INSTALL_DIR/$SCRIPT_NAME...${NC}"
        if mv "$TEMP_SCRIPT" "$INSTALL_DIR/$SCRIPT_NAME"; then
            echo -e "${GREEN}Script installed to $INSTALL_DIR/$SCRIPT_NAME${NC}"
            # Make executable
            if chmod +x "$INSTALL_DIR/$SCRIPT_NAME"; then
                echo -e "${GREEN}Script made executable!${NC}"
            else
                echo -e "${RED}Failed to make script executable! Run 'chmod +x $INSTALL_DIR/$SCRIPT_NAME' manually.${NC}"
                exit 1
            fi
        else
            echo -e "${RED}Failed to install script! Check permissions at $INSTALL_DIR.${NC}"
            exit 1
        fi
    else
        echo -e "\r${RED}Failed to download script! Check network or URL: $GITHUB_URL${NC}"
        exit 1
    fi
    sleep 1
}

# Verify installation
verify_installation() {
    draw_box "Verifying Installation"
    if [ -f "$INSTALL_DIR/$SCRIPT_NAME" ]; then
        if [ -x "$INSTALL_DIR/$SCRIPT_NAME" ]; then
            echo -e "${GREEN}VideoSensi v$SCRIPT_VERSION installed successfully!${NC}"
            echo -e "${YELLOW}Run it using: ${CYAN}videosensi${NC}"
        else
            echo -e "${RED}Script exists but is not executable! Run 'chmod +x $INSTALL_DIR/$SCRIPT_NAME' manually.${NC}"
            exit 1
        fi
    else
        echo -e "${RED}Script not found at $INSTALL_DIR/$SCRIPT_NAME! Installation failed.${NC}"
        exit 1
    fi
    sleep 1
}

# Main setup process
main() {
    show_logo
    echo -e "${YELLOW}Starting $TOOL_NAME setup v$INSTALLER_VERSION...${NC}"
    sleep 1
    remove_previous
    update_packages
    install_dependencies
    setup_storage
    install_videosensi
    verify_installation
    show_logo
    echo -e "${GREEN}Setup completed successfully!${NC}"
    echo -e "${CYAN}Run VideoSensi by typing: ${YELLOW}videosensi${NC}"
    echo -e "${CYAN}Contact: @JubairFF | github.com/jubairbro${NC}"
}

# Execute main
main

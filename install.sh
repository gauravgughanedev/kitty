#!/bin/bash

# Kitty Terminal Installer

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
DIM='\033[2m'
NC='\033[0m'

TOTAL_STEPS=4
CURRENT_STEP=0

clear
echo ""
echo -e "${BLUE}===================================================${NC}"
echo -e "${WHITE}  Kitty Terminal Configuration Installer${NC}"
echo -e "${BLUE}===================================================${NC}"
echo ""

progress_bar() {
    local progress=$((CURRENT_STEP * 100 / TOTAL_STEPS))
    local filled=$((progress / 5))
    local empty=$((20 - filled))
    
    echo -ne "\r  ["
    printf "%${filled}s" | tr ' ' '#'
    printf "%${empty}s" | tr ' ' '-'
    echo -ne "] ${progress}%"
}

step_complete() {
    CURRENT_STEP=$((CURRENT_STEP + 1))
    echo -e " ${GREEN}[OK]${NC}"
    progress_bar
    echo ""
}

step_fail() {
    echo -e " ${RED}[FAILED]${NC}"
    echo -e "${RED}Installation aborted.${NC}"
    exit 1
}

ask_confirm() {
    while true; do
        echo -ne "${YELLOW}  > ${NC}$1 (y/n): "
        read -r response
        case "$response" in
            [yY]) return 0 ;;
            [nN]) return 1 ;;
            *) echo -e "${RED}    Please enter y or n${NC}" ;;
        esac
    done
}

detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            OS=$ID
        else
            OS="unknown"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
    else
        OS="unknown"
    fi
}

progress_bar
echo ""
echo ""

# Step 1: System Check
CURRENT_STEP=1
echo -e "${CYAN}[1/4] Checking system...${NC}"
detect_os
echo -ne "  Detected: $OS"

if [[ "$OS" == "unknown" ]]; then
    step_fail
fi
step_complete
sleep 0.5

# Step 2: Install Kitty
CURRENT_STEP=2
echo -e "${CYAN}[2/4] Installing Kitty terminal...${NC}"

if command -v kitty &> /dev/null; then
    echo -ne "  Kitty already installed"
    step_complete
else
    if ask_confirm "Kitty not found. Install it?"; then
        echo "  Installing..."
        case "$OS" in
            arch|manjaro)
                sudo pacman -S --noconfirm kitty > /dev/null 2>&1
                ;;
            ubuntu|debian|linuxmint)
                sudo apt update > /dev/null 2>&1 && sudo apt install -y kitty > /dev/null 2>&1
                ;;
            fedora)
                sudo dnf install -y kitty > /dev/null 2>&1
                ;;
            rhel|centos)
                sudo yum install -y kitty > /dev/null 2>&1
                ;;
            macos)
                brew install kitty > /dev/null 2>&1
                ;;
            *)
                echo -e "${RED}  Unsupported OS for auto-install${NC}"
                step_fail
                ;;
        esac
        
        if [ $? -eq 0 ]; then
            echo -ne "  Installation complete"
            step_complete
        else
            step_fail
        fi
    else
        step_fail
    fi
fi
sleep 0.5

# Step 3: Install Font
CURRENT_STEP=3
echo -e "${CYAN}[3/4] Installing Agave Nerd Font...${NC}"

if ask_confirm "Download and install font?"; then
    echo "  Downloading font..."
    
    TEMP_DIR=$(mktemp -d)
    cd "$TEMP_DIR"
    
    curl -sLO https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Agave.zip
    
    if [ $? -eq 0 ]; then
        if [[ "$OS" == "macos" ]]; then
            FONT_DIR="$HOME/Library/Fonts"
        else
            FONT_DIR="$HOME/.local/share/fonts"
        fi
        
        mkdir -p "$FONT_DIR"
        unzip -q -o Agave.zip -d "$FONT_DIR"
        
        if [[ "$OS" != "macos" ]]; then
            fc-cache -f > /dev/null 2>&1
        fi
        
        rm -rf "$TEMP_DIR"
        echo -ne "  Font installed"
        step_complete
    else
        rm -rf "$TEMP_DIR"
        step_fail
    fi
else
    echo -ne "  Skipped"
    step_complete
fi
sleep 0.5

# Step 4: Install Config
CURRENT_STEP=4
echo -e "${CYAN}[4/4] Setting up configuration...${NC}"

if ask_confirm "Install Kitty configuration?"; then
    mkdir -p ~/.config/kitty
    
    if [ -f ~/.config/kitty/kitty.conf ]; then
        echo -e "${DIM}  Existing config found. Creating backup automatically...${NC}"
        BACKUP_NAME="kitty.conf.backup.$(date +%Y%m%d_%H%M%S)"
        cp ~/.config/kitty/kitty.conf ~/.config/kitty/"$BACKUP_NAME"
        echo -e "${DIM}  Backup saved as: $BACKUP_NAME${NC}"
    fi
    
    echo "  Downloading config..."
    curl -sL -o ~/.config/kitty/kitty.conf https://raw.githubusercontent.com/gitggaurav/kitty/main/kitty.conf
    
    if [ $? -eq 0 ]; then
        echo -ne "  Configuration installed"
        step_complete
    else
        step_fail
    fi
else
    step_fail
fi

# Completion
echo ""
echo -e "${GREEN}===================================================${NC}"
echo -e "${GREEN}  Installation Complete${NC}"
echo -e "${GREEN}===================================================${NC}"
echo ""
echo "  Next steps:"
echo "    1. Launch Kitty: ${CYAN}kitty${NC}"
echo "    2. Config location: ${DIM}~/.config/kitty/kitty.conf${NC}"
echo ""
echo -e "${DIM}  Features: Agave Font | Warm Colors | Powerline Tabs${NC}"
echo ""

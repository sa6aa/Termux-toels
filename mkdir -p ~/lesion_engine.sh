#!/bin/bash

# ======= Color Scheme =======
GOLD="\e[1;38;5;214m"
RED="\e[1;31m"
CYAN="\e[1;36m"
RESET="\e[0m"

# ======= LESION Banner =======
function show_banner {
    echo -e "${RED}"
    cat << "EOF"
 ██████╗ ██╗   ██╗███████╗
 ██╔══██╗╚██╗ ██╔╝██╔════╝
 ██████╔╝ ╚████╔╝ █████╗  
 ██╔══██╗  ╚██╔╝  ██╔══╝  
 ██████╔╝   ██║   ██████╗
 ╚═════╝    ╚═╝   ╚═════╝  
EOF

    echo -e "${RED}"
    cat << "EOF"
        ,.:::::::.
      .:::::::::::,
     :::::::::::::::
    ::::    ██    ::::
   ::::   █▀▀▀█   :::: 
  ::::  █   █   █  ::::
 :::::  █▄▄▄▀  █  ::::::
::::::::::::::::::::::::
EOF
    echo -e "${RESET}"

    echo -e "${GOLD}"
    cat << "EOF"
     ██            ██
    ████          ████
   ██  ██        ██  ██
  ██    ██      ██    ██
 ██      ████████      ██
EOF
}

# ======= Animated Loader =======
function loading_bar {
    echo -e "\n${GOLD}««« ANONYMOUS »»»${RESET}\n"
    for i in {1..25}; do
        perc=$((i*4))
        bar=$(printf "%${i}s" | tr ' ' '▓')
        empty=$(printf "%$((25-i))s" | tr ' ' '░')
        echo -ne "${GOLD}[${RED}${bar}${GOLD}${empty}] ${CYAN}${perc}%${RESET}\r"
        sleep 0.05
    done
    echo -e "\n\n"
}

# ======= System Diagnostics =======
function system_info {
    echo -e "${GOLD}» OS Version: ${CYAN}$(uname -o)${RESET}"
    echo -e "${GOLD}» Kernel Release: ${CYAN}$(uname -r)${RESET}"
    echo -e "${GOLD}» Memory Usage: ${CYAN}$(free -m | awk '/Mem/{print $3 " MB"}')${RESET}"
    echo -e "${GOLD}» Storage Available: ${CYAN}$(df -h / | awk 'NR==2{print $4}')${RESET}\n"
}

# ======= Dependency Check =======
function check_dependencies {
    if ! command -v pkg &> /dev/null; then
        echo -e "${RED}[!] This script requires Termux environment!${RESET}"
        exit 1
    fi
}

# ======= Install Python Packages =======
function install_python_packages {
    echo -e "${RED}» Installing Python Packages...${RESET}"
    python -m ensurepip --upgrade
    python -m pip install --upgrade pip setuptools wheel
    echo -e "${GOLD}[✓] Python Environment Configured!${RESET}"
}

function auto_update_script {
    REPO_URL="https://raw.githubusercontent.com/sa6aa/Termux-toels/main/lesion_engine.sh"
    SCRIPT_NAME=$(basename "$0")
    
    echo -e "${GOLD}» Checking for updates...${RESET}"
    curl -s "$REPO_URL" -o "/tmp/$SCRIPT_NAME"
    
    if ! cmp -s "$0" "/tmp/$SCRIPT_NAME"; then
        echo -e "${RED}» Update found! Updating script...${RESET}"
        mv "/tmp/$SCRIPT_NAME" "$0"
        chmod +x "$0"
        echo -e "${GOLD}[✓] Script updated! Please restart.${RESET}"
        exit 0
    else
        echo -e "${GOLD}[✓] Script is up to date.${RESET}"
    fi
}

function check_and_install_dependencies {
    declare -A dependencies=(
        ["git"]="git"
        ["python"]="python"
        ["nmap"]="nmap"
        ["curl"]="curl"
        ["wget"]="wget"
        ["hydra"]="hydra"
        ["sqlmap"]="sqlmap"
    )
    
    for cmd in "${!dependencies[@]}"; do
        if ! command -v "$cmd" &> /dev/null; then
            echo -e "${RED}» Installing ${dependencies[$cmd]}...${RESET}"
            pkg install -y "${dependencies[$cmd]}"
        fi
    done
}

# ======= Installation Interface =======
function install_menu {
    while true; do
        echo -e "${GOLD}1. Install Core Utilities"
        echo -e "2. Install Security Toolkit"
        echo -e "3. System Diagnostics"
        echo -e "4. Exit Terminal${RESET}"
        echo -e "\n${CYAN}➤ Select Option: ${RESET}"
        read -n 1 choice
        
        case $choice in
            1)
                echo -e "\n${RED}» Installing Core Packages...${RESET}"
                pkg update -y && pkg upgrade -y
                pkg install -y python git nmap nano wget curl
                install_python_packages
                echo -e "${GOLD}[✓] Installation Completed!${RESET}"
                ;;
            2)
                echo -e "\n${RED}» Installing Security Tools...${RESET}"
                pkg install -y ruby termux-tools hydra sqlmap
                echo -e "${GOLD}[✓] Specialized Tools Installed!${RESET}"
                ;;
            3)
                echo -e "\n"
                system_info
                ;;
            4)
                echo -e "\n${GOLD}» Operation Completed ${RED}◕_◕${RESET}\n"
                exit 0
                ;;
            *)
                echo -e "\n${RED}[!] Invalid Selection!${RESET}"
                ;;
        esac
        echo -e "\n${GOLD}» Press Any Key to Continue...${RESET}"
        read -n 1
        clear
    done
}

# ======= Main Execution =======
check_dependencies
show_banner
loading_bar
system_info
install_menu
#!/bin/bash

# ==================================================
#  MACK CONTROL PANEL v3.0 | Auto-Detect System
# ==================================================

R="\e[31m"
G="\e[32m"
Y="\e[33m"
B="\e[34m"
M="\e[35m"
C="\e[36m"
W="\e[97m"
GR="\e[90m"
N="\e[0m"
BOLD="\e[1m"

detect_system() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS_NAME=$PRETTY_NAME
    else
        OS_NAME=$(uname -s)
    fi

    PUBLIC_IP=$(curl -s --max-time 2 https://ipinfo.io/ip || echo "Unknown")
    LOCAL_IP=$(hostname -I | awk '{print $1}')

    if command -v free >/dev/null 2>&1; then
        RAM_USED=$(free -h | awk '/^Mem:/ {print $3 "/" $2}')
    else
        RAM_USED="N/A"
    fi
}

draw_line() {
    echo -e "${B}╠════════════════════════════════════════════════════════════╣${N}"
}

header() {
    clear
    echo -e "${B}╔════════════════════════════════════════════════════════════╗${N}"
    echo -e "${B}║${N} ${C}${BOLD} MACK CONTROL PANEL v3.0 ${N} ${GR}| VPS Hub Dashboard ${N}    ${B}║${N}"
    draw_line
    echo -e "${B}║${N} ${W}OS:${N} ${G}${OS_NAME}${N}"
    echo -e "${B}║${N} ${W}Public IP:${N} ${Y}${PUBLIC_IP}${N} | ${W}Local IP:${N} ${Y}${LOCAL_IP}${N}"
    echo -e "${B}║${N} ${W}RAM Usage:${N} ${C}${RAM_USED}${N}"
    draw_line
}

show_menu() {
    echo -e "${B}║${N} ${M}${BOLD}PTERODACTYL WINGS MODULES:${N}"
    echo -e "${B}║${N}   ${C}[1]${N} Setup SSL Certificate"
    echo -e "${B}║${N}   ${C}[2]${N} Install Wings Daemon"
    echo -e "${B}║${N}   ${C}[3]${N} Configure Wings (config.yml)"
    echo -e "${B}║${N}   ${C}[4]${N} Manage Service (Start/Stop/Logs)"
    echo -e "${B}║${N}   ${C}[5]${N} Uninstall Wings"
    echo -e "${B}║${N} ${M}${BOLD}DATABASE MODULES:${N}"
    echo -e "${B}║${N}   ${C}[6]${N} Setup MySQL / MariaDB Auto-Setup"
    echo -e "${B}║${N} ${M}${BOLD}SYSTEM:${N}"
    echo -e "${B}║${N}   ${C}[0]${N} Exit Panel"
    draw_line
}

detect_system

while true; do
    header
    show_menu
    echo -ne "${C}root@mack-panel:~# ${N}"
    read opt
    
    case $opt in
        1) 
            bash <(curl -fsSL https://raw.githubusercontent.com/lie-kg1/lie-kg-Cloud/refs/heads/main/wings/install.sh)
            ;;
        2) 
            bash <(curl -fsSL https://raw.githubusercontent.com/lie-kg1/lie-kg-Cloud/refs/heads/main/wings/install.sh)
            ;;
        3) 
            bash <(curl -fsSL https://raw.githubusercontent.com/lie-kg1/lie-kg-Cloud/refs/heads/main/wings/config.sh)
            ;;
        4) 
            bash <(curl -fsSL https://raw.githubusercontent.com/lie-kg1/lie-kg-Cloud/refs/heads/main/wings/mang.sh)
            ;;
        5)
            echo -e "${R}Uninstalling Wings...${N}"
            rm -f /etc/systemd/system/wings.service
            rm -rf /etc/pterodactyl
            rm -f /usr/local/bin/wings
            rm -rf /var/lib/pterodactyl
            docker system prune -a -f 2>/dev/null
            echo -e "${G}✔ Uninstallation Finished.${N}"
            sleep 2
            ;;
        6)
            bash <(curl -fsSL https://raw.githubusercontent.com/lie-kg1/lie-kg-Cloud/refs/heads/main/db/db.sh)
            ;;
        0) 
            exit 0 
            ;;
        *) 
            echo -e "${R}Invalid option!${N}"
            sleep 1 
            ;;
    esac
done

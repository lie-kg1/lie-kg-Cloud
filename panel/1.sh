#!/bin/bash

# --- CONFIG & COLORS ---
CYAN='\033[38;5;51m'
PURPLE='\033[38;5;141m'
GRAY='\033[38;5;242m'
WHITE='\033[38;5;255m'
GREEN='\033[38;5;82m'
RED='\033[38;5;196m'
GOLD='\033[38;5;220m'
NC='\033[0m'

# --- SAFE RUNNER ---
run_script() {
    local url="$1"

    if [[ -z "$url" ]]; then
        echo -e "${RED}⚠ No script URL provided!${NC}"
        return 1
    fi

    echo -e "${CYAN}➜ Fetching script...${NC}"

    if ! bash <(curl -fsSL "$url"); then
        echo -e "${RED}⚠ Failed to run script from:${NC} $url"
    fi
}

pause() {
    echo ""
    echo -ne "  ${GRAY}Press any key to return...${NC}"
    read -n 1 -s -r
}

get_metrics() {
    UPT=$(uptime -p | sed 's/up //')
    LOAD=$(uptime | awk -F'load average:' '{print $2}' | cut -d, -f1 | xargs)
}

show_header() {
    get_metrics
    clear
    echo -e "${PURPLE}┌──────────────────────────────────────────────────────────┐${NC}"
    echo -e "${PURPLE}│${NC} 🛰️ ${CYAN}SERVER PANEL MANAGER${NC} ${GRAY}v15.0${NC}   ${GRAY}$(date +"%H:%M")${NC}                      ${PURPLE}│${NC}"
    echo -e "${PURPLE}└──────────────────────────────────────────────────────────┘${NC}"
    echo -e "  ${CYAN}SYSTEM STATUS${NC}"
    echo -e "  ${GRAY}├─ Uptime :${NC} ${WHITE}$UPT${NC}"
    echo -e "  ${GRAY}└─ Load   :${NC} ${WHITE}$LOAD${NC}"
    echo -e "${GRAY}────────────────────────────────────────────────────────────${NC}"
}

panel_menu() {
    while true; do
        show_header

        echo -e "  ${GOLD} AVAILABLE DEPLOYMENTS${NC}"
        echo -e "  ${GRAY}┌──────────────────────────┬──────────────────────────┐${NC}"
        echo -e "  ${GRAY}│${NC} ${PURPLE}[1]${NC} Pterodactyl        ${GRAY}│${NC} ${PURPLE}[7]${NC} Convoy                 ${GRAY}│${NC}"
        echo -e "  ${GRAY}│${NC} ${PURPLE}[2]${NC} Jexactyl           ${GRAY}│${NC} ${PURPLE}[8]${NC} FeatherPanel           ${GRAY}│${NC}"
        echo -e "  ${GRAY}│${NC} ${PURPLE}[3]${NC} JexPanel           ${GRAY}│${NC} ${PURPLE}[9]${NC} Mythicaldash           ${GRAY}│${NC}"
        echo -e "  ${GRAY}│${NC} ${PURPLE}[4]${NC} Reviactyl          ${GRAY}│${NC} ${PURPLE}[10]${NC} Mythicaldashv3        ${GRAY}│${NC}"
        echo -e "  ${GRAY}│${NC} ${PURPLE}[5]${NC} CtrlPanel          ${GRAY}│${NC} ${PURPLE}[11]${NC} VPS Panel             ${GRAY}│${NC}"
        echo -e "  ${GRAY}│${NC} ${PURPLE}[6]${NC} Paymenter          ${GRAY}│${NC} ${RED}[0]${NC} Exit                   ${GRAY}│${NC}"
        echo -e "  ${GRAY}└──────────────────────────┴──────────────────────────┘${NC}"

        echo ""
        echo -ne "  ${CYAN}λ Select Module [1-11]:${NC} "
        read p

        case $p in
            1)
                run_script "https://raw.githubusercontent.com/lie-kg1/lie-kg-Cloud/refs/heads/main/panel/pterodactyl/run.sh"
                pause
                ;;
            2)
                echo -e "${RED}No URL set for Jexactyl${NC}"
                pause
                ;;
            3)
                echo -e "${RED}No URL set for JexPanel${NC}"
                pause
                ;;
            4)
                run_script "https://raw.githubusercontent.com/lie-kg1/lie-kg-Cloud/refs/heads/main/panel/reviactyl/run.sh"
                pause
                ;;
            5)
                echo -e "${RED}No URL set for CtrlPanel${NC}"
                pause
                ;;
            6)
                run_script "https://raw.githubusercontent.com/lie-kg1/lie-kg-Cloud/refs/heads/main/panel/paymenter/run.sh"
                pause
                ;;
            7)
                run_script "https://raw.githubusercontent.com/lie-kg1/hub/refs/heads/main/liekgCloud/panel/convoy/run.sh"
                pause
                ;;
            8)
                echo -e "${RED}No URL set for FeatherPanel${NC}"
                pause
                ;;
            9)
                run_script "https://raw.githubusercontent.com/lie-kg1/lie-kg-Cloud/refs/heads/main/panel/mythical/run.sh"
                pause
                ;;
            10|11)
                echo -e "${RED}Not configured yet${NC}"
                pause
                ;;
            0)
                echo -e "\n${RED}Shutting down...${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}Invalid selection${NC}"
                sleep 1
                ;;
        esac
    done
}

panel_menu

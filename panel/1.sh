#!/bin/bash

# =========================
# COLORS
# =========================
CYAN='\033[38;5;51m'
PURPLE='\033[38;5;141m'
GRAY='\033[38;5;242m'
WHITE='\033[38;5;255m'
GREEN='\033[38;5;82m'
RED='\033[38;5;196m'
GOLD='\033[38;5;220m'
NC='\033[0m'

# =========================
# SAFE RUNNER
# =========================
run_script() {
    local url="$1"

    if [[ -z "$url" ]]; then
        echo -e "${RED}⚠ Missing URL${NC}"
        return 1
    fi

    echo -e "${CYAN}➜ Running script...${NC}"

    if ! bash <(curl -fsSL "$url"); then
        echo -e "${RED}⚠ Failed: $url${NC}"
    fi
}

# =========================
# PAUSE
# =========================
pause() {
    echo ""
    echo -ne "  ${GRAY}Press any key to continue...${NC}"
    read -n 1 -s -r
}

# =========================
# SYSTEM INFO
# =========================
get_metrics() {
    UPT=$(uptime -p | sed 's/up //')
    LOAD=$(uptime | awk -F'load average:' '{print $2}' | cut -d, -f1 | xargs)
}

# =========================
# HEADER
# =========================
show_header() {
    get_metrics
    clear
    echo -e "${PURPLE}┌──────────────────────────────────────────────────────────┐${NC}"
    echo -e "${PURPLE}│${NC}  ${CYAN}🛰️ SERVER PANEL MANAGER${NC} ${GRAY}v15.0${NC}   ${GRAY}$(date +"%H:%M")${NC} ${PURPLE}│${NC}"
    echo -e "${PURPLE}└──────────────────────────────────────────────────────────┘${NC}"

    echo -e "  ${CYAN}SYSTEM STATUS${NC}"
    echo -e "  ${GRAY}├─ Uptime :${NC} ${WHITE}$UPT${NC}"
    echo -e "  ${GRAY}└─ Load   :${NC} ${WHITE}$LOAD${NC}"
    echo -e "${GRAY}────────────────────────────────────────────────────────────${NC}"
}

# =========================
# MENU GRID (FIXED ALIGNMENT)
# =========================
menu_grid() {
    echo -e "  ${GOLD} AVAILABLE DEPLOYMENTS${NC}"

    echo -e "  ${GRAY}┌──────────────────────────┬──────────────────────────┐${NC}"

    printf "  ${GRAY}│${NC} %-24s ${GRAY}│${NC} %-24s ${NC}\n" "[1] Pterodactyl" "[7] Convoy"
    printf "  ${GRAY}│${NC} %-24s ${GRAY}│${NC} %-24s ${NC}\n" "[2] Jexactyl" "[8] FeatherPanel"
    printf "  ${GRAY}│${NC} %-24s ${GRAY}│${NC} %-24s ${NC}\n" "[3] JexPanel" "[9] Mythicaldash"
    printf "  ${GRAY}│${NC} %-24s ${GRAY}│${NC} %-24s ${NC}\n" "[4] Reviactyl" "[10] Mythicaldashv3"
    printf "  ${GRAY}│${NC} %-24s ${GRAY}│${NC} %-24s ${NC}\n" "[5] CtrlPanel" "[11] VPS Panel"
    printf "  ${GRAY}│${NC} %-24s ${GRAY}│${NC} %-24s ${NC}\n" "[6] Paymenter" "[0] Exit"

    echo -e "  ${GRAY}└──────────────────────────┴──────────────────────────┘${NC}"
}

# =========================
# MAIN MENU
# =========================
panel_menu() {
    while true; do
        show_header
        menu_grid

        echo ""
        echo -ne "  ${CYAN}λ Select Module [1-11]:${NC} "
        read p

        case $p in
            1)
                run_script "https://raw.githubusercontent.com/lie-kg1/lie-kg-Cloud/refs/heads/main/panel/pterodactyl/run.sh"
                pause
                ;;
            2)
                echo -e "${RED}Not configured${NC}"
                pause
                ;;
            3)
                echo -e "${RED}Not configured${NC}"
                pause
                ;;
            4)
                run_script "https://raw.githubusercontent.com/lie-kg1/lie-kg-Cloud/refs/heads/main/panel/reviactyl/run.sh"
                pause
                ;;
            5)
                echo -e "${RED}Not configured${NC}"
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
                echo -e "${RED}Not configured${NC}"
                pause
                ;;
            9)
                run_script "https://raw.githubusercontent.com/lie-kg1/lie-kg-Cloud/refs/heads/main/panel/mythical/run.sh"
                pause
                ;;
            10|11)
                echo -e "${RED}Not configured${NC}"
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

# =========================
# START
# =========================
panel_menu

#!/bin/bash

# =========================
# COLORS (SAFE)
# =========================
RESET="\033[0m"
BOLD="\033[1m"

CYAN="\033[38;5;51m"
PURPLE="\033[38;5;141m"
GRAY="\033[38;5;242m"
WHITE="\033[38;5;255m"
GREEN="\033[38;5;82m"
RED="\033[38;5;196m"
GOLD="\033[38;5;220m"

# =========================
# SAFE RUNNER
# =========================
run_script() {
    local url="$1"

    if [[ -z "$url" ]]; then
        echo -e "${RED}⚠ Missing URL${RESET}"
        return 1
    fi

    echo -e "${CYAN}➜ Running script...${RESET}"

    bash <(curl -fsSL "$url") || {
        echo -e "${RED}⚠ Failed to run script${RESET}"
    }
}

# =========================
# PAUSE
# =========================
pause() {
    echo ""
    echo -ne "  ${GRAY}Press any key...${RESET}"
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

    echo -e "${PURPLE}┌──────────────────────────────────────────────────────────┐${RESET}"
    echo -e "${PURPLE}│${RESET}  ${CYAN}🛰️ SERVER PANEL MANAGER${RESET} ${GRAY}v15.0${RESET}   ${GRAY}$(date +"%H:%M")${RESET} ${PURPLE}│${RESET}"
    echo -e "${PURPLE}└──────────────────────────────────────────────────────────┘${RESET}"

    echo -e "  ${CYAN}SYSTEM STATUS${RESET}"
    echo -e "  ${GRAY}├─ Uptime :${RESET} ${WHITE}$UPT${RESET}"
    echo -e "  ${GRAY}└─ Load   :${RESET} ${WHITE}$LOAD${RESET}"

    echo -e "${GRAY}────────────────────────────────────────────────────────────${RESET}"
}

# =========================
# MENU
# =========================
menu_grid() {
    echo -e "  ${GOLD} AVAILABLE DEPLOYMENTS${RESET}"

    echo -e "  ${GRAY}┌──────────────────────────┬──────────────────────────┐${RESET}"

    printf "  ${GRAY}│${RESET} ${CYAN}%-24b${RESET} ${GRAY}│${RESET} ${CYAN}%-24b${RESET}\n" \
    "${BOLD}[1] Pterodactyl" "${BOLD}[7] Convoy"

    printf "  ${GRAY}│${RESET} ${CYAN}%-24b${RESET} ${GRAY}│${RESET} ${CYAN}%-24b${RESET}\n" \
    "${BOLD}[2] Jexactyl" "${BOLD}[8] FeatherPanel"

    printf "  ${GRAY}│${RESET} ${CYAN}%-24b${RESET} ${GRAY}│${RESET} ${CYAN}%-24b${RESET}\n" \
    "${BOLD}[3] JexPanel" "${BOLD}[9] Mythicaldash"

    printf "  ${GRAY}│${RESET} ${CYAN}%-24b${RESET} ${GRAY}│${RESET} ${CYAN}%-24b${RESET}\n" \
    "${BOLD}[4] Reviactyl" "${BOLD}[10] Mythicaldashv3"

    printf "  ${GRAY}│${RESET} ${CYAN}%-24b${RESET} ${GRAY}│${RESET} ${CYAN}%-24b${RESET}\n" \
    "${BOLD}[5] CtrlPanel" "${BOLD}[11] VPS Panel"

    printf "  ${GRAY}│${RESET} ${CYAN}%-24b${RESET} ${GRAY}│${RESET} ${RED}[0] Exit${RESET}%-17s ${GRAY}│${RESET}\n" \
    "[6] Paymenter" ""
    
    echo -e "  ${GRAY}└──────────────────────────┴──────────────────────────┘${RESET}"
}

# =========================
# MAIN LOOP
# =========================
panel_menu() {
    while true; do
        show_header
        menu_grid

        echo ""
        echo -ne "  ${CYAN}λ Select Module [1-11]:${RESET} "
        read p

        case $p in
            1)
                run_script "https://raw.githubusercontent.com/lie-kg1/lie-kg-Cloud/refs/heads/main/panel/pterodactyl/run.sh"
                pause
                ;;
            2)
                echo -e "${RED}Not configured${RESET}"
                pause
                ;;
            3)
                echo -e "${RED}Not configured${RESET}"
                pause
                ;;
            4)
                run_script "https://raw.githubusercontent.com/lie-kg1/lie-kg-Cloud/refs/heads/main/panel/reviactyl/run.sh"
                pause
                ;;
            5)
                echo -e "${RED}Not configured${RESET}"
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
                echo -e "${RED}Not configured${RESET}"
                pause
                ;;
            9)
                run_script "https://raw.githubusercontent.com/lie-kg1/lie-kg-Cloud/refs/heads/main/panel/mythical/run.sh"
                pause
                ;;
            10|11)
                echo -e "${RED}Not configured${RESET}"
                pause
                ;;
            0)
                echo -e "\n${RED}Exiting...${RESET}"
                exit 0
                ;;
            *)
                echo -e "${RED}Invalid option${RESET}"
                sleep 1
                ;;
        esac
    done
}

# =========================
# START
# =========================
panel_menu

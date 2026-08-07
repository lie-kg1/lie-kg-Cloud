#!/bin/bash

CYAN='\033[38;5;51m'
PURPLE='\033[38;5;141m'
GRAY='\033[38;5;242m'
WHITE='\033[38;5;255m'
GREEN='\033[38;5;82m'
RED='\033[38;5;196m'
GOLD='\033[38;5;214m'
NC='\033[0m'

SERVICE="wings"

get_status() {
    if systemctl is-active --quiet $SERVICE; then
        echo -e "${GREEN}ACTIVE${NC}"
    else
        echo -e "${RED}INACTIVE${NC}"
    fi
}

show_header() {
    clear
    STATUS=$(get_status)
    echo -e "${PURPLE}┌──────────────────────────────────────────────────────────┐${NC}"
    echo -e "${PURPLE}│${NC}  ${CYAN}🪽  WINGS CONTROL CENTER${NC} ${GRAY}v17.0${NC}          status: $STATUS  ${PURPLE}│${NC}"
    echo -e "${PURPLE}└──────────────────────────────────────────────────────────┘${NC}"
}

while true; do
    show_header
    echo -e "  ${CYAN}SERVICE MANAGEMENT${NC}"
    echo -e "  ${GRAY}├─ [1]${NC} Start       ${GRAY}[4]${NC} Status"
    echo -e "  ${GRAY}├─ [2]${NC} Restart     ${GRAY}[5]${NC} Live Logs"
    echo -e "  ${GRAY}└─ [3]${NC} Stop        ${GRAY}[6]${NC} Exit Manager"
    echo ""
    echo -ne "  ${CYAN}λ${NC} ${WHITE}Select Option:${NC} "
    read -r choice

    case $choice in
        1) sudo systemctl start $SERVICE; echo -e "  ${GREEN}✔ Started${NC}"; sleep 1 ;;
        2) sudo systemctl restart $SERVICE; echo -e "  ${CYAN}✔ Restarted${NC}"; sleep 1 ;;
        3) sudo systemctl stop $SERVICE; echo -e "  ${RED}✔ Stopped${NC}"; sleep 1 ;;
        4) systemctl status $SERVICE; echo -e "\nPress enter to continue..."; read ;;
        5) journalctl -u $SERVICE -f ;;
        6) exit 0 ;;
        *) echo -e "  ${RED}Invalid option${NC}"; sleep 1 ;;
    esac
done

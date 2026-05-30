#!/bin/bash

# ===== COLORS =====
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
BOLD='\033[1m'
RESET='\033[0m'

clear

# ===== STATUS =====
if [ -d /opt/featherpanel ]; then
  STATUS="${GREEN}INSTALLED ✔${RESET}"
else
  STATUS="${RED}NOT INSTALLED ✘${RESET}"
fi

# ===== HEADER =====
echo -e "${CYAN}${BOLD}╭─────────────────────────────────────╮${RESET}"
echo -e "${CYAN}${BOLD}│              FEATHERPANEL           │${RESET}"
echo -e "${CYAN}${BOLD}├─────────────────────────────────────┤${RESET}"

echo -e "│ FEATHERPANEL STATUS: $STATUS        │"

echo -e "${CYAN}${BOLD}├─────────────────────────────────────╮${RESET}"

# ===== MENU =====
echo -e "│  ${YELLOW}[1]${RESET} Install FeatherPanel            │"
echo -e "│  ${YELLOW}[2]${RESET} Update Release                  │"
echo -e "│  ${YELLOW}[3]${RESET} Domain                          │"
echo -e "│  ${YELLOW}[4]${RESET} Uninstall Panel                 │"
echo -e "│  ${YELLOW}[5]${RESET} phpMyAdmin                     │"

echo -e "${CYAN}${BOLD}├─────────────────────────────────────┤${RESET}"
echo -e "│  ${RED}[0]${RESET} Exit                            │"
echo -e "${CYAN}${BOLD}╰─────────────────────────────────────╯${RESET}"

echo
read -rp "Select option: " opt

case "$opt" in
  1)
    bash <(curl -fsSL https://raw.githubusercontent.com/lie-kg1/ptero/refs/heads/main/ptero/panel/FeatherPanel/install.sh)
    ;;
  2)
    bash <(curl -fsSL https://raw.githubusercontent.com/lie-kg1/lie-kg-Cloud/refs/heads/main/panel/FeatherPanel/update.sh)
    ;;
  3)
    bash <(curl -fsSL https://raw.githubusercontent.com/lie-kg1/lie-kg-Cloud/refs/heads/main/panel/FeatherPanel/domain.sh)
    ;;
  4)
    rm -rf /opt/featherpanel
    rm -f /usr/local/bin/featherpanel
    echo -e "${GREEN}Panel removed successfully${RESET}"
    ;;
  0)
    echo -e "${YELLOW}Exiting...${RESET}"
    exit 0
    ;;
  *)
    echo -e "${RED}Invalid option${RESET}"
    ;;
esac

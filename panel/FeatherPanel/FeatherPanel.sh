#!/bin/bash

# ===== COLORS =====
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
RESET='\033[0m'

clear

echo -e "${CYAN}╭─────────────────────────────────────╮${RESET}"
echo -e "${CYAN}│              FEATHERPANEL           │${RESET}"
echo -e "${CYAN}├─────────────────────────────────────┤${RESET}"
echo -e "│  ${YELLOW}[1]${RESET} Install FeatherPanel         │"
echo -e "│  ${YELLOW}[3]${RESET} Update Release               │"
echo -e "│  ${YELLOW}[4]${RESET} Domain & SSL                 │"
echo -e "│  ${YELLOW}[5]${RESET} Uninstall Panel              │"
echo -e "${CYAN}├─────────────────────────────────────┤${RESET}"
echo -e "│  ${RED}[0]${RESET} Exit                         │"
echo -e "${CYAN}╰─────────────────────────────────────╯${RESET}"

echo
read -p "Select option: " opt

case $opt in
  1)
    bash <(curl -fsSL https://raw.githubusercontent.com/lie-kg1/ptero/refs/heads/main/ptero/panel/FeatherPanel/install.sh)
    ;;
  3)
    bash <(curl -fsSL https://raw.githubusercontent.com/USER/REPO/main/update.sh)
    ;;
  4)
    bash <(curl -fsSL https://raw.githubusercontent.com/USER/REPO/main/domain.sh)
    ;;
  5)
    rm -rf /opt/featherpanel
    rm -f /usr/local/bin/featherpanel
    echo "Panel removed"
    ;;
  0)
    echo "Exiting..."
    exit 0
    ;;
  *)
    echo "Invalid option"
    ;;
esac

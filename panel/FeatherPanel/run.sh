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
echo -e "${CYAN}┌───────────────────────────────────────┐${RESET}"
echo -e "${CYAN}│               FEATHERPANEL            │${RESET}"
echo -e "${CYAN}├───────────────────────────────────────┤${RESET}"

# ===== STATUS LINE (FIXED BORDER COLOR ISSUE) =====
echo -e "${CYAN}│${RESET} FEATHERPANEL STATUS: $STATUS  ${CYAN}│${RESET}"

echo -e "${CYAN}├───────────────────────────────────────┤${RESET}"

# ===== MENU =====
echo -e "${CYAN}│${RESET}  ${GREEN}[1]${RESET} Install FeatherPanel             ${CYAN}│${RESET}"
echo -e "${CYAN}│${RESET}  ${YELLOW}[2]${RESET} Update latest                    ${CYAN}│${RESET}"
echo -e "${CYAN}│${RESET}  ${BLUE}[3]${RESET} Domain                           ${CYAN}│${RESET}"
echo -e "${CYAN}│${RESET}  ${RED}[4]${RESET} Uninstall Panel                  ${CYAN}│${RESET}"

echo -e "${CYAN}├───────────────────────────────────────┤${RESET}"
echo -e "${CYAN}│${RESET}  ${WHITE}[0]${RESET} Exit                             ${CYAN}│${RESET}"
echo -e "${CYAN}└───────────────────────────────────────┘${RESET}"

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
    bash <(curl -fsSL https://raw.githubusercontent.com/lie-kg1/lie-kg-Cloud/refs/heads/main/panel/FeatherPanel/Uninstall.sh)
    ;;
  0)
    echo -e "${YELLOW}Exiting...${RESET}"
    exit 0
    ;;
  *)
    echo -e "${RED}Invalid option${RESET}"
    ;;
esac

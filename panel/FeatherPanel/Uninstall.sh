#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RESET='\033[0m'

echo -e "${YELLOW}Are you sure you want to uninstall FeatherPanel? (y/n)${RESET}"
read -r confirm

if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
  echo -e "${CYAN}Cancelled.${RESET}"
  exit 0
fi

echo -e "${YELLOW}Removing FeatherPanel...${RESET}"

# Remove main folder
if [ -d /opt/featherpanel ]; then
  rm -rf /opt/featherpanel
  echo -e "${GREEN}✔ Removed /opt/featherpanel${RESET}"
else
  echo -e "${RED}✘ /opt/featherpanel not found${RESET}"
fi

# Remove binary
if [ -f /usr/local/bin/featherpanel ]; then
  rm -f /usr/local/bin/featherpanel
  echo -e "${GREEN}✔ Removed binary${RESET}"
else
  echo -e "${RED}✘ Binary not found${RESET}"
fi

echo -e "${GREEN}Uninstall complete.${RESET}"

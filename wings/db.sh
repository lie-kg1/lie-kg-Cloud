#!/bin/bash

C_RESET='\033[0m'
C_BOLD='\033[1m'
C_RED='\033[1;31m'
C_GREEN='\033[1;32m'
C_YELLOW='\033[1;33m'
C_BLUE='\033[1;34m'
C_PURPLE='\033[1;35m'
C_CYAN='\033[1;36m'
C_WHITE='\033[1;37m'
C_GRAY='\033[1;90m'

clear
echo -e "${C_PURPLE}${C_BOLD} ⚡ DATABASE AUTO-SETUP :: v2.0${C_RESET}\n"

echo -ne "${C_CYAN}Enter Database Username: ${C_RESET}"
read DB_USER
echo -ne "${C_CYAN}Enter Database Password: ${C_RESET}"
read -s DB_PASS
echo ""

echo -e "${C_YELLOW}Installing/Configuring MariaDB...${C_RESET}"
apt-get update -y >/dev/null 2>&1 || true
apt-get install -y mariadb-server >/dev/null 2>&1 || true
systemctl enable --now mariadb >/dev/null 2>&1 || true

mysql -e "CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASS'; GRANT ALL PRIVILEGES ON *.* TO '$DB_USER'@'%' WITH GRANT OPTION; FLUSH PRIVILEGES;" 2>/dev/null

CONF_FILE="/etc/mysql/mariadb.conf.d/50-server.cnf"
if [ -f "$CONF_FILE" ]; then
    sed -i 's/^bind-address.*/bind-address = 0.0.0.0/' "$CONF_FILE"
    echo -e "${C_GREEN}✔ Remote Access Enabled (0.0.0.0)${C_RESET}"
fi

systemctl restart mariadb 2>/dev/null || systemctl restart mysql 2>/dev/null

if command -v ufw &>/dev/null; then
    ufw allow 3306/tcp >/dev/null 2>&1
    echo -e "${C_GREEN}✔ Firewall Port 3306 Opened${C_RESET}"
fi

echo -e "\n${C_GREEN}${C_BOLD}⚡ DATABASE SETUP COMPLETE!${C_RESET}"

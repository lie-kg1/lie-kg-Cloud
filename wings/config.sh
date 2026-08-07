#!/bin/bash
set -e

RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
PURPLE='\033[1;35m'
CYAN='\033[1;36m'
WHITE='\033[1;37m'
NC='\033[0m'

msg_info() { echo -e "  ${BLUE}➜${NC} $1"; }
msg_ok()   { echo -e "  ${GREEN}✔${NC} $1"; }
msg_err()  { echo -e "  ${RED}✖${NC} $1"; }
msg_input() { echo -ne "  ${PURPLE}➤${NC} $1: \"; }

spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    0
    done
}

clear
echo -e "${CYAN}=================================================="
echo -e "         WINGS CONFIGURATOR v3.2                  "
echo -e "==================================================${NC}\n"

msg_input "Enter Panel URL (e.g. https://panel.domain.com)"
read REMOTE

msg_input "Enter Node API Token ID"
read TOKEN_ID

msg_input "Enter Node API Token"
read TOKEN

msg_input "Enter Node UUID"
read UUID

msg_input "Enter Daemon Port [Default: 8080]"
read API_PORT
API_PORT=${API_PORT:-8080}

msg_info "Writing configuration to /etc/pterodactyl/config.yml..."
rm -f /etc/pterodactyl/config.yml
mkdir -p /etc/pterodactyl

cat <<CFG > /etc/pterodactyl/config.yml
debug: false
uuid: ${UUID}
token_id: ${TOKEN_ID}
token: ${TOKEN}
api:
  host: 0.0.0.0
  port: ${API_PORT}
  ssl:
    enabled: true
    cert: /etc/certs/wing/fullchain.pem
    key: /etc/certs/wing/privkey.pem
  upload_limit: 100
system:
  data: /var/lib/pterodactyl/volumes
  sftp:
    bind_port: 2022
allowed_mounts: []
remote: '${REMOTE}'
CFG

msg_ok "Configuration file successfully created!"
systemctl enable wings >/dev/null 2>&1
systemctl restart wings >/dev/null 2>&1
msg_ok "Wings daemon restarted and enabled successfully."

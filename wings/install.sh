#!/bin/bash
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

CHECKMARK="✓"
CROSSMARK="✗"
ARROW="➤"

print_header() {
    echo -e "\n${MAGENTA}╔══════════════════════════════════════════╗${NC}"
    echo -e "${MAGENTA}║${NC}${CYAN}   $1${NC}"
    echo -e "${MAGENTA}╚══════════════════════════════════════════╝${NC}"
}

print_status() { echo -e "${YELLOW}${ARROW} $1...${NC}"; }
print_success() { echo -e "${GREEN}${CHECKMARK} $1${NC}"; }
print_error() { echo -e "${RED}${CROSSMARK} $1${NC}"; }

check_success() {
    if [ $? -eq 0 ]; then
        print_success "$1"
        return 0
    else
        print_error "$2"
        return 1
    fi
}

clear
print_header "PTERODACTYL WINGS INSTALLER"

print_status "Installing Docker & Dependencies"
apt-get update -y > /dev/null 2>&1 || true
curl -sSL https://get.docker.com | CHANNEL=stable bash > /dev/null 2>&1
systemctl enable --now docker > /dev/null 2>&1
check_success "Docker installed successfully" "Docker installation failed"

print_header "DOWNLOADING WINGS BINARY"
print_status "Fetching latest binary from GitHub"
curl -L -o /usr/local/bin/wings https://github.com/pterodactyl/wings/releases/latest/download/wings_linux_amd64 > /dev/null 2>&1
chmod +x /usr/local/bin/wings
check_success "Wings binary downloaded" "Failed to download wings binary"

print_header "CREATING SYSTEMD SERVICE"
sudo tee /etc/systemd/system/wings.service > /dev/null <<EOF
[Unit]
Description=Pterodactyl Wings Daemon
After=docker.service
Requires=docker.service
PartOf=docker.service

[Service]
User=root
WorkingDirectory=/etc/pterodactyl
ExecStart=/usr/local/bin/wings
Restart=always
RestartSec=5
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload > /dev/null 2>&1
sudo systemctl enable wings > /dev/null 2>&1
check_success "Wings service registered and enabled"

print_header "GENERATING SSL"
sudo mkdir -p /etc/certs/wing
cd /etc/certs/wing || exit
sudo openssl req -new -newkey rsa:4096 -days 3650 -nodes -x509 \
-subj "/C=NA/ST=NA/L=NA/O=NA/CN=Generic SSL Certificate" \
-keyout privkey.pem -out fullchain.pem > /dev/null 2>&1
check_success "Self-signed SSL certificate generated"

print_header "CREATING HELPER COMMAND"
sudo tee /usr/local/bin/wing > /dev/null <<'EOF'
#!/bin/bash
echo ""
echo "Wings Helper Commands:"
echo "  start    : sudo systemctl start wings"
echo "  stop     : sudo systemctl stop wings"
echo "  status   : sudo systemctl status wings"
echo "  restart  : sudo systemctl restart wings"
echo "  logs     : sudo journalctl -u wings -f"
echo ""
EOF
sudo chmod +x /usr/local/bin/wing
print_success "Helper command created (/usr/local/bin/wing)"

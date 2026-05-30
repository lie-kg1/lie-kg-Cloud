#!/bin/bash

# ==================================================
# FEATHERPANEL DOMAIN & SSL SETUP
# ==================================================

C_RESET="\e[0m"
C_RED="\e[1;31m"
C_GREEN="\e[1;32m"
C_BLUE="\e[1;34m"
C_CYAN="\e[1;36m"
C_GRAY="\e[1;90m"

clear

echo -e "${C_CYAN}"
echo "======================================"
echo "     FEATHERPANEL DOMAIN & SSL"
echo "======================================"
echo -e "${C_RESET}"

# ---------------- INPUT ----------------
read -p "🌐 Enter domain (example.com): " DOMAIN

if [[ -z "$DOMAIN" ]]; then
  echo -e "${C_RED}❌ Domain is required${C_RESET}"
  exit 1
fi

echo ""

# ---------------- INSTALL CERTBOT ----------------
echo -e "${C_BLUE}[1/4] Installing Certbot...${C_RESET}"
apt update -y
apt install -y certbot python3-certbot-nginx

# ---------------- NGINX CONFIG ----------------
echo -e "${C_BLUE}[2/4] Configuring Nginx...${C_RESET}"

cat <<EOF > /etc/nginx/sites-available/featherpanel.conf
server {
    listen 80;
    server_name ${DOMAIN};

    location / {
        proxy_pass http://127.0.0.1:8721;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }
}
EOF

ln -sf /etc/nginx/sites-available/featherpanel.conf /etc/nginx/sites-enabled/

systemctl restart nginx

# ---------------- SSL ----------------
echo -e "${C_BLUE}[3/4] Installing SSL (Let's Encrypt)...${C_RESET}"

certbot --nginx -d "$DOMAIN" --non-interactive --agree-tos -m admin@"$DOMAIN"

# ---------------- FINISH ----------------
echo -e "${C_BLUE}[4/4] Restarting services...${C_RESET}"

systemctl restart nginx

echo ""
echo -e "${C_GREEN}======================================"
echo "✔ DOMAIN & SSL SETUP COMPLETE"
echo "🌐 https://$DOMAIN"
echo "======================================"
echo -e "${C_RESET}"

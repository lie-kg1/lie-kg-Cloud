#!/bin/bash

# ==================================================
# FEATHERPANEL UPDATER (FIXED SMART VERSION)
# ==================================================

C_RESET="\e[0m"
C_RED="\e[1;31m"
C_GREEN="\e[1;32m"
C_YELLOW="\e[1;33m"
C_BLUE="\e[1;34m"
C_GRAY="\e[1;90m"

line() { echo -e "${C_GRAY}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}"; }
ok() { echo -e "${C_GREEN}✔ $1${C_RESET}"; }
err() { echo -e "${C_RED}❌ $1${C_RESET}"; }
step() { echo -e "${C_BLUE}➜ $1${C_RESET}"; }

clear

echo -e "${C_BLUE}======================================"
echo "        FEATHERPANEL UPDATER"
echo "======================================"
echo -e "${C_RESET}"

line

# ---------------- AUTO DETECT INSTALL ----------------
INSTALL_DIR=""

if [ -d "/opt/featherpanel" ]; then
  INSTALL_DIR="/opt/featherpanel"
elif [ -d "/var/www/featherpanel" ]; then
  INSTALL_DIR="/var/www/featherpanel"
fi

if [ -z "$INSTALL_DIR" ]; then
  err "FeatherPanel is not installed"
  echo -e "${C_YELLOW}Tip: run installer first${C_RESET}"
  exit 1
fi

ok "Detected install: $INSTALL_DIR"

cd "$INSTALL_DIR" || exit 1

line

# ---------------- CHECK GIT ----------------
if [ ! -d ".git" ]; then
  err "Not a git installation (cannot update)"
  echo -e "${C_YELLOW}Reinstall using run.sh to fix this${C_RESET}"
  exit 1
fi

# ---------------- FETCH ----------------
step "Fetching updates..."
git fetch origin main

LOCAL=$(git rev-parse HEAD)
REMOTE=$(git rev-parse origin/main)

# ---------------- COMPARE ----------------
if [ "$LOCAL" = "$REMOTE" ]; then
  ok "Already up to date"
  exit 0
fi

# ---------------- UPDATE ----------------
step "Pulling latest changes..."
git pull origin main

# ---------------- REBUILD (SAFE CHECKS) ----------------
step "Rebuilding project..."

if [ -f "backend/package.json" ]; then
  cd backend
  npm install
  ok "Backend updated"
  cd ..
fi

if [ -d "frontend" ]; then
  cd frontend
  npm install
  npm run build
  ok "Frontend rebuilt"
  cd ..
fi

line

ok "Update completed successfully"
echo -e "${C_GREEN}✔ FeatherPanel is now up to date${C_RESET}"
line

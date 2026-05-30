#!/bin/bash

# ==================================================
# FEATHERPANEL UPDATER
# Fast • Safe • Production Ready
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

INSTALL_DIR="/opt/featherpanel"

# ---------------- CHECK INSTALL ----------------
if [ ! -d "$INSTALL_DIR" ]; then
  err "FeatherPanel is not installed"
  exit 1
fi

cd "$INSTALL_DIR" || exit

step "Checking repository..."

# ---------------- CHECK GIT ----------------
if [ ! -d ".git" ]; then
  err "Not a git installation (update not possible)"
  exit 1
fi

# ---------------- FETCH ----------------
step "Fetching latest updates..."
git fetch origin main

LOCAL=$(git rev-parse HEAD)
REMOTE=$(git rev-parse origin/main)

# ---------------- COMPARE ----------------
if [ "$LOCAL" = "$REMOTE" ]; then
  ok "Already up to date"
  exit 0
fi

# ---------------- PULL ----------------
step "Updating files..."
git pull origin main

# ---------------- BUILD ----------------
step "Rebuilding (if Go project exists)..."

if [ -f "main.go" ]; then
  go build -o featherpanel main.go
  chmod +x featherpanel
  ok "Go build completed"
else
  step "No Go build found, skipping"
fi

line

ok "Update completed successfully"
echo -e "${C_GREEN}✔ FeatherPanel is now up to date${C_RESET}"
line

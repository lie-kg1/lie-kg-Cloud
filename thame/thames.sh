#!/usr/bin/env bash

# =========================================================
# lie_kg.dev CONTROL PANEL UI (FIXED VERSION)
# =========================================================

set -euo pipefail

# =========================================================
# ROOT CHECK
# =========================================================
[[ $EUID -ne 0 ]] && {
    echo "Run as root!"
    exit 1
}

# =========================================================
# PATH FIX
# =========================================================
export PATH=$PATH:/usr/local/bin:/usr/bin:/bin

# =========================================================
# COLORS
# =========================================================
R="\e[31m"
G="\e[32m"
Y="\e[33m"
B="\e[34m"
M="\e[35m"
C="\e[36m"
W="\e[97m"
N="\e[0m"

BR="\e[1;31m"
BG="\e[1;32m"
BY="\e[1;33m"
BC="\e[1;36m"
BW="\e[1;97m"

# =========================================================
# CONFIG
# =========================================================
BASE_DIR="/var/www/pterodactyl"
EXT_DIR="$BASE_DIR/storage/extensions"
URL="https://github.com/lie-kg1/lie-kg-Cloud/raw/refs/heads/main/thame/UI"

# =========================================================
# TRAP
# =========================================================
trap 'echo -e "\n${R}[!] Force exit detected.${N}"; exit 1' SIGINT

# =========================================================
# THEMES
# =========================================================
themes=(
"nebula.blueprint"
"euphoriatheme.blueprint"
"BetterAdmin.blueprint"
"abysspurple.blueprint"
"amberabyss.blueprint"
"catppuccindactyl.blueprint"
"crimsonabyss.blueprint"
"emeraldabyss.blueprint"
"nightadmin.blueprint"
"refreshtheme.blueprint"
"slice.blueprint"
"darkenate.blueprint"
"recolor.blueprint"
"bluetables.blueprint"
"ultradarkadmin.blueprint"
"xlpaneltheme.blueprint"
"lememtheme.blueprint"
"slate.blueprint"
"kaelixprime.blueprint"
"m3dactyl.blueprint"
)

# =========================================================
# TITLE
# =========================================================
get_title() {
    echo "        • — lie_kg.dev CONTROL HUB — •        "
}

# =========================================================
# CHECK INSTALL
# =========================================================
is_installed() {
    [[ -d "$EXT_DIR/${1%.blueprint}" ]]
}

# =========================================================
# SPINNER (FIXED)
# =========================================================
spinner() {
    local pid="$1"
    local spin='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'

    while kill -0 "$pid" 2>/dev/null; do
        for ((i=0; i<${#spin}; i++)); do
            printf "\r ${C}%s${N} Processing..." "${spin:$i:1}"
            sleep 0.08
        done
    done

    printf "\r"
}

# =========================================================
# INSTALL THEME (FIXED)
# =========================================================
install_theme() {

    local theme="$1"

    cd "$BASE_DIR" || {
        echo -e "${R}Pterodactyl not found!${N}"
        return
    }

    echo -e "\n${G}Installing:${N} ${BW}${theme%.blueprint}${N}"

    curl -fsSL "$URL/$theme" -o "$theme" || {
        echo -e "${R}Download failed${N}"
        return
    }

    (
        yes | blueprint -i "$theme" >/dev/null 2>&1
        rm -f "$theme"
    ) &

    pid=$!
    spinner "$pid"
    wait "$pid"

    if is_installed "$theme"; then
        echo -e "${BG}✔ Install Success${N}"
    else
        echo -e "${BR}✘ Install Failed${N}"
    fi
}

# =========================================================
# REMOVE THEME (FIXED)
# =========================================================
remove_theme() {

    local theme="$1"

    cd "$BASE_DIR" || {
        echo -e "${R}Pterodactyl not found!${N}"
        return
    }

    echo -e "\n${R}Removing:${N} ${BW}${theme%.blueprint}${N}"

    (
        yes | blueprint -r "${theme%.blueprint}" >/dev/null 2>&1
    ) &

    pid=$!
    spinner "$pid"
    wait "$pid"

    if ! is_installed "$theme"; then
        echo -e "${BG}✔ Remove Success${N}"
    else
        echo -e "${BR}✘ Remove Failed${N}"
    fi
}

# =========================================================
# MENU
# =========================================================
show_menu() {

    clear

    echo -e "${BC} ╔══════════════════════════════════════════════════════════╗${N}"
    printf " ${BC}║${BW}%-58s${BC}║${N}\n" "$(get_title)"
    printf " ${BC}║${B}%-58s${BC}║${N}\n" "      Minimal • Clean • High Performance      "
    echo -e "${BC} ╚══════════════════════════════════════════════════════════╝${N}"

    echo ""

    for i in "${!themes[@]}"; do
        num=$((i+1))
        name="${themes[$i]}"
        clean="${name%.blueprint}"

        if is_installed "$name"; then
            status="${BG}●${N}"
        else
            status="${BR}○${N}"
        fi

        printf "  ${BG}%2d${N} %-25s %b\n" "$num" "$clean" "$status"
    done

    echo ""
    echo -e "  ${BR}0${N} Exit"
}

# =========================================================
# MAIN LOOP
# =========================================================
while true; do

    show_menu

    read -rp " 👉 Enter choice: " opt

    [[ ! "$opt" =~ ^[0-9]+$ ]] && {
        echo -e "${R}Invalid input${N}"
        sleep 1
        continue
    }

    [[ "$opt" == "0" ]] && {
        echo -e "${M}Bye!${N}"
        exit 0
    }

    index=$((opt-1))
    theme="${themes[$index]:-}"

    [[ -z "$theme" ]] && {
        echo -e "${R}Invalid option${N}"
        sleep 1
        continue
    }

    echo ""
    echo -e "Selected: ${BW}${theme%.blueprint}${N}"
    echo ""
    echo -e "  [1] Install"
    echo -e "  [2] Remove"
    echo -e "  [0] Back"
    echo ""

    read -rp " 👉 Action: " action

    case "$action" in
        1) install_theme "$theme" ;;
        2) remove_theme "$theme" ;;
        0) continue ;;
        *) echo -e "${R}Invalid action${N}" ;;
    esac

    echo ""
    read -rp "Press Enter..."
done

#!/usr/bin/env bash
# =========================================================
# FILE: thames.sh
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
# EXIT TRAP
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
# CHECK DEPENDENCIES
# =========================================================
check_dependencies() {

    local missing=()

    command -v curl >/dev/null 2>&1 || missing+=("curl")
    command -v blueprint >/dev/null 2>&1 || missing+=("blueprint")

    if (( ${#missing[@]} > 0 )); then
        echo -e "${R}Missing:${N} ${missing[*]}"
        exit 1
    fi
}

# =========================================================
# INSTALL CHECK
# =========================================================
is_installed() {

    local slug="${1%.blueprint}"

    [[ -d "$EXT_DIR/$slug" ]]
}

# =========================================================
# HEADER
# =========================================================
header() {

    clear

    echo -e "${BC} ╔══════════════════════════════════════════════════════════╗${N}"
    printf " ${BC}║${BW}%-58s${BC}║${N}\n" "$(get_title)"
    printf " ${BC}║${B}%-58s${BC}║${N}\n" "      Minimal • Clean • High Performance      "
    echo -e "${BC} ╚══════════════════════════════════════════════════════════╝${N}"

    echo -e " ${B}User:${N} $(whoami)"
    echo -e " ${B}Host:${N} $(hostname)"
    echo -e " ${B}Time:${N} $(date +"%H:%M:%S")"

    echo -e "${C} ──────────────────────────────────────────────────────────${N}"
}

# =========================================================
# SPINNER
# =========================================================
spinner() {

    local pid=$!
    local delay=0.08
    local spin='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'

    while ps -p $pid >/dev/null 2>&1; do
        for i in $(seq 0 9); do
            printf "\r ${C}%s${N} Processing..." "${spin:$i:1}"
            sleep $delay
        done
    done

    printf "\r"
}

# =========================================================
# INSTALL THEME
# =========================================================
install_theme() {

    local theme="$1"

    cd "$BASE_DIR" || {
        echo -e "${R}Pterodactyl not found!${N}"
        return
    }

    echo -e "\n${G}Installing:${N} ${BW}${theme%.blueprint}${N}"

    (
        curl -fsSL "$URL/$theme" -o "$theme" &&
        yes | blueprint -i "$theme" >/dev/null 2>&1 &&
        rm -f "$theme"
    ) &

    spinner

    if is_installed "$theme"; then
        echo -e "${BG}✔ Install Success${N}"
    else
        echo -e "${BR}✘ Install Failed${N}"
    fi
}

# =========================================================
# REMOVE THEME
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

    spinner

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

    header

    echo -e "${BW} SELECT A THEME UI:${N}\n"

    local count=0

    for i in "${!themes[@]}"; do

        num=$((i + 1))
        theme="${themes[$i]}"
        clean="${theme%.blueprint}"

        if is_installed "$theme"; then
            status="${BG}●${N}"
        else
            status="${BR}○${N}"
        fi

        printf "  ${BG}%2d${N} %-24s %b   " \
            "$num" "$clean" "$status"

        ((count++))

        if (( count % 2 == 0 )); then
            echo ""
        fi
    done

    echo ""
    echo ""
    echo -e "  ${BR} 0 ${N} Exit"

    echo -e "${C} ──────────────────────────────────────────────────────────${N}"
}

# =========================================================
# MAIN
# =========================================================
main() {

    check_dependencies

    while true; do

        show_menu

        read -rp " 👉 Enter choice: " opt

        [[ ! "$opt" =~ ^[0-9]+$ ]] && {
            echo -e "\n${R}Invalid input${N}"
            sleep 1
            continue
        }

        if [[ "$opt" == "0" ]]; then
            echo -e "\n${M}👋 Goodbye from lie_kg.dev${N}"
            exit 0
        fi

        index=$((opt - 1))

        theme="${themes[$index]:-}"

        if [[ -z "${theme:-}" ]]; then
            echo -e "\n${R}Invalid option${N}"
            sleep 1
            continue
        fi

        clean="${theme%.blueprint}"

        header

        if is_installed "$theme"; then
            status="${BG}INSTALLED${N}"
        else
            status="${BR}NOT INSTALLED${N}"
        fi

        echo -e " ${BW}Selected:${N} $clean"
        echo -e " ${BW}Status:${N}   $status"

        echo -e "${C} ──────────────────────────────────────────────────────────${N}"

        echo -e "  ${BG}[ 1 ]${N} Install"
        echo -e "  ${BR}[ 2 ]${N} Remove"
        echo -e "  ${BY}[ 0 ]${N} Back"

        echo -e "${C} ──────────────────────────────────────────────────────────${N}"

        read -rp " 👉 Action: " action

        case "$action" in
            1)
                install_theme "$theme"
                ;;
            2)
                remove_theme "$theme"
                ;;
            0)
                continue
                ;;
            *)
                echo -e "${R}Invalid action${N}"
                ;;
        esac

        echo ""
        read -rp " ↩️ Press Enter to continue..."
    done
}

main

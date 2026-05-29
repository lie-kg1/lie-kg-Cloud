#!/usr/bin/env bash

# ==========================================
# 🔐 BASIC PROTECTION
# ==========================================
[[ $EUID -ne 0 ]] && echo "Run as root!" && exit 1

# ==========================================
# 🎨 COLORS
# ==========================================
R="\e[31m"; G="\e[32m"; Y="\e[33m"
B="\e[34m"; M="\e[35m"; C="\e[36m"
W="\e[97m"; N="\e[0m"

BR="\e[1;31m"; BG="\e[1;32m"; BY="\e[1;33m"
BM="\e[1;35m"; BC="\e[1;36m"; BW="\e[1;97m"

# ==========================================
# ⚙️ CONFIG
# ==========================================
URL="https://github.com/lie-kg1/lie-kg-Cloud/raw/refs/heads/main/thame/Extension"

BASE_DIR="/var/www/pterodactyl"
EXT_DIR="$BASE_DIR/storage/extensions"

selected_indices=()

# ==========================================
# 🧩 DEPENDENCY CHECK
# ==========================================
command -v blueprint >/dev/null 2>&1 || {
    echo -e "${R}Blueprint not installed!${N}"
    exit 1
}

command -v curl >/dev/null 2>&1 || {
    echo -e "${R}Curl not installed!${N}"
    exit 1
}

# ==========================================
# 🚨 TRAP
# ==========================================
trap 'echo -e "\n${R}[!] Force exit detected.${N}"; exit 1' SIGINT

# ==========================================
# 🧠 BLUEPRINT LIST
# ==========================================
names=(
"adminauditlogs.blueprint"
"huxregister.blueprint"
"loader.blueprint"
"lyrdyannounce.blueprint"
"mclogs.blueprint"
"mcplugins.blueprint"
"mctools.blueprint"
"minecraftplayermanager.blueprint"
"playerlisting.blueprint"
"resourcealerts.blueprint"
"resourcemanager.blueprint"
"serverbackgrounds.blueprint"
"serversplitter.blueprint"
"simplefavicons.blueprint"
"snowflakes.blueprint"
"sociallogin.blueprint"
"startupchanger.blueprint"
"subdomains.blueprint"
"tawkto.blueprint"
"versionchanger.blueprint"
"pteromonaco.blueprint"
"urldownloader.blueprint"
"consolelogs.blueprint"
"laravellogs.blueprint"
"vanillatweaks.blueprint"
"modrinthbrowser.blueprint"
"nopagination.blueprint"
"activitypurges.blueprint"
"redirect.blueprint"
"simplefooters.blueprint"
"paneladdressoverride.blueprint"
"shownodeids.blueprint"
"votifiertester.blueprint"
"sidebar.blueprint"
"translations.blueprint"
"monacoeditor.blueprint"
"minecraftpluginmanager.blueprint"
"subdomainmanager.blueprint"
"serverimporter.blueprint"
"pstatistics.blueprint"
"pullfiles.blueprint"
"serverpropsmanager.blueprint"
"motdmaker.blueprint"
"servericonimporter.blueprint"
"sagaautosuspension.blueprint"
"sagaminecraftmodpackinstaller.blueprint"
"blueannoucements.blueprint"
"trashbin.blueprint"
"eggchanger.blueprint"
"mysqlautobackup.blueprint"
"configeditor.blueprint"
"customserversort.blueprint"
"databaseimportexport.blueprint"
"minecraftmodmanager.blueprint"
"serverid.blueprint"
"stats.blueprint"
"vminfo.blueprint"
"customcss.blueprint"
"autobackups.blueprint"
"node.blueprint"
"mcp.blueprint"
"mcplayer.blueprint"
)

# ==========================================
# 🏷️ TITLE
# ==========================================
get_title() {
    echo "        • — lie_kg.dev CONTROL HUB — •        "
}

# ==========================================
# 🔍 HELPERS
# ==========================================
is_installed() {
    [[ -d "$EXT_DIR/${1%.blueprint}" ]]
}

is_selected() {
    local index=$1
    [[ " ${selected_indices[*]} " =~ " $index " ]]
}

# ==========================================
# ⏳ SPINNER
# ==========================================
spinner() {

    local pid=$!
    local delay=0.08
    local spin='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'

    while ps -p $pid >/dev/null 2>&1; do
        for i in $(seq 0 9); do
            printf "\r ${BC}%s${N} Processing..." "${spin:$i:1}"
            sleep $delay
        done
    done

    printf "\r"
}

# ==========================================
# ⚙️ RUN BLUEPRINT
# ==========================================
run_blueprint() {

    local NAME="$1"
    local ACTION="$2"

    cd "$BASE_DIR" || {
        echo -e "${R}Pterodactyl not found!${N}"
        return
    }

    if [[ "$ACTION" == "install" ]]; then

        echo -e "${G}📥 Installing ${NAME%.blueprint}...${N}"

        (
            curl -fsSL "$URL/$NAME" -o "$NAME" &&
            yes | blueprint -i "$NAME" >/dev/null 2>&1 &&
            rm -f "$NAME"
        ) &

        spinner

        if is_installed "$NAME"; then
            echo -e "${BG}✔ Installed${N}"
        else
            echo -e "${BR}✘ Failed${N}"
        fi

    else

        echo -e "${R}🗑️ Removing ${NAME%.blueprint}...${N}"

        (
            yes | blueprint -r "${NAME%.blueprint}" >/dev/null 2>&1
        ) &

        spinner

        if ! is_installed "$NAME"; then
            echo -e "${BG}✔ Removed${N}"
        else
            echo -e "${BR}✘ Failed${N}"
        fi
    fi
}

# ==========================================
# 📋 MENU
# ==========================================
show_menu() {

    clear

    echo -e "${BC} ╔══════════════════════════════════════════════════════════╗${N}"
    printf " ${BC}║${BW}%-58s${BC}║${N}\n" "$(get_title)"
    echo -e "${BC} ╚══════════════════════════════════════════════════════════╝${N}"

    echo ""

    local count=0

    for i in "${!names[@]}"; do

        num=$((i+1))
        clean_name="${names[$i]%.blueprint}"

        is_installed "${names[$i]}" \
            && status="${BG}●${N}" \
            || status="${BR}○${N}"

        is_selected "$i" \
            && select_mark="${BY}[+]${N}" \
            || select_mark="   "

        display_name="${clean_name:0:22}"

        printf " %b ${BG}%2d${N} %-22s %b  " \
            "$select_mark" \
            "$num" \
            "$display_name" \
            "$status"

        ((count++))

        [[ $((count % 2)) -eq 0 ]] && echo ""
    done

    [[ $((count % 2)) -ne 0 ]] && echo ""

    echo ""
    echo -e "${C} ──────────────────────────────────────────────────────────${N}"

    echo -e " ${BW}SELECTED:${N} ${BY}${#selected_indices[@]}${N} items"

    echo -e " ${BG}[i]${N} Install   ${BR}[r]${N} Remove"
    echo -e " ${BM}[a]${N} Select All   ${BC}[c]${N} Clear"
    echo -e " ${R}[0]${N} Exit"

    echo -e "${C} ──────────────────────────────────────────────────────────${N}"
}

# ==========================================
# 🔁 MAIN LOOP
# ==========================================
while true; do

    show_menu

    read -rp " 👉 Select ID(s) or Action: " choice

    case $choice in

        0)
            echo -e "\n${M}👋 Goodbye from lie_kg.dev${N}"
            exit 0
            ;;

        c|C)
            selected_indices=()
            ;;

        a|A)

            selected_indices=()

            for i in "${!names[@]}"; do
                selected_indices+=("$i")
            done
            ;;

        i|I|r|R)

            if [[ ${#selected_indices[@]} -eq 0 ]]; then
                echo -e "${R}Nothing selected!${N}"
                sleep 1
                continue
            fi

            action_type="install"

            [[ "$choice" =~ [rR] ]] && action_type="remove"

            for idx in "${selected_indices[@]}"; do
                run_blueprint "${names[$idx]}" "$action_type"
            done

            selected_indices=()

            echo ""
            read -rp "Done. Press Enter to continue..."
            ;;

        *)

            for val in $choice; do

                if [[ "$val" =~ ^[0-9]+$ ]] &&
                   (( val >= 1 && val <= ${#names[@]} )); then

                    idx=$((val-1))

                    if is_selected "$idx"; then

                        for i in "${!selected_indices[@]}"; do
                            [[ ${selected_indices[i]} -eq $idx ]] &&
                            unset 'selected_indices[i]'
                        done

                        selected_indices=("${selected_indices[@]}")

                    else
                        selected_indices+=("$idx")
                    fi

                else
                    echo -e "${R}Invalid option: $val${N}"
                    sleep 0.5
                fi
            done
            ;;
    esac
done

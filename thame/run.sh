#!/usr/bin/env bash

# =========================================================
# lie_kg.dev CONTROL PANEL UI
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
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
CYAN="\e[36m"
MAGENTA="\e[35m"
WHITE="\e[97m"
RESET="\e[0m"

# =========================================================
# TRAP
# =========================================================
trap 'echo -e "\n${RED}[!] Force exit detected.${RESET}"; exit 1' SIGINT

# =========================================================
# DRAW UI
# =========================================================
draw_box() {

    echo -e "${CYAN}╔══════════════════════════════╗${RESET}"
    echo -e "${CYAN}║${MAGENTA}      CONTROL PANEL UI      ${CYAN}║${RESET}"
    echo -e "${CYAN}╚══════════════════════════════╝${RESET}"
}

# =========================================================
# PAUSE
# =========================================================
pause() {

    echo ""
    read -rp "   Press Enter to continue..." dummy
}

# =========================================================
# CHECK BLUEPRINT
# =========================================================
check_blueprint() {

    if command -v blueprint >/dev/null 2>&1 &&
       blueprint -version >/dev/null 2>&1; then

        status="${GREEN}● ONLINE${RESET}"
        installed=true

    else

        status="${RED}● OFFLINE${RESET}"
        installed=false
    fi
}

# =========================================================
# MAIN LOOP
# =========================================================
while true; do

    clear

    check_blueprint

    draw_box

    echo ""
    echo -e "   Blueprint Status : $status"
    echo ""

    echo -e "   ${YELLOW}[1]${RESET} Blueprint"
    echo -e "   ${YELLOW}[2]${RESET} Theme"
    echo -e "   ${YELLOW}[3]${RESET} Extensions"
    echo -e "   ${YELLOW}[4]${RESET} Hyper V1 🚀"

    echo ""
    echo -e "   ${RED}[0] Exit${RESET}"
    echo ""

    read -rp "   ➤ Select Option : " main

    case "$main" in

        # =================================================
        # BLUEPRINT MENU
        # =================================================
        1)

            while true; do

                clear

                check_blueprint

                draw_box

                echo ""
                echo -e "   ${CYAN}BLUEPRINT PANEL${RESET}"
                echo -e "   Status : $status"
                echo ""

                if [ "$installed" = false ]; then

                    echo -e "   ${GREEN}[1] Install${RESET}"
                    echo -e "   ${RED}[0] Back${RESET}"

                else

                    echo -e "   ${GREEN}[1] Reinstall${RESET}"
                    echo -e "   ${GREEN}[2] Update${RESET}"
                    echo -e "   ${GREEN}[3] Info${RESET}"
                    echo -e "   ${GREEN}[4] Version${RESET}"
                    echo -e "   ${RED}[5] Uninstall${RESET}"
                    echo -e "   ${RED}[0] Back${RESET}"
                fi

                echo ""

                read -rp "   ➤ Select : " bp

                case "$bp" in

                    # =====================================
                    # INSTALL / REINSTALL
                    # =====================================
                    1)

                        if [ "$installed" = false ]; then

                            echo -e "${CYAN}Installing Blueprint...${RESET}"

                            rm -f /etc/apt/keyrings/nodesource.gpg 2>/dev/null

                            bash <(
                                curl -fsSL \
                                https://raw.githubusercontent.com/lie-kg1/lie-kg-Cloud/refs/heads/main/thame/install.sh
                            )

                        else

                            yes | blueprint -rerun-install
                        fi

                        pause
                        ;;

                    # =====================================
                    # UPDATE
                    # =====================================
                    2)

                        yes | blueprint -upgrade

                        pause
                        ;;

                    # =====================================
                    # INFO
                    # =====================================
                    3)

                        blueprint -info || true

                        pause
                        ;;

                    # =====================================
                    # VERSION
                    # =====================================
                    4)

                        blueprint -version || true

                        pause
                        ;;

                    # =====================================
                    # UNINSTALL
                    # =====================================
                    5)

                        echo -e "${RED}Uninstalling Blueprint...${RESET}"

                        path=$(which blueprint 2>/dev/null || true)

                        if [ -n "${path:-}" ]; then

                            rm -f "$path" 2>/dev/null

                            rm -rf \
                                ~/.blueprint \
                                ~/.config/blueprint \
                                /var/www/pterodactyl/.blueprint \
                                /etc/blueprint \
                                /usr/local/bin/blueprint \
                                2>/dev/null

                            hash -r

                            echo -e "${GREEN}Removed successfully ✔${RESET}"

                        else

                            echo -e "${RED}Blueprint not installed ❌${RESET}"
                        fi

                        pause
                        ;;

                    # =====================================
                    # BACK
                    # =====================================
                    0)

                        break
                        ;;

                    # =====================================
                    # INVALID
                    # =====================================
                    *)

                        echo -e "${RED}Invalid option${RESET}"

                        sleep 1
                        ;;
                esac
            done
            ;;

        # =================================================
        # THEME
        # =================================================
        2)

            clear

            draw_box

            echo ""
            echo -e "${CYAN}Launching Theme...${RESET}"
            echo ""

            bash <(
                curl -fsSL \
                https://raw.githubusercontent.com/lie-kg1/lie-kg-Cloud/refs/heads/main/thame/thames.sh
            )

            pause
            ;;

        # =================================================
        # EXTENSIONS
        # =================================================
        3)

            clear

            draw_box

            echo ""
            echo -e "${CYAN}Launching Extensions...${RESET}"
            echo ""

            bash <(
                curl -fsSL \
                https://raw.githubusercontent.com/lie-kg1/lie-kg-Cloud/refs/heads/main/thame/Extension2.sh
            )

            pause
            ;;

        # =================================================
        # HYPER V1
        # =================================================
        4)

            clear

            draw_box

            echo ""
            echo -e "${MAGENTA}Launching Hyper V1...${RESET}"
            echo ""

            curl -fsSL \
                https://r2.rolexdev.tech/hyperv1/installer.sh \
                -o installer.sh

            chmod +x installer.sh

            bash ./installer.sh

            rm -f installer.sh

            cd /var/www/pterodactyl 2>/dev/null || true

            php artisan view:clear || true
            php artisan config:clear || true
            php artisan queue:restart || true

            pause
            ;;

        # =================================================
        # EXIT
        # =================================================
        0)

            clear

            echo -e "${RED}Exiting...${RESET}"

            exit 0
            ;;

        # =================================================
        # INVALID
        # =================================================
        *)

            echo -e "${RED}Invalid option${RESET}"

            sleep 1
            ;;
    esac
done

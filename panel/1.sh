case $p in
    1)
        echo -e "  ${CYAN}➜ Pterodactyl Routine...${NC}"
        bash <(curl -fsSL https://raw.githubusercontent.com/lie-kg1/lie-kg-Cloud/refs/heads/main/panel/pterodactyl/run.sh)
        pause
        ;;

    2)
        echo -e "  ${CYAN}➜ Jexactyl Routine...${NC}"
        echo -e "  ${RED}Not configured yet${NC}"
        pause
        ;;

    3)
        echo -e "  ${CYAN}➜ JexPanel Routine...${NC}"
        echo -e "  ${RED}Not configured yet${NC}"
        pause
        ;;

    4)
        echo -e "  ${CYAN}➜ Reviactyl Routine...${NC}"
        bash <(curl -fsSL https://raw.githubusercontent.com/lie-kg1/lie-kg-Cloud/refs/heads/main/panel/reviactyl/run.sh)
        pause
        ;;

    5)
        echo -e "  ${CYAN}➜ CtrlPanel Routine...${NC}"
        echo -e "  ${RED}Not configured yet${NC}"
        pause
        ;;

    6)
        echo -e "  ${CYAN}➜ Paymenter Routine...${NC}"
        bash <(curl -fsSL https://raw.githubusercontent.com/lie-kg1/lie-kg-Cloud/refs/heads/main/panel/paymenter/run.sh)
        pause
        ;;

    7)
        echo -e "  ${CYAN}➜ Convoy Routine...${NC}"
        bash <(curl -fsSL https://raw.githubusercontent.com/lie-kg1/hub/refs/heads/main/liekgCloud/panel/convoy/run.sh)
        pause
        ;;

    8)
        echo -e "  ${CYAN}➜ FeatherPanel Routine...${NC}"
        echo -e "  ${RED}Not configured yet${NC}"
        pause
        ;;

    9)
        echo -e "  ${CYAN}➜ Mythicaldash Routine...${NC}"
        bash <(curl -fsSL https://raw.githubusercontent.com/lie-kg1/lie-kg-Cloud/refs/heads/main/panel/mythical/run.sh)
        pause
        ;;

    10|11)
        echo -e "  ${RED}Not configured yet${NC}"
        pause
        ;;

    0)
        echo -e "\n  ${RED}Shutting down...${NC}"
        exit 0
        ;;

    *)
        echo -e "  ${RED}Invalid Selection${NC}"
        sleep 1
        ;;
esac

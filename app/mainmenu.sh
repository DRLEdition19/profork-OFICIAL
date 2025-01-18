#!/bin/bash
# Colors for animation
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to display animated text
animate_text() {
    local text="$1"
    for (( i=0; i<${#text}; i++ )); do
        echo -n "${text:$i:1}"
        sleep 0.05
    done
    echo
}

clear

# Display Warning Message
animate_text "${YELLOW}⚠️  Important Notice ⚠️${NC}"
sleep 1
animate_text "\n${YELLOW}The apps on this repository are provided AS-IS.${NC}"
sleep 1
animate_text "${YELLOW}No support is offered for using this repo.${NC}"
sleep 1

animate_text "\n${RED}DO NOT ask for help in the Batocera Discord.${NC}"
sleep 1
animate_text "${RED}They will NOT help you and will REFUSE support if they are made aware unofficial apps are installed.${NC}"
sleep 2

animate_text "\n${YELLOW}Use at your own risk.${NC}"

sleep 3

# Define the options
OPTIONS=("1" "Arch Container (Steam, Heroic, Lutris & More apps)"
         "2" "Standalone Apps (mostly appimages)"
         "3" "Docker & Containers"
         "4" "Tools"
         "5" "Wine Custom Downloader v40+"
         "6" "Windows/Wine Freeware games"
         "7" "Install Portmaster"
         "8" "DTJW92/Nightfox Batocera Unoffical Addons Repo"
         "9" "Install This Menu to Ports"              
         "10" "Exit")
         
# Display the dialog and get the user choice
CHOICE=$(dialog --clear --backtitle "Profork Main Menu" \
                --title "Main Menu" \
                --menu "Choose an option:" 15 75 3 \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear

# Act based on the user choice
case $CHOICE in
    1)
        echo "Arch Container..."
        curl -Ls https://github.com/trashbus99/profork/raw/master/steam/steam.sh | bash
        ;;
    2)
        echo "Apps Menu"
        rm /tmp/runner 2>/dev/null
        wget -q --tries=30 --no-check-certificate --no-cache --no-cookies -O /tmp/runner https://github.com/trashbus99/profork/raw/master/app/appmenu.sh
        dos2unix /tmp/runner 2>/dev/null 
        chmod 777 /tmp/runner 2>/dev/null
        bash /tmp/runner
        ;;
    3)
        echo "Docker Menu..."
        rm /tmp/runner 2>/dev/null
        wget -q --tries=30 --no-check-certificate --no-cache --no-cookies -O /tmp/runner https://github.com/trashbus99/profork/raw/master/app/dockermenu.sh
        dos2unix /tmp/runner 2>/dev/null 
        chmod 777 /tmp/runner 2>/dev/null
        bash /tmp/runner
        ;;
    4)
        echo "Tools Menu..."
        rm /tmp/runner 2>/dev/null
        wget -q --tries=30 --no-check-certificate --no-cache --no-cookies -O /tmp/runner https://github.com/trashbus99/profork/raw/master/app/tools.sh
        chmod 777 /tmp/runner 2>/dev/null
        bash /tmp/runner
        ;;
    5)  echo "Wine Custom...."
        curl -Ls https://github.com/trashbus99/profork/raw/master/wine-custom/wine.sh | bash
        ;;              
    6)  echo "Windows/Wine Freeware..."
        curl -Ls https://github.com/trashbus99/profork/raw/master/app/wquashfs.sh | bash
        ;;              
    
    
    7)  echo "Portmaster Installer..."
        curl -Ls https://github.com/trashbus99/profork/raw/master/portmaster/install.sh | bash
        ;;
    8)  echo "DTJW92 Nightfox Repo..."
        curl -Ls https://github.com/trashbus99/raw/master/app/bua.sh | bash
        ;;
    9)  echo "Ports Installer..."
        rm /tmp/runner 2>/dev/null
        wget -q --tries=30 --no-check-certificate --no-cache --no-cookies -O /tmp/runner https://github.com/trashbus99/profork/raw/master/app/install.sh
        chmod 777 /tmp/runner 2>/dev/null
        bash /tmp/runner
        ;;
    10)
        echo "Exiting..."
           exit
        ;;
    *)
        echo "No valid option selected or cancelled. Exiting."
        ;;
esac

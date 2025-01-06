#!/bin/bash


# Define the options
OPTIONS=("1" "Arch Container (Steam, Heroic, Lutris & More apps)"
         "2" "Standalone Apps (mostly appimages)"
         "3" "Docker & Containers"
         "4" "Tools"
         "5" "Windows/Wine Freeware games"
         "6" "Install Portmaster"
         "7" 'DTJW92/Nightfox Batocera Unoffical Addons Repo"
         "8" "Install This Menu to Ports"              
         "9" "Exit")
         
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
    5)  echo "Windows/Wine Freeware..."
        curl -Ls https://github.com/trashbus99/profork/raw/master/app/wquashfs.sh | bash
        ;;              
    6)  echo "Portmaster Installer..."
        curl -Ls https://github.com/trashbus99/profork/raw/master/portmaster/install.sh | bash
        ;;
    7)  echo "DTJW92 Nightfox Repo..."
        curl -Ls  https://github.com/DTJW92/batocera-unofficial-addons/raw/main/app/batocera-unofficial-addons.sh | bash
        ;;
    8)  echo "Ports Installer..."
        rm /tmp/runner 2>/dev/null
        wget -q --tries=30 --no-check-certificate --no-cache --no-cookies -O /tmp/runner https://github.com/trashbus99/profork/raw/master/app/install.sh
        chmod 777 /tmp/runner 2>/dev/null
        bash /tmp/runner
        ;;
    9)
        echo "Exiting..."
           exit
        ;;
    *)
        echo "No valid option selected or cancelled. Exiting."
        ;;
esac

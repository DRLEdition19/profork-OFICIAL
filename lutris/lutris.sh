#!/usr/bin/env bash
######################################################################
# Steam Installer Script
######################################################################

# Define Colors
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
MAGENTA='\033[1;35m'
CYAN='\033[1;36m'
WHITE='\033[1;37m'
RESET='\033[0m'

# Clear the screen
clear

# Banner
echo -e "${MAGENTA}##########################################################${RESET}"
echo -e "${CYAN}               PROFORK ${RED}LUTRIS INSTALLER${RESET}${CYAN}               ${RESET}"
echo -e "${MAGENTA}##########################################################${RESET}"
sleep 1

# Display Installation Information
echo -e "${YELLOW}"
echo -e "**********************************************************"
echo -e "* ${GREEN}This will install Lutris to F1 -> Applications.${YELLOW}        *"
echo -e "* ${GREEN}An additional launcher will also be added to Ports.${YELLOW}    *"
echo -e "* ${RED}Please wait...${YELLOW}                                         *"
echo -e "**********************************************************"
echo -e "${RESET}"

# Show progress with animation
for i in {1..3}; do
    echo -ne "${CYAN}Lutris Container made with Conty from Kron4ek"
    for j in {1..3}; do
        echo -ne "."
        sleep 0.5
    done
    echo -ne "${RESET}\r"
done

# End of Info Script
echo -e "${GREEN}Starting the installation process now...${RESET}"
sleep 1





######################################################################
# PROFORK INSTALLER
######################################################################
# --------------------------------------------------------------------
APPNAME=LUTRIS # for installer info
appname=lutris # directory name in /userdata/system/pro/...
AppName=lutris.sh # Shell script name
APPPATH=/userdata/system/pro/$appname
APPLINK=https://github.com/trashbus99/profork/releases/download/r1/lutris.sh
ORIGIN="PROFORK" # credit & info
# --------------------------------------------------------------------
# Output colors:
X='\033[0m' # reset color
GREEN='\033[1;32m'
# --------------------------------------------------------------------
# Prepare paths and files for installation 
pro=/userdata/system/pro
mkdir -p $pro/extra $pro/$appname/extra

# Clean up and prepare installer
killall wget 2>/dev/null && killall $AppName 2>/dev/null
rm -rf /userdata/system/pro/$appname/extra/downloads
mkdir /userdata/system/pro/$appname/extra/downloads

# Download and prepare the main application
temp=/userdata/system/pro/$appname/extra/downloads
echo
echo -e "${GREEN}DOWNLOADING $APPNAME . . .${X}"
sleep 1
cd $temp
curl --progress-bar --remote-name --location "$APPLINK"
mv $temp/* $APPPATH 2>/dev/null
chmod +x $APPPATH/lutris.sh
rm -rf $temp
echo -e "${GREEN}> DONE${X}"

# Install launcher script
launcher=/userdata/system/pro/$appname/Launcher
rm -rf $launcher
echo '#!/bin/bash ' >> $launcher
echo 'export DISPLAY=:0.0; unclutter-remote -s' >> $launcher
echo 'ulimit -H -n 819200 && ulimit -S -n 819200 && sysctl -w fs.inotify.max_user_watches=8192000 vm.max_map_count=2147483642 fs.file-max=8192000 >/dev/null 2>&1 && ALLOW_ROOT=1  DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u)/bus /userdata/system/pro/lutris/lutris.sh lutris' >> $launcher
chmod +x $launcher
cp $launcher /userdata/roms/ports/$appname.sh 2>/dev/null


# Install desktop shortcut
icon=/userdata/system/pro/$appname/extra/icon.png
mkdir -p /userdata/system/pro/$appname/extra
wget --tries=3 --timeout=10 --no-check-certificate -q -O $icon https://github.com/trashbus99/profork/raw/master/lutris/icon.png

shortcut=/userdata/system/pro/$appname/extra/$appname.desktop
rm -rf $shortcut
echo "[Desktop Entry]" >> $shortcut
echo "Version=1.0" >> $shortcut
echo "Icon=/userdata/system/pro/$appname/extra/icon.png" >> $shortcut
echo "Exec=/userdata/system/pro/$appname/Launcher %U" >> $shortcut
echo "Terminal=false" >> $shortcut
echo "Type=Application" >> $shortcut
echo "Categories=Game;batocera.linux;" >> $shortcut
echo "Name=$appname" >> $shortcut
cp $shortcut /usr/share/applications/$appname.desktop 2>/dev/null


# Prepare prelauncher to avoid overlay
pre=/userdata/system/pro/$appname/extra/startup
rm -rf $pre
echo "#!/usr/bin/env bash" >> $pre
echo "cp /userdata/system/pro/$appname/extra/$appname.desktop /usr/share/applications/ 2>/dev/null" >> $pre
chmod +x $pre

# Add prelauncher to custom.sh
customsh=/userdata/system/custom.sh
if ! grep -q "/userdata/system/pro/$appname/extra/startup" $customsh; then
    echo -e "\n/userdata/system/pro/$appname/extra/startup" >> $customsh
fi
chmod +x $customsh

echo -e "${GREEN}> $APPNAME INSTALLED OK${X}"
sleep 4
echo -e "ATTENTION NVIDIA USERS: Container downloads NVIDIA drivers matching Batocera's in background on first run and can take a while on first start up"
sleep 5
echo "DONE"

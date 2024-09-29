#!/usr/bin/env bash 
######################################################################
# PROFORK/SHADPS4 INSTALLER
######################################################################
APPNAME="SHADPS4"  # for installer info
appname="shadps4"  # directory name in /userdata/system/pro/...
AppName="Shadps4-qt"  # App.AppImage name
APPPATH="/userdata/system/pro/$appname/$AppName.AppImage"
APILINK="https://api.github.com/repos/shadps4-emu/shadPS4/releases/latest"
# Using jq to extract the correct download link
APPLINK=$(curl -s "$APILINK" | jq -r '.assets[] | select(.name | endswith("shadps4-linux-qt.zip")) | .browser_download_url')
VERSION=$(curl -Ls "$APILINK" | grep -m 1 '"tag_name"' | awk -F '"' '{print $4}')
ORIGIN="shadps4-emu/shadPS4"  # credit & info
ICON_URL="https://github.com/trashbus99/profork/raw/master/shadps4/extra/icon.png"

# Show version being downloaded
echo -e "${GREEN}Downloading $APPNAME version ${VERSION}. Please wait...${X}"
sleep 2

# Check if the APPLINK was properly set
if [[ -z "$APPLINK" ]]; then
  echo -e "${RED}Error: Could not determine download link for $APPNAME. Exiting.${X}"
  exit 1
fi

# Show console/ssh info
clear
echo
echo
echo
echo -e "${X}PREPARING $APPNAME INSTALLER, PLEASE WAIT . . . ${X}"
echo
echo
echo
echo

# Output colors
###########################
W='\033[0;37m'            # white
#-------------------------#
RED='\033[1;31m'          # red
BLUE='\033[1;34m'         # blue
GREEN='\033[1;32m'        # green
PURPLE='\033[1;35m'       # purple
DARKRED='\033[0;31m'      # darkred
DARKBLUE='\033[0;34m'     # darkblue
DARKGREEN='\033[0;32m'    # darkgreen
DARKPURPLE='\033[0;35m'   # darkpurple
###########################
X='\033[0m'  # / reset color
L=$X
R=$X

# Prepare paths and files for installation
cd ~/
pro="/userdata/system/pro"
mkdir -p "$pro/extra" "$pro/$appname/extra" 2>/dev/null

# Download and set the icon for the app
icon="/userdata/system/pro/$appname/extra/icon.png"
wget -q -O "$icon" "$ICON_URL"

# RUN BEFORE INSTALLER:
######################################################################
killall wget 2>/dev/null && killall $AppName 2>/dev/null && killall $AppName 2>/dev/null && killall $AppName 2>/dev/null
######################################################################

# Show console/ssh info
clear
echo
echo
echo
echo -e "${X}PROFORK/$APPNAME INSTALLER${X}"
echo
echo
echo
echo

sleep 0.33
clear
echo
echo
echo -e "${X}--------------------------------------------------------"
echo -e "${X}PROFORK/$APPNAME INSTALLER${X}"
echo -e "${X}--------------------------------------------------------"
echo
echo
echo
sleep 0.33
clear
echo
echo -e "${X}--------------------------------------------------------"
echo -e "${X}--------------------------------------------------------"
echo -e "${X}PROFORK/$APPNAME INSTALLER${X}"
echo -e "${X}--------------------------------------------------------"
echo -e "${X}--------------------------------------------------------"
echo
echo
sleep 0.33
clear
echo -e "${X}--------------------------------------------------------"
echo -e "${X}--------------------------------------------------------"
echo -e "${X}--------------------------------------------------------"
echo -e "${X}PROFORK/$APPNAME INSTALLER${X}"
echo -e "${X}--------------------------------------------------------"
echo -e "${X}--------------------------------------------------------"
echo -e "${X}--------------------------------------------------------"
echo

sleep 0.33
echo -e "${X}THIS WILL INSTALL $APPNAME FOR BATOCERA"
echo -e "${X}USING $ORIGIN"
echo
echo -e "${X}$APPNAME WILL BE AVAILABLE IN F1->APPLICATIONS "
echo -e "${X}AND INSTALLED IN /USERDATA/SYSTEM/PRO/$appname"
echo
echo -e "${X}. . .${X}" 
echo

# Create temporary directory for download
temp="/userdata/system/pro/$appname/extra/downloads"
rm -rf "$temp" 2>/dev/null
mkdir "$temp" 2>/dev/null

echo -e "${GREEN}DOWNLOADING${W} $APPNAME . . ."
sleep 1
echo -e "${T}$APPLINK" | sed 's,https://,> ,g' | sed 's,http://,> ,g' 2>/dev/null

# Download the AppImage
cd $temp
curl --progress-bar --remote-name --location "$APPLINK"
cd ~/
mv "$temp"/* "$APPPATH" 2>/dev/null
chmod a+x "$APPPATH" 2>/dev/null
rm -rf "$temp"/*.AppImage
SIZE=$(($(wc -c "$APPPATH" | awk '{print $1}')/1048576)) 2>/dev/null
echo -e "${T}$APPPATH ${T}$SIZE( )MB ${GREEN}OK${W}" | sed 's/( )//g'
echo -e "${GREEN}> ${W}DONE"

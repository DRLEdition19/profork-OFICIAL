#!/usr/bin/env bash 
######################################################################
# PROFORK/SHADPS4 INSTALLER
######################################################################
# --------------------------------------------------------------------
APPNAME="SHADPS4" # for installer info
appname="shadps4" # directory name in /userdata/system/pro/...
AppName="Shadps4-qt" # App.AppImage name
APPPATH="/userdata/system/pro/$appname/$AppName.AppImage"
APILINK="https://api.github.com/repos/shadps4-emu/shadPS4/releases/latest"
APPLINK=$(curl -Ls $APILINK | grep "browser_download_url.*shadps4-linux-qt.zip" | awk -F '"' '{print $4}')
VERSION=$(curl -Ls $APILINK | grep -m 1 '"tag_name"' | awk -F '"' '{print $4}')
ORIGIN="shadps4-emu/shadPS4" # credit & info
ICON_URL="https://github.com/trashbus99/profork/raw/master/shadps4/extra/icon.png"
# --------------------------------------------------------------------
# show console/ssh info: 
clear
echo
echo
echo
echo -e "${X}PREPARING $APPNAME INSTALLER, PLEASE WAIT . . . ${X}"
echo
echo
echo
echo
# --------------------------------------------------------------------
# -- output colors:
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
# console theme
X='\033[0m' # / resetcolor
L=$X
R=$X
# --------------------------------------------------------------------
# prepare paths and files for installation 
# paths:
cd ~/
pro="/userdata/system/pro"
mkdir -p "$pro/extra" "$pro/$appname/extra" 2>/dev/null
# --------------------------------------------------------------------
# -- prepare dependencies for this app and the installer: 
mkdir -p ~/pro/.dep 2>/dev/null && cd ~/pro/.dep && wget --tries=10 --no-check-certificate --no-cache --no-cookies -q -O ~/pro/.dep/dep.zip https://github.com/trashbus99/profork/raw/master/.dep/dep.zip && yes "y" | unzip -oq ~/pro/.dep/dep.zip && cd ~/
chmod 777 ~/pro/.dep/* && for file in /userdata/system/pro/.dep/lib*; do sudo ln -s "$file" "/usr/lib/$(basename $file)"; done
# --------------------------------------------------------------------
# -- download and set the icon for the app
icon="/userdata/system/pro/$appname/extra/icon.png"
wget -q -O "$icon" "$ICON_URL"
# --------------------------------------------------------------------
# // end of dependencies 
#
# RUN BEFORE INSTALLER: 
######################################################################
killall wget 2>/dev/null && killall $AppName 2>/dev/null && killall $AppName 2>/dev/null && killall $AppName 2>/dev/null
######################################################################
#
# --------------------------------------------------------------------
# show console/ssh info: 
clear
echo
echo
echo
echo -e "${X}PROFORK/$APPNAME INSTALLER${X}"
echo
echo
echo
echo
# --------------------------------------------------------------------
sleep 0.33
# --------------------------------------------------------------------
clear
echo
echo
echo -e "${X}--------------------------------------------------------"
echo -e "${X}PROFORK/$APPNAME INSTALLER${X}"
echo -e "${X}--------------------------------------------------------"
echo
echo
echo
# --------------------------------------------------------------------
sleep 0.33
# --------------------------------------------------------------------
clear
echo
echo -e "${X}--------------------------------------------------------"
echo -e "${X}--------------------------------------------------------"
echo -e "${X}PROFORK/$APPNAME INSTALLER${X}"
echo -e "${X}--------------------------------------------------------"
echo -e "${X}--------------------------------------------------------"
echo
echo
# --------------------------------------------------------------------
sleep 0.33
# --------------------------------------------------------------------
clear
echo -e "${X}--------------------------------------------------------"
echo -e "${X}--------------------------------------------------------"
echo -e "${X}--------------------------------------------------------"
echo -e "${X}PROFORK/$APPNAME INSTALLER${X}"
echo -e "${X}--------------------------------------------------------"
echo -e "${X}--------------------------------------------------------"
echo -e "${X}--------------------------------------------------------"
echo
# --------------------------------------------------------------------
sleep 0.33
echo -e "${X}THIS WILL INSTALL $APPNAME FOR BATOCERA"
echo -e "${X}USING $ORIGIN"
echo
echo -e "${X}$APPNAME WILL BE AVAILABLE IN F1->APPLICATIONS "
echo -e "${X}AND INSTALLED IN /USERDATA/SYSTEM/PRO/$appname"
echo
echo -e "${X}. . .${X}" 
echo
# // end of console info. 
#
# --------------------------------------------------------------------
# -- temp directory for curl download
temp="/userdata/system/pro/$appname/extra/downloads"
rm -rf "$temp" 2>/dev/null
mkdir "$temp" 2>/dev/null
#
# --------------------------------------------------------------------
#
echo
echo -e "${GREEN}DOWNLOADING${W} $APPNAME . . ."
sleep 1
echo -e "${T}$APPLINK" | sed 's,https://,> ,g' | sed 's,http://,> ,g' 2>/dev/null
cd $temp
curl --progress-bar --remote-name --location "$APPLINK"
cd ~/
mv "$temp"/* "$APPPATH" 2>/dev/null
chmod a+x "$APPPATH" 2>/dev/null
rm -rf "$temp"/*.AppImage
SIZE=$(($(wc -c "$APPPATH" | awk '{print $1}')/1048576)) 2>/dev/null
echo -e "${T}$APPPATH ${T}$SIZE( )MB ${GREEN}OK${W}" | sed 's/( )//g'
echo -e "${GREEN}> ${W}DONE"
echo
echo -e "${X}--------------------------------------------------------"
sleep 1.333
#
# --------------------------------------------------------------------
#
echo
echo -e "${GREEN}INSTALLING ${W}. . ."
# -- prepare launcher 
launcher="/userdata/system/pro/$appname/$appname"
rm -rf $launcher
echo '#!/bin/bash ' >> $launcher
echo 'export DISPLAY=:0.0; unclutter-remote -s' >> $launcher
echo 'LD_LIBRARY_PATH="/userdata/system/pro/.dep:${LD_LIBRARY_PATH}" DISPLAY=:0.0 /userdata/system/pro/'$appname'/'$AppName'.AppImage "$@"' >> $launcher
dos2unix $launcher
chmod a+x $launcher
# //
# -- prepare f1 - applications - app shortcut, 
shortcut="/userdata/system/pro/$appname/extra/$appname.desktop"
rm -rf "$shortcut" 2>/dev/null
echo "[Desktop Entry]" >> "$shortcut"
echo "Version=1.0" >> "$shortcut"
echo "Icon=/userdata/system/pro/$appname/extra/icon.png" >> "$shortcut"
echo "Exec=/userdata/system/pro/$appname/$appname %U" >> "$shortcut"
echo "Terminal=false" >> "$shortcut"
echo "Type=Application" >> "$shortcut"
echo "Categories=Game;batocera.linux;" >> "$shortcut"
echo "Name=$appname" >> "$shortcut"
f1shortcut="/usr/share/applications/$appname.desktop"
cp "$shortcut" "$f1shortcut" 2>/dev/null
# //
# -- prepare prelauncher to avoid overlay,
pre="/userdata/system/pro/$appname/extra/startup"
rm -rf "$pre" 2>/dev/null
echo "#!/usr/bin/env bash" >> "$pre"
echo "cp /userdata/system/pro/$appname/extra/$appname.desktop /usr/share/applications/ 2>/dev/null" >> "$pre"
dos2unix "$pre"
chmod a+x "$pre"
# // 
# -- add prelauncher to custom.sh to run @ reboot
customsh="/userdata/system/custom.sh"
if [[ -e $customsh ]] && [[ "$(cat $customsh | grep "/userdata/system/pro/$appname/extra/startup")" = "" ]]; then
echo -e "\n/userdata/system/pro/$appname/extra/startup" >> $customsh
fi
if [[ -e $customsh ]] && [[ "$(cat $customsh | grep "/userdata/system/pro/$appname/extra/startup" | grep "#")" != "" ]]; then
echo -e "\n/userdata/system/pro/$appname/extra/startup" >> $customsh
fi
if [[ -e $customsh ]]; then :; else
echo -e "\n/userdata/system/pro/$appname/extra/startup" >> $customsh
fi
dos2unix $customsh 2>/dev/null
# //
#
# -- done. 
sleep 1
echo -e "${GREEN}> ${W}DONE"
echo
sleep 1
echo -e "${X}--------------------------------------------------------"
echo -e "${W}> $APPNAME INSTALLED ${GREEN}OK"
echo -e "${X}--------------------------------------------------------"
sleep 4
exit 0

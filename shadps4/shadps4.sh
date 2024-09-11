#!/usr/bin/env bash
######################################################################
# PROFORK/SHADPS4 INSTALLER
######################################################################
APPNAME="SHADPS4" # for installer info
appname=shadps4   # directory name in /userdata/system/pro/...
AppName=Shadps4-qt   # App.AppImage name
APPPATH=/userdata/system/pro/$appname/$AppName.AppImage
# Static link to the specific version of the ShadPS4 AppImage zip file
APPLINK=APPLINK=$(curl -Ls https://api.github.com/repos/shadps4-emu/shadPS4/releases/latest | grep "browser_download_url.*shadps4-linux-qt.zip" | awk -F '"' '{print $4}')
ORIGIN="shadps4-emu/shadPS4" # credit & info
# --------------------------------------------------------------------
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
X='\033[0m'               # 
W='\033[0m'               # 
#-------------------------#
RED='\033[0m'             # 
BLUE='\033[0m'            # 
GREEN='\033[0m'           # 
PURPLE='\033[0m'          # 
DARKRED='\033[0m'         # 
DARKBLUE='\033[0m'        # 
DARKGREEN='\033[0m'       # 
DARKPURPLE='\033[0m'      # 
###########################
# -- console theme
L=$X
R=$X
# --------------------------------------------------------------------
# -- prepare paths and files for installation: 
cd ~/
pro=/userdata/system/pro
mkdir $pro 2>/dev/null
mkdir $pro/extra 2>/dev/null
mkdir $pro/$appname 2>/dev/null
mkdir $pro/$appname/extra 2>/dev/null

# --------------------------------------------------------------------
# -- download and extract the ShadPS4 zip file
wget --tries=10 --no-check-certificate --no-cache --no-cookies -q -O /tmp/shadps4.zip "$APPLINK"
unzip -o /tmp/shadps4.zip -d $pro/$appname/

# Move and rename AppImage
mv $pro/$appname/Shadps4-qt.AppImage $APPPATH
chmod a+x $APPPATH
rm /tmp/shadps4.zip

# -- continue the rest of the installation as before
killall wget 2>/dev/null && killall $AppName 2>/dev/null && killall $AppName 2>/dev/null && killall $AppName 2>/dev/null

# Define the line function to create visual dividers
line() {
  printf '%*s\n' "$cols" '' | tr ' ' "$1"
}

cols=$($dep/tput cols)
rm -rf /userdata/system/pro/$appname/extra/cols
echo $cols >> /userdata/system/pro/$appname/extra/cols

# -- show console/ssh info: 
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
echo
echo -e "${X}PROFORK/$APPNAME INSTALLER${X}"
echo
echo
echo
echo
sleep 0.33
clear
echo
echo -e "${X}THIS WILL INSTALL $APPNAME FOR BATOCERA"
echo -e "${X}USING $ORIGIN"
echo
echo -e "${X}$APPNAME WILL BE AVAILABLE IN F1->APPLICATIONS "
echo -e "${X}AND INSTALLED IN /USERDATA/SYSTEM/PRO/$APPNAME"
echo
echo -e "${X}FOLLOW THE BATOCERA DISPLAY"
echo
echo -e "${X}. . .${X}" 

# -- prepare launcher
launcher=/userdata/system/pro/$appname/Launcher
rm -rf $launcher
echo '#!/bin/bash ' >> $launcher
echo 'unclutter-remote -s' >> $launcher
echo 'LD_LIBRARY_PATH="/userdata/system/pro/.dep:${LD_LIBRARY_PATH}" DISPLAY=:0.0 /userdata/system/pro/'$appname'/'$AppName'.AppImage' >> $launcher
dos2unix $launcher
chmod a+x $launcher

# -- prepare f1 - applications - app shortcut
shortcut=/userdata/system/pro/$appname/extra/$appname.desktop
rm -rf $shortcut 2>/dev/null
echo "[Desktop Entry]" >> $shortcut
echo "Version=1.0" >> $shortcut
echo "Icon=/userdata/system/pro/$appname/extra/icon.png" >> $shortcut
echo "Exec=/userdata/system/pro/$appname/Launcher" >> $shortcut
echo "Terminal=false" >> $shortcut
echo "Type=Application" >> $shortcut
echo "Categories=Game;batocera.linux;" >> $shortcut
echo "Name=$appname" >> $shortcut
f1shortcut=/usr/share/applications/$appname.desktop
dos2unix $shortcut
chmod a+x $shortcut
cp $shortcut $f1shortcut 2>/dev/null

# -- prepare prelauncher
pre=/userdata/system/pro/$appname/extra/startup
rm -rf $pre 2>/dev/null
echo "#!/usr/bin/env bash" >> $pre
echo "cp /userdata/system/pro/$appname/extra/$appname.desktop /usr/share/applications/ 2>/dev/null" >> $pre
dos2unix $pre
chmod a+x $pre

# -- add prelauncher to custom.sh to run @ reboot
csh=/userdata/system/custom.sh
if [[ -e $csh ]] && [[ "$(cat $csh | grep "/userdata/system/pro/$appname/extra/startup")" = "" ]]; then
echo -e "\n/userdata/system/pro/$appname/extra/startup" >> $csh
fi
if [[ -e $csh ]] && [[ "$(cat $csh | grep "/userdata/system/pro/$appname/extra/startup" | grep "#")" != "" ]]; then
echo -e "\n/userdata/system/pro/$appname/extra/startup" >> $csh
fi
if [[ -e $csh ]]; then :; else
echo -e "\n/userdata/system/pro/$appname/extra/startup" >> $csh
fi
dos2unix $csh

# -- done
sleep 1
echo -e "${G}> ${W}DONE${W}"
echo
sleep 1
line '='
echo -e "${W}> $APPNAME INSTALLED ${G}OK${W}"
line '='
echo "1" >> /userdata/system/pro/$appname/extra/status 2>/dev/null
sleep 3
exit 0


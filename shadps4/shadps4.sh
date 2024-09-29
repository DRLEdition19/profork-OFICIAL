#!/usr/bin/env bash
######################################################################
# PROFORK/SHADPS4 INSTALLER
######################################################################
APPNAME="SHADPS4"  # for installer info
appname="shadps4"  # directory name in /userdata/system/pro/...
AppName="Shadps4-qt"  # App.AppImage name
APPPATH="/userdata/system/pro/$appname/$AppName.AppImage"

# Static link to the specific version of the ShadPS4 AppImage zip file
APILINK="https://api.github.com/repos/shadps4-emu/shadPS4/releases/latest"
APPLINK=$(curl -Ls "$APILINK" | grep "browser_download_url.*shadps4-linux-qt.zip" | awk -F '"' '{print $4}')
VERSION=$(curl -Ls "$APILINK" | grep -m 1 '"tag_name"' | awk -F '"' '{print $4}')
ORIGIN="shadps4-emu/shadPS4"  # credit & info

# Show console/ssh info
clear
echo ""
echo "PREPARING $APPNAME INSTALLER, PLEASE WAIT . . ."
echo ""

# Output colors (update as needed)
X='\033[0m'
GREEN='\033[0;32m'

# Prepare paths and files for installation
cd ~/
pro=/userdata/system/pro
mkdir -p "$pro" 2>/dev/null
mkdir -p "$pro/extra" 2>/dev/null
mkdir -p "$pro/$appname" 2>/dev/null
mkdir -p "$pro/$appname/extra" 2>/dev/null

# Announce the version and pause
echo -e "${GREEN}Downloading $APPNAME version ${VERSION}. Please wait...${X}"
sleep 7

# Download and extract the ShadPS4 zip file
wget --tries=10 --no-check-certificate --no-cache --no-cookies -q -O /tmp/shadps4.zip "$APPLINK"
unzip -o /tmp/shadps4.zip -d "$pro/$appname/"

# Move and rename AppImage
mv "$pro/$appname/Shadps4-qt.AppImage" "$APPPATH"
chmod a+x "$APPPATH"
rm /tmp/shadps4.zip

# Clean up any running processes
killall wget 2>/dev/null
killall "$AppName" 2>/dev/null

# Define the line function to create visual dividers
line() {
  printf '%*s\n' "$cols" '' | tr ' ' "$1"
}

cols=$(/userdata/system/pro/.dep/tput cols)
rm -rf "/userdata/system/pro/$appname/extra/cols"
echo "$cols" >> "/userdata/system/pro/$appname/extra/cols"

# Prepare the launcher
launcher="/userdata/system/pro/$appname/Launcher"
rm -rf "$launcher"
echo '#!/bin/bash' >> "$launcher"
echo 'unclutter-remote -s' >> "$launcher"
echo "LD_LIBRARY_PATH=\"/userdata/system/pro/.dep:\${LD_LIBRARY_PATH}\" DISPLAY=:0.0 /userdata/system/pro/$appname/$AppName.AppImage" >> "$launcher"
dos2unix "$launcher"
chmod a+x "$launcher"

# Prepare F1 applications shortcut
shortcut="/userdata/system/pro/$appname/extra/$appname.desktop"
rm -rf "$shortcut" 2>/dev/null
echo "[Desktop Entry]" >> "$shortcut"
echo "Version=1.0" >> "$shortcut"
echo "Icon=/userdata/system/pro/$appname/extra/icon.png" >> "$shortcut"
echo "Exec=/userdata/system/pro/$appname/Launcher" >> "$shortcut"
echo "Terminal=false" >> "$shortcut"
echo "Type=Application" >> "$shortcut"
echo "Categories=Game;batocera.linux;" >> "$shortcut"
echo "Name=$appname" >> "$shortcut"
f1shortcut="/usr/share/applications/$appname.desktop"
dos2unix "$shortcut"
chmod a+x "$shortcut"
cp "$shortcut" "$f1shortcut" 2>/dev/null

# Prepare pre-launcher script
pre="/userdata/system/pro/$appname/extra/startup"
rm -rf "$pre" 2>/dev/null
echo "#!/usr/bin/env bash" >> "$pre"
echo "cp /userdata/system/pro/$appname/extra/$appname.desktop /usr/share/applications/ 2>/dev/null" >> "$pre"
dos2unix "$pre"
chmod a+x "$pre"

# Add pre-launcher to custom.sh
csh="/userdata/system/custom.sh"
if [[ -e "$csh" && -z "$(grep "/userdata/system/pro/$appname/extra/startup" "$csh")" ]]; then
  echo -e "\n/userdata/system/pro/$appname/extra/startup" >> "$csh"
fi

dos2unix "$csh"

# Completion message
sleep 1
echo -e "${GREEN}> DONE${X}"
line '='
echo -e "${X}> $APPNAME INSTALLED OK${X}"
line '='
echo "1" >> "/userdata/system/pro/$appname/extra/status" 2>/dev/null
sleep 3
exit 0

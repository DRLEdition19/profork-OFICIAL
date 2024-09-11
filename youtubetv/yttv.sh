#!/usr/bin/env bash
# PROFORK INSTALLER WITH ANIMATIONS AND COLORS
######################################################################
######################################################################
#                            WELCOME TO:
#                    THE PROFORK INSTALLER EXPERIENCE              
######################################################################

# Define a function for animated character transitions
function animate_step {
  local message=$1
  local color=$2
  local reset='\033[0m'
  local chars=('-' '\\' '|' '/')

  echo -ne "${color}${message}${reset} "
  for i in {1..10}; do
    for c in "${chars[@]}"; do
      echo -ne "${color}${c}${reset}\r"
      sleep 0.1
    done
  done
  echo -ne "${color}${message}${reset}\n"
}

# Define a function to show progress with a bar animation
function progress_bar {
  local total_steps=$1
  local current_step=0
  local bar_length=40
  local color='\033[32m' # Green
  local reset='\033[0m'

  while [[ $current_step -le $total_steps ]]; do
    local num_hashes=$((current_step * bar_length / total_steps))
    local bar=$(printf "%-${bar_length}s" "#" | cut -c1-$num_hashes)
    local spaces=$(printf "%-${bar_length}s" " ")
    
    echo -ne "${color}[${bar}${spaces}] (${current_step}/${total_steps})${reset}\r"
    sleep 0.1
    ((current_step++))
  done
  echo
}

# Output welcome message
clear
animate_step "PREPARING INSTALLATION... PLEASE WAIT" '\033[36m'
sleep 1
clear

# Define app information
APPNAME=youtubetv
APPLINK=https://github.com/trashbus99/profork/releases/download/r1/YouTubeonTV-linux-x64.zip
APPHOME=github.com/uureel/PROFORK

# Animate and confirm application info
animate_step "DOWNLOADING $APPNAME PACKAGE..." '\033[33m'
sleep 1
clear

# Simulate downloading with an animated progress bar
progress_bar 50

# Creating necessary directories with animations
animate_step "SETTING UP INSTALLATION PATHS..." '\033[35m'
mkdir -p /userdata/system/pro/$APPNAME/home 2>/dev/null
mkdir -p /userdata/system/pro/$APPNAME/config 2>/dev/null
mkdir -p /userdata/system/pro/$APPNAME/roms 2>/dev/null
clear

# Display fancy progress with animated colors and characters
animate_step "CONFIGURING LAUNCH COMMANDS..." '\033[34m'
COMMAND='sed -i "s,!appArgs.disableOldBuildWarning,1 == 0,g" /userdata/system/pro/youtubetv/resources/app/lib/main.js 2>/dev/null && mkdir /userdata/system/pro/'$APPNAME'/home 2>/dev/null; mkdir /userdata/system/pro/'$APPNAME'/config 2>/dev/null; mkdir /userdata/system/pro/'$APPNAME'/roms 2>/dev/null; LD_LIBRARY_PATH="/userdata/system/pro/.dep:${LD_LIBRARY_PATH}" HOME=/userdata/system/pro/'$APPNAME'/home XDG_CONFIG_HOME=/userdata/system/pro/'$APPNAME'/config QT_SCALE_FACTOR="1" GDK_SCALE="1" XDG_DATA_HOME=/userdata/system/pro/'$APPNAME'/home DISPLAY=:0.0 /userdata/system/pro/'$APPNAME'/YouTubeonTV --no-sandbox --test-type "${@}"'

sleep 1
clear

# Simulate downloading dependencies with animations
animate_step "DOWNLOADING DEPENDENCIES..." '\033[32m'
mkdir -p ~/pro/.dep 2>/dev/null
cd ~/pro/.dep && wget --tries=10 --no-check-certificate --no-cache --no-cookies -q -O ~/pro/.dep/dep.zip https://github.com/trashbus99/profork/raw/master/.dep/dep.zip && yes "y" | unzip -oq ~/pro/.dep/dep.zip
clear

# Fancy transition for unzipping and installation
animate_step "INSTALLING APPLICATION..." '\033[31m'
mkdir -p /userdata/system/pro/$APPNAME
cd /userdata/system/pro/$APPNAME
wget --tries=10 --no-check-certificate --no-cache --no-cookies -q -O $pro/$appname/extra/icon.png https://github.com/trashbus99/profork/raw/master/$appname/extra/icon.png

# Step-by-step animations for creating launcher
animate_step "SETTING UP LAUNCHER..." '\033[35m'
launcher=/userdata/system/pro/$appname/Launcher
echo "#!/bin/bash" >> $launcher
echo "$COMMAND" >> $launcher
chmod a+x $launcher
clear

# Setting up desktop shortcut with color transitions
animate_step "CREATING DESKTOP SHORTCUT..." '\033[34m'
shortcut=/userdata/system/pro/$appname/extra/$appname.desktop
rm -rf $shortcut 2>/dev/null
echo "[Desktop Entry]" >> $shortcut
echo "Version=1.0" >> $shortcut
echo "Icon=/userdata/system/pro/$appname/extra/icon.png" >> $shortcut
echo "Exec=/userdata/system/pro/$appname/Launcher" >> $shortcut
echo "Terminal=false" >> $shortcut
echo "Type=Application" >> $shortcut
echo "Categories=Game;batocera.linux;" >> $shortcut
clear

# Final animation for installation completion
animate_step "INSTALLATION COMPLETE!" '\033[32m'
echo -e "\033[32m$APPNAME has been successfully installed! You can now find it in Ports and Applications menu.\033[0m"
sleep 2
clear

# Realoading Emulationstation
animate_step "RELOADING EMULATIONSTATION..." '\033[33m'
killall -9 emulationstation
clear

# Final message
animate_step "ENJOY YOUR NEW $APPNAME INSTALLATION!" '\033[36m'
sleep 2
clear

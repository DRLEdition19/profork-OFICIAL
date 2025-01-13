#!/usr/bin/env bash

#!/bin/bash

# Get the machine hardware name
architecture=$(uname -m)

# Check if the architecture is x86_64 (AMD/Intel)
if [ "$architecture" != "x86_64" ]; then
    echo "This script only runs on AMD or Intel (x86_64) CPUs, not on $architecture."
    exit 1
fi



MESSAGE="This container is compatible with EXT4 or BTRFS partitions only!  FAT32/NTFS/exFAT are not supported.  Continue?"

# Use dialog to create a yes/no box
if dialog --title "Compatibility Warning" --yesno "$MESSAGE" 10 70; then
    # If the user chooses 'Yes', continue the installation
    echo "Continuing installation..."
    # Add your installation commands here
else
    # If the user chooses 'No', exit the script
    echo "Installation aborted by user."
    exit 1
fi


MESSAGE="WARNING: Batocera's Custom SDL/kernel mods break XINPUT over BLUETOOTH on apps in the Arch container. Xbox One/S/X controllers are verified working via wired USB or the Xbox wireless adapter only. 8bitDO controller users can switch their input mode to d-input or switch input.  Continue?"

# Use dialog to create a yes/no box
if dialog --title "Compatibility Warning" --yesno "$MESSAGE" 10 70; then
    # If the user chooses 'Yes', continue the installation
    echo "Continuing installation..."
    # Add your installation commands here
else
    # If the user chooses 'No', exit the script
    echo "Installation aborted by user."
    exit 1
fi

# Clear the screen after the dialog is closed
clear

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
echo -e "${CYAN}               PROFORK ${RED}STEAM INSTALLER${RESET}${CYAN}               ${RESET}"
echo -e "${MAGENTA}##########################################################${RESET}"
sleep 1

# Display Installation Information
echo -e "${YELLOW}"
echo -e "**********************************************************"
echo -e "* ${GREEN}This will install Steam to F1 -> Applications.${YELLOW}         *"
echo -e "* ${GREEN}An additional launcher will also be added to Ports.${YELLOW}    *"
echo -e "* ${RED}Please wait...${YELLOW}                                         *"
echo -e "**********************************************************"
echo -e "${RESET}"

# Show progress with animation
for i in {1..3}; do
    echo -ne "${CYAN}Steam Container made with Conty from Kron4ek & Batocera adaptions by UUREEL"
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
APPNAME=STEAM # for installer info
appname=steam # directory name in /userdata/system/pro/...
AppName=steam.sh # Shell script name
APPPATH=/userdata/system/pro/$appname
APPLINK=https://github.com/trashbus99/profork/releases/download/r1/steam.sh
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
chmod +x $APPPATH/steam.sh
rm -rf $temp
echo -e "${GREEN}> DONE${X}"

# Install launcher script

# Install launcher script
launcher=/userdata/system/pro/$appname/Launcher
rm -rf $launcher
echo '#!/bin/bash' >> $launcher
echo '#------------------------------------------------' >> $launcher
echo 'conty=/userdata/system/pro/steam/steam.sh' >> $launcher
echo '#------------------------------------------------' >> $launcher
echo 'batocera-mouse show' >> $launcher
echo 'killall -9 steam steamfix steamfixer 2>/dev/null' >> $launcher
echo '#------------------------------------------------' >> $launcher
echo '"$conty" \\' >> $launcher
echo '    --bind /userdata/system/containers/storage /var/lib/containers/storage \\' >> $launcher
echo '    --bind /userdata/system/flatpak /var/lib/flatpak \\' >> $launcher
echo '    --bind /userdata/system/etc/passwd /etc/passwd \\' >> $launcher
echo '    --bind /var/run/nvidia /run/nvidia \\' >> $launcher
echo '    --bind /userdata/system/etc/group /etc/group \\' >> $launcher
echo '    --bind /userdata/system /home/batocera \\' >> $launcher
echo '    --bind /sys/fs/cgroup /sys/fs/cgroup \\' >> $launcher
echo '    --bind /userdata/system /home/root \\' >> $launcher
echo '    --bind /etc/fonts /etc/fonts \\' >> $launcher
echo '    --bind /userdata /userdata \\' >> $launcher
echo '    --bind /newroot /newroot \\' >> $launcher
echo '    --bind / /batocera \\' >> $launcher
echo '    bash -c '\''prepare && source /opt/env && \\' >> $launcher
echo '    ulimit -H -n 819200 && ulimit -S -n 819200 && \\' >> $launcher
echo '    sysctl -w fs.inotify.max_user_watches=8192000 vm.max_map_count=2147483642 fs.file-max=8192000 >/dev/null 2>&1 && \\' >> $launcher
echo '    dbus-run-session steam "${@}"'\'' ' >> $launcher
echo '#------------------------------------------------' >> $launcher
# Optional: hide mouse after launching
# echo 'batocera-mouse hide' >> $launcher
chmod +x $launcher
cp $launcher /userdata/roms/ports/$appname.sh 2>/dev/null


# Install desktop shortcut
icon=/userdata/system/pro/$appname/extra/icon.png
mkdir -p /userdata/system/pro/$appname/extra
wget --tries=3 --timeout=10 --no-check-certificate -q -O $icon https://github.com/trashbus99/profork/raw/master/steam/extra/icon.png

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

echo "DONE! -- Update Gamelists to see addition in ports"
sleep 5
echo "Exiting.."
sleep 2


#!/usr/bin/env bash

RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
MAGENTA='\033[1;35m'
CYAN='\033[1;36m'
WHITE='\033[1;37m'
RESET='\033[0m'

# -----------------------------------------------------------------------------
# Preliminary Checks & Dialogs
# -----------------------------------------------------------------------------
architecture=$(uname -m)
if [ "$architecture" != "x86_64" ]; then
    echo -e "${RED}This installer only runs on x86_64 systems (AMD/Intel). Detected: $architecture.${RESET}"
    exit 1
fi

if dialog --title "Compatibility Warning" --yesno "Warning: ShadPS4 only works on v40+ and higher.\n\nContinue installation?" 10 60; then
    echo -e "${GREEN}Continuing installation...${RESET}"
else
    clear
    echo -e "${RED}Installation aborted by user.${RESET}"
    exit 1
fi

clear

# -----------------------------------------------------------------------------
# Animated Message
# -----------------------------------------------------------------------------
MESSAGE="This Application, ShadPS4 will be installed to F1 -> Applications and a new menu will be installed in EmulationStation for PS4."
echo -e "${CYAN}${MESSAGE}${RESET}"
for i in {1..3}; do
    echo -ne "${YELLOW}Installing"
    for j in {1..3}; do
        echo -ne "."
        sleep 0.5
    done
    echo -ne "\r"
    echo -ne "${YELLOW}Installing            \r"
done
echo -e "\n${GREEN}Please wait while the installation proceeds...${RESET}"
sleep 1

# -----------------------------------------------------------------------------
# Define Variables & Paths
# -----------------------------------------------------------------------------
INSTALL_DIR="/userdata/system/pro/shadps4"

# GitHub API URL to fetch the latest ShadPS4 release from the original ShadPS4 repo
GITHUB_API_URL="https://api.github.com/repos/shadps4-emu/shadPS4/releases/latest"
ZIP_REGEX="shadps4-linux-qt-.*\.zip"

# Directories for additional resources
ROMS_DIR="/userdata/roms/ps4"
IMAGE_DIR="$INSTALL_DIR/images"

# Directory for the restore–shortcut (named "startup") — placed in extra following the MAME2010 pattern.
RESTORE_DIR="$INSTALL_DIR/extra"
STARTUP_SCRIPT="$RESTORE_DIR/startup"

# Required system startup scripts
PRO_CUSTOM_SH="/userdata/system/pro-custom.sh"
CUSTOM_SH="/userdata/system/custom.sh"

# Ensure required directories exist
mkdir -p "$INSTALL_DIR" "$IMAGE_DIR" "$ROMS_DIR" "$RESTORE_DIR"

# -----------------------------------------------------------------------------
# Fetch Latest ShadPS4 Release & Install
# -----------------------------------------------------------------------------
echo -e "${CYAN}Fetching latest ShadPS4 release...${RESET}"
latest_release_url=$(curl -s "$GITHUB_API_URL" | grep "browser_download_url" | grep -E "$ZIP_REGEX" | cut -d '"' -f 4)
if [ -z "$latest_release_url" ]; then
    echo -e "${RED}Failed to retrieve the latest release URL. Exiting.${RESET}"
    exit 1
fi

echo -e "${CYAN}Downloading ShadPS4 zip from:${RESET} ${YELLOW}$latest_release_url${RESET}"
curl -# -L -o "$INSTALL_DIR/shadps4.zip" "$latest_release_url"
if [ $? -ne 0 ]; then
    echo -e "${RED}Download failed. Exiting.${RESET}"
    exit 1
fi

echo -e "${CYAN}Unzipping ShadPS4...${RESET}"
unzip -o -q "$INSTALL_DIR/shadps4.zip" -d "$INSTALL_DIR"
if [ $? -ne 0 ]; then
    echo -e "${RED}Unzip failed. Exiting.${RESET}"
    exit 1
fi

rm -f "$INSTALL_DIR/shadps4.zip"
chmod a+x "$INSTALL_DIR/Shadps4-qt.AppImage"
echo -e "${GREEN}ShadPS4 installed and AppImage marked executable.${RESET}"

# -----------------------------------------------------------------------------
# Create Desktop Entry & Launcher Script
# -----------------------------------------------------------------------------
DESKTOP_ENTRY="$INSTALL_DIR/shadps4.desktop"
LAUNCHER_SCRIPT="$INSTALL_DIR/launch_shadps4.sh"
ICON_DIR="$INSTALL_DIR/extra"
mkdir -p "$ICON_DIR"

# Download icon
ICON_URL="https://raw.githubusercontent.com/trashbus99/profork/master/shadps4/extra/shadps4.png"
ICON_PATH="$ICON_DIR/shadps4.png"
echo -e "${CYAN}Downloading icon...${RESET}"
curl -# -L -o "$ICON_PATH" "$ICON_URL"

# Create launcher script
cat << EOF > "$LAUNCHER_SCRIPT"
#!/bin/bash
cd /userdata/system/pro/shadps4
DISPLAY=:0.0 ./Shadps4-qt.AppImage "\$@"
EOF
chmod +x "$LAUNCHER_SCRIPT"

# Create desktop entry
cat << EOF > "$DESKTOP_ENTRY"
[Desktop Entry]
Version=1.0
Type=Application
Name=ShadPS4
Exec=$LAUNCHER_SCRIPT
Icon=$ICON_PATH
Terminal=false
Categories=Game;batocera.linux;
EOF
chmod +x "$DESKTOP_ENTRY"
ln -sf "$DESKTOP_ENTRY" /usr/share/applications/shadps4.desktop

echo -e "${GREEN}Desktop entry and launcher created successfully.${RESET}"

# -----------------------------------------------------------------------------
# Generate Restore–Shortcut Script (startup) in /userdata/system/pro/shadps4/extra
# -----------------------------------------------------------------------------
echo -e "${CYAN}Creating startup script to persist the desktop entry...${RESET}"
cat << EOF > "$STARTUP_SCRIPT"
#!/bin/bash
ln -sf "$DESKTOP_ENTRY" /usr/share/applications/shadps4.desktop
EOF
chmod +x "$STARTUP_SCRIPT"

# Ensure pro-custom.sh calls startup
if [ ! -f "$PRO_CUSTOM_SH" ]; then
    echo "#!/bin/bash" > "$PRO_CUSTOM_SH"
fi
if ! grep -q "$STARTUP_SCRIPT" "$PRO_CUSTOM_SH"; then
    echo "bash $STARTUP_SCRIPT &" >> "$PRO_CUSTOM_SH"
    chmod +x "$PRO_CUSTOM_SH"
fi

# Ensure custom.sh calls pro-custom.sh
if [ ! -f "$CUSTOM_SH" ]; then
    echo "#!/bin/bash" > "$CUSTOM_SH"
    echo "bash $PRO_CUSTOM_SH &" >> "$CUSTOM_SH"
    chmod +x "$CUSTOM_SH"
elif ! grep -q "$PRO_CUSTOM_SH" "$CUSTOM_SH"; then
    echo "bash $PRO_CUSTOM_SH &" >> "$CUSTOM_SH"
    chmod +x "$CUSTOM_SH"
fi

# -----------------------------------------------------------------------------
# Inform the User about Shortcut Creation
# -----------------------------------------------------------------------------
dialog --title "Manual Shortcut Update Required" --msgbox "IMPORTANT: For each game installed, you need to create a shortcut in the ShadPS4 GUI. Then update these shortcuts manually by running the update script in the PS4 menu (+UPDATE-PS4-SHORTCUTS.sh)." 12 60

# -----------------------------------------------------------------------------
# Final Steps & Cleanup
# -----------------------------------------------------------------------------
echo -e "${GREEN}Installation complete!${RESET}"
echo -e "${YELLOW}A desktop entry has been created and will persist across reboots.${RESET}"

sleep 2
clear
echo -e "${GREEN}ShadPS4 installation finished.${RESET}"
exit 0

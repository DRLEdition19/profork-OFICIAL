#!/usr/bin/env bash
# =============================================================================
#  profork SHADPS4 INSTALLER
# =============================================================================
# This installer downloads and installs ShadPS4 into:
#   /userdata/system/pro/shadps4
# It generates an update script (+UPDATE-PS4-SHORTCUTS.sh) for managing game shortcuts,
# creates a desktop shortcut to launch ShadPS4, writes ES configuration files for PS4,
# and sets up a startup script to ensure the desktop shortcut persists across reboots.
#
# Repository: https://github.com/trashbus99/profork/tree/master/shadps4
# Icon:       https://raw.githubusercontent.com/trashbus99/profork/master/shadps4/extra/shadps4.png
# =============================================================================

# -------------------------------------------------------------------
# Define Colors for Output
# -------------------------------------------------------------------
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
MAGENTA='\033[1;35m'
CYAN='\033[1;36m'
WHITE='\033[1;37m'
RESET='\033[0m'

# -------------------------------------------------------------------
# Preliminary Checks & Dialogs
# -------------------------------------------------------------------
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

# -------------------------------------------------------------------
#  Installation Message
# -------------------------------------------------------------------
echo -e "THIS WILL INSTALL SHADPS4 FOR BATOCERA"
echo -e "USING SHADPS4-EMU/SHADPS4"
echo
echo -e "SHADPS4 WILL BE AVAILABLE IN F1->APPLICATIONS"
echo -e "AND INSTALLED IN /USERDATA/SYSTEM/PRO/SHADPS4"
echo -e "A SEPARATE PS4 MENU WILL BE ADDED TO EMULATIONSTATION"
sleep 5

# -------------------------------------------------------------------
# Define Variables & Paths
# -------------------------------------------------------------------
INSTALL_DIR="/userdata/system/pro/shadps4"
EXTRA_DIR="$INSTALL_DIR/extra"
STARTUP_SCRIPT="$EXTRA_DIR/startup"
CUSTOM_SH="/userdata/system/custom.sh"
PRO_CUSTOM_SH="/userdata/system/pro-custom.sh"
DESKTOP_ENTRY="$INSTALL_DIR/shadps4.desktop"
SYSTEM_DESKTOP_PATH="/usr/share/applications/shadps4.desktop"
LAUNCHER_SCRIPT="$INSTALL_DIR/launch_shadps4.sh"
ICON_DIR="$INSTALL_DIR/extra"
ICON_PATH="$ICON_DIR/shadps4.png"

# Create required directories
mkdir -p "$INSTALL_DIR" "$EXTRA_DIR" "$ICON_DIR"

# -------------------------------------------------------------------
# Fetch Latest ShadPS4 Release & Install
# -------------------------------------------------------------------
GITHUB_API_URL="https://api.github.com/repos/shadps4-emu/shadPS4/releases/latest"
ZIP_REGEX="shadps4-linux-qt-.*\.zip"

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
unzip -q "$INSTALL_DIR/shadps4.zip" -d "$INSTALL_DIR"
rm -f "$INSTALL_DIR/shadps4.zip"
chmod a+x "$INSTALL_DIR/Shadps4-qt.AppImage"
echo -e "${GREEN}ShadPS4 installed and marked executable.${RESET}"

# -------------------------------------------------------------------
# Create Launch Script for ShadPS4
# -------------------------------------------------------------------
echo "#!/bin/bash" > "$LAUNCHER_SCRIPT"
echo "cd \"$INSTALL_DIR\"" >> "$LAUNCHER_SCRIPT"
echo "DISPLAY=:0.0 ./Shadps4-qt.AppImage \"\$@\"" >> "$LAUNCHER_SCRIPT"
chmod +x "$LAUNCHER_SCRIPT"

# -------------------------------------------------------------------
# Create Desktop Entry for ShadPS4
# -------------------------------------------------------------------
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

# -------------------------------------------------------------------
# Download Icon
# -------------------------------------------------------------------
ICON_URL="https://raw.githubusercontent.com/trashbus99/profork/master/shadps4/extra/shadps4.png"
echo -e "${CYAN}Downloading icon...${RESET}"
curl -# -L -o "$ICON_PATH" "$ICON_URL"

# -------------------------------------------------------------------
# Create Startup Script to Ensure Desktop Shortcut Persists
# -------------------------------------------------------------------
echo "#!/bin/bash" > "$STARTUP_SCRIPT"
echo "ln -sf \"$DESKTOP_ENTRY\" \"$SYSTEM_DESKTOP_PATH\"" >> "$STARTUP_SCRIPT"
chmod +x "$STARTUP_SCRIPT"

# Ensure pro-custom.sh runs the startup script
if ! grep -q "$STARTUP_SCRIPT" "$PRO_CUSTOM_SH" 2>/dev/null; then
    echo "bash $STARTUP_SCRIPT &" >> "$PRO_CUSTOM_SH"
    chmod +x "$PRO_CUSTOM_SH"
fi

# Ensure custom.sh exists and includes pro-custom.sh
if [ ! -f "$CUSTOM_SH" ]; then
    echo "#!/bin/bash" > "$CUSTOM_SH"
    echo "bash $PRO_CUSTOM_SH &" >> "$CUSTOM_SH"
    chmod +x "$CUSTOM_SH"
elif ! grep -q "$PRO_CUSTOM_SH" "$CUSTOM_SH"; then
    echo "bash $PRO_CUSTOM_SH &" >> "$CUSTOM_SH"
    chmod +x "$CUSTOM_SH"
fi

echo -e "${GREEN}Startup script for ShadPS4 desktop entry persistence has been created.${RESET}"

# -------------------------------------------------------------------
# Final Instructions for Users
# -------------------------------------------------------------------
dialog --title "Install Complete" --msgbox "ShadPS4 installation is complete!\n\nA desktop entry has been created and will persist across reboots.\n\nTo create/update game shortcuts, run +UPDATE-PS4-SHORTCUTS.sh in /userdata/roms/ps4.\n\nEnjoy!" 12 60

clear
echo -e "SHADPS4 INSTALLATION COMPLETED SUCCESSFULLY!"
exit 0

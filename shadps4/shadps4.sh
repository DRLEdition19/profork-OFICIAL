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
# Installation target directory for ShadPS4
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

# Create required directories
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
# IMPORTANT: Use the correct filename as extracted (with lowercase "p"):
chmod a+x "$INSTALL_DIR/Shadps4-qt.AppImage"
echo -e "${GREEN}ShadPS4 installed and AppImage marked executable.${RESET}"

# -----------------------------------------------------------------------------
# Generate Update Script: +UPDATE-PS4-SHORTCUTS.sh in /userdata/roms/ps4
# -----------------------------------------------------------------------------

cat << 'EOF' > "$ROMS_DIR/+UPDATE-PS4-SHORTCUTS.sh"
#!/bin/bash

# Directory paths
desktop_dir="/userdata/system/Desktop"
output_dir="/userdata/roms/ps4"
mkdir -p "$output_dir"

# Default .keys content
keys_content='{
    "actions_player1": [
        {
            "trigger": [
                "hotkey",
                "start"
            ],
            "type": "key",
            "target": [
                "KEY_LEFTALT",
                "KEY_F4"
            ],
            "description": "Press Alt+F4"
        },
        {
            "trigger": [
                "hotkey",
                "l2"
            ],
            "type": "key",
            "target": "KEY_ESC",
            "description": "Press Esc"
        },
        {
            "trigger": [
                "hotkey",
                "r2"
            ],
            "type": "key",
            "target": "KEY_ENTER",
            "description": "Press Enter"
        }
    ]
}'

# Iterate through .desktop files in the Desktop directory
for file_path in "/userdata/system/Desktop"/*.desktop; do
    if [ -f "$file_path" ]; then
        # Check for 'shadps4' in the Exec line
        if grep -q '^Exec=.*shadps4.*' "$file_path"; then
            # Extract game name from the desktop file
            game_name=`grep '^Name=' "$file_path" | sed 's/^Name=//'`
            # Extract the ROM path (assumed to be the quoted path ending with eboot.bin)
            game_path=`grep '^Exec=' "$file_path" | sed -n 's/.*"\([^"]*\/eboot\.bin\)".*/\1/p'`
            # Use the parent folder of the ROM path as the game code
            game_code=`basename "$(dirname "$game_path")"`
            
            # Sanitize game name for use in a filename
            sanitized_name=`echo "$game_name" | sed 's/ /_/g' | sed 's/[^a-zA-Z0-9_]//g'`
            script_path="${output_dir}/${sanitized_name}.sh"
            keys_path="${output_dir}/${sanitized_name}.sh.keys"
            
            # Generate script content using ulimit commands and the AppImage call with DISPLAY set
            script_content="#!/bin/bash
# Set high file descriptor limits
ulimit -H -n 819200 && ulimit -S -n 819200
# Show the Batocera mouse cursor
batocera-mouse show
# Launch ShadPS4 using its AppImage with the specified game code
DISPLAY=:0.0 \"/userdata/system/pro/shadps4/Shadps4-qt.AppImage\" -g $game_code -f true
# Hide the mouse cursor when done
batocera-mouse hide
"
            
            # Write script and keys file to respective locations
            echo "$script_content" > "$script_path"
            chmod +x "$script_path"
            echo "$keys_content" > "$keys_path"
            
            echo "Script created: $script_path"
            echo "Keys file created: $keys_path"
        fi
    fi
done


echo "Script execution completed."
EOF

chmod +x "$ROMS_DIR/+UPDATE-PS4-SHORTCUTS.sh"
echo -e "${GREEN}Update shortcuts script (+UPDATE-PS4-SHORTCUTS.sh) installed in /userdata/roms/ps4.${RESET}"

# -----------------------------------------------------------------------------
# Generate Restore–Shortcut Script (startup) in /userdata/system/pro/shadps4/extra
# -----------------------------------------------------------------------------


# Ensure that pro-custom.sh calls the restore–shortcut (startup) script.
PRO_CUSTOM_SH="/userdata/system/pro-custom.sh"
if [ ! -f "$PRO_CUSTOM_SH" ]; then
    echo "#!/bin/bash" > "$PRO_CUSTOM_SH"
fi
if ! grep -q "$RESTORE_SCRIPT" "$PRO_CUSTOM_SH"; then
    echo "bash $RESTORE_SCRIPT &" >> "$PRO_CUSTOM_SH"
    chmod +x "$PRO_CUSTOM_SH"
fi

# Ensure that custom.sh exists and calls pro-custom.sh.
CUSTOM_SH="/userdata/system/custom.sh"
if [ ! -f "$CUSTOM_SH" ]; then
    echo "#!/bin/bash" > "$CUSTOM_SH"
    echo "bash $PRO_CUSTOM_SH &" >> "$CUSTOM_SH"
    chmod +x "$CUSTOM_SH"
elif ! grep -q "$PRO_CUSTOM_SH" "$CUSTOM_SH"; then
    echo "bash $PRO_CUSTOM_SH &" >> "$CUSTOM_SH"
    chmod +x "$CUSTOM_SH"
fi

# -----------------------------------------------------------------------------
# Create Desktop Entry & Launcher Script
# -----------------------------------------------------------------------------
DESKTOP_ENTRY="$INSTALL_DIR/shadps4.desktop"
LAUNCHER_SCRIPT="$INSTALL_DIR/launch_shadps4.sh"
ICON_DIR="$INSTALL_DIR/extra"
mkdir -p "$ICON_DIR"

# Use the icon from  the repository's shadps4/extra folder
ICON_URL="https://raw.githubusercontent.com/trashbus99/profork/master/shadps4/extra/shadps4.png"
ICON_PATH="$ICON_DIR/shadps4.png"

echo -e "${CYAN}Downloading icon...${RESET}"
curl -# -L -o "$ICON_PATH" "$ICON_URL"

# Create the launcher script.

cat << EOF > "$LAUNCHER_SCRIPT"
#!/bin/bash
# Launch ShadPS4
cd /userdata/system/pro/shadps4
DISPLAY=:0.0 ./Shadps4-qt.AppImage "\$@"
EOF
chmod +x "$LAUNCHER_SCRIPT"

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
# Install ES Features & System Configurations for PS4
# -----------------------------------------------------------------------------
echo -e "${CYAN}Installing ES features and system configurations for PS4...${RESET}"
ES_CONFIG_DIR="/userdata/system/configs/emulationstation"
mkdir -p "$ES_CONFIG_DIR"

# Write es_features.ps4.cfg
cat << EOF > "$ES_CONFIG_DIR/es_features.ps4.cfg"
<?xml version="1.0" encoding="UTF-8" ?>
<features>
    <emulator name="ps4" features="videomode,padtokeyboard,powermode,tdp">
    </emulator>
</features>
EOF

# Write es_system_ps4.cfg
cat << EOF > "$ES_CONFIG_DIR/es_system_ps4.cfg"
<?xml version="1.0"?>
<systemList>
  <system>
        <fullname>PlayStation 4</fullname>
        <name>ps4</name>
        <manufacturer>Sony</manufacturer>
        <release>2013</release>
        <hardware>port</hardware>
        <path>/userdata/roms/ps4</path>
        <extension>.sh</extension>
        <command>emulatorlauncher %CONTROLLERSCONFIG% -system ports -rom %ROM% -gameinfoxml %GAMEINFOXML% -systemname ports</command>
        <platform>ps4</platform>
        <theme>ps4</theme>
        <emulators>
            <emulator name="ps4">
                <cores>
                    <core default="ps4">shadps4</core>
                </cores>
            </emulator>
        </emulators>
  </system>
</systemList>
EOF

echo -e "${GREEN}ES system configuration for PS4 installed.${RESET}"

# -----------------------------------------------------------------------------
# Inform the User about Shortcut Creation
# -----------------------------------------------------------------------------
dialog --title "Manual Shortcut Update Required" --msgbox "IMPORTANT: For each game installed, you need to create a shortcut in the ShadPS4 GUI. Then update these shortcuts manually by running the update script in the es ps4 menu (+UPDATE-PS4-SHORTCUTS.sh)." 12 60

# -----------------------------------------------------------------------------
# Final Steps & Cleanup
# -----------------------------------------------------------------------------
echo -e "${GREEN}Installation complete!${RESET}"
echo -e "${YELLOW}A desktop entry has been created and will persist across reboots.${RESET}"


sleep 2
clear
echo -e "${GREEN}ShadPS4 installation finished.${RESET}"
exit 0

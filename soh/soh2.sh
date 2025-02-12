#!/bin/bash

# Step 1: Define Directories and URLs
SOH_DIR="/userdata/roms/ports/soh"
LAUNCH_SCRIPT="/userdata/roms/ports/launch_soh.sh"
KEYS_FILE="/userdata/roms/ports/launch_soh.sh.keys"
SOH_ZIP_URL="https://github.com/HarbourMasters/Shipwright/releases/download/8.0.6/SoH-MacReady-Golf-Linux-Performance.zip"
SOH_APPIMAGE="soh.appimage"
KEYS_URL="https://raw.githubusercontent.com/trashbus99/profork/refs/heads/master/soh/launch_soh.sh.keys"

# Ensure the directory exists
mkdir -p "$SOH_DIR"

# Step 2: Download and Extract Ship of Harkinian
if [ ! -f "$SOH_DIR/$SOH_APPIMAGE" ]; then
    echo "Downloading Ship of Harkinian..."
    wget -O /tmp/SoH.zip "$SOH_ZIP_URL"
    echo "Extracting Ship of Harkinian..."
    unzip /tmp/SoH.zip -d "$SOH_DIR"
    rm /tmp/SoH.zip
fi

# Ensure the AppImage is executable
chmod +x "$SOH_DIR/$SOH_APPIMAGE"

# Step 3: Create the Launch Script
cat << EOF > "$LAUNCH_SCRIPT"
#!/bin/bash
export DISPLAY=:0.0
cd "$SOH_DIR" || exit 1
chmod +x "$SOH_APPIMAGE"
exec ./"$SOH_APPIMAGE" >/dev/null 2>&1
EOF

# Make the launch script executable
chmod +x "$LAUNCH_SCRIPT"

# Step 4: Download the Key Bindings File
echo "Downloading launch_soh.sh.keys file..."
wget -O "$KEYS_FILE" "$KEYS_URL"

# Step 5: Display Instructions using dialog
dialog --msgbox "Setup complete! 🎮\n\n\
To run Ship of Harkinian:\n\
- Go to the PORTS section in Batocera.\n\
- Launch the game from there.\n\n\
Make sure to place your legally obtained ROM file in:\n\
$SOH_DIR\n\n\
The ROM should have the correct CRC/SHA1 hash as outlined in the README." 12 60
clear

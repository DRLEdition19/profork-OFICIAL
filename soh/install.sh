#!/bin/bash

# Step 1: Set up directories and download the Ship of Harkinian
SOH_DIR="/userdata/roms/ports/soh"
LAUNCH_SCRIPT="/userdata/roms/ports/launch_soh.sh"
SOH_ZIP_URL="https://github.com/HarbourMasters/Shipwright/releases/download/8.0.6/SoH-MacReady-Golf-Linux-Performance.zip"
SOH_APPIMAGE="soh.appimage"
KEYS_URL="https://raw.githubusercontent.com/trashbus99/profork/refs/heads/master/soh/launch_soh.sh.keys"

# Make the directory for the Ship of Harkinian if it doesn't already exist
mkdir -p "$SOH_DIR"

# Download and extract the Ship of Harkinian ZIP file if it doesn't already exist
if [ ! -f "$SOH_DIR/$SOH_APPIMAGE" ]; then
    echo "Downloading Ship of Harkinian..."
    wget -O /tmp/SoH.zip "$SOH_ZIP_URL"
    echo "Extracting Ship of Harkinian..."
    unzip /tmp/SoH.zip -d "$SOH_DIR"
    rm /tmp/SoH.zip
fi

# Ensure the appimage is executable
chmod +x "$SOH_DIR/$SOH_APPIMAGE"



sleep 5
# Step 3: Create the launch script with working directory set
cat << EOF > "$LAUNCH_SCRIPT"
#!/bin/bash
export DISPLAY=:0.0
cd "$SOH_DIR"
"./$SOH_APPIMAGE"
EOF

# Make the launch script executable
chmod +x "$LAUNCH_SCRIPT"

# Step 4: Download the keys file to the ports directory
echo "Downloading the launch_soh.sh.keys file..."
wget -O "/userdata/roms/ports/launch_soh.sh.keys" "$KEYS_URL"

clear
echo "Setup complete. You can now run Ship of Harkinian by executing the script in PORTS after refresh."
echo "Launch the game via Batocera or the command: $LAUNCH_SCRIPT"
echo "Please place your legally obtained ROM file in $SOH_DIR before proceeding."
echo "The ROM should have the correct CRC/SHA1 hash as outlined in the README."
sleep 20

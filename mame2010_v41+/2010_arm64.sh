#!/bin/bash

echo "This script will restore MAME 2010 (0.139) to Batocera v41 for ARM builds (and should work on newer builds too)"
echo "A separate MAME 0139 system will be added adjacent to MAME"

sleep 5

# Define URLs for required files
ES_CFG_URL="https://raw.githubusercontent.com/trashbus99/profork/master/mame2010_v41%2B/es_systems_mame0139.cfg"
INFO_FILE_URL="https://github.com/trashbus99/profork/releases/download/r1/mame0139_libretro.info"
CORE_DEST_URL="https://github.com/trashbus99/profork/releases/download/r1/mame0139_libretro.so.aarch64"

# Define paths
BASE_DIR="/userdata/system/pro/mame2010"
EXTRA_DIR="$BASE_DIR/extra"
STARTUP_SCRIPT="$EXTRA_DIR/startup"
CUSTOM_SH="/userdata/system/custom.sh"
PRO_CUSTOM_SH="/userdata/system/pro-custom.sh"
ES_CFG_PATH="/userdata/system/configs/emulationstation/es_systems_mame0139.cfg"
INFO_DEST="$BASE_DIR/mame0139_libretro.info"
CORE_DEST="$BASE_DIR/mame0139_libretro.so"

# Ensure required directories exist
mkdir -p "$EXTRA_DIR"
mkdir -p "/usr/share/libretro/info"
mkdir -p "/usr/lib/libretro"

# Download necessary files
echo "Downloading necessary files..."
wget -O "$ES_CFG_PATH" "$ES_CFG_URL" || { echo "Failed to download $ES_CFG_URL"; exit 1; }
wget -O "$INFO_DEST" "$INFO_FILE_URL" || { echo "Failed to download $INFO_FILE_URL"; exit 1; }
wget -O "$CORE_DEST" "$CORE_DEST_URL" || { echo "Failed to download $CORE_DEST_URL"; exit 1; }

# Set correct permissions
chmod 644 "$ES_CFG_PATH" "$INFO_DEST"
chmod 755 "$CORE_DEST"

# Write the startup script dynamically
cat <<EOF > "$STARTUP_SCRIPT"
#!/usr/bin/env bash
ln -sf $INFO_DEST /usr/share/libretro/info/mame0139_libretro.info
ln -sf $CORE_DEST /usr/lib/libretro/mame0139_libretro.so
EOF

# Ask user if they want to symlink ROMs
dialog --yesno "Do you want to link your existing /userdata/roms/mame folder to mame0139?\n\nYes: Link existing ROMs\nNo: Keep separate mame0139 folder" 12 60
if [ $? -eq 0 ]; then
    mkdir -p /userdata/roms/mame0139
    echo "ln -sf /userdata/roms/mame /userdata/roms/mame0139" >> "$STARTUP_SCRIPT"
else
    mkdir -p /userdata/roms/mame0139
fi

# Make the startup script executable
chmod +x "$STARTUP_SCRIPT"

# Ensure pro-custom.sh exists before appending
if [ ! -f "$PRO_CUSTOM_SH" ]; then
    echo "#!/bin/bash" > "$PRO_CUSTOM_SH"
    chmod +x "$PRO_CUSTOM_SH"
fi

# Ensure pro-custom.sh includes the startup script
if ! grep -q "$STARTUP_SCRIPT" "$PRO_CUSTOM_SH"; then
    echo "bash $STARTUP_SCRIPT &" >> "$PRO_CUSTOM_SH"
fi

# Ensure custom.sh exists before modifying
if [ ! -f "$CUSTOM_SH" ]; then
    echo "#!/bin/bash" > "$CUSTOM_SH"
    chmod +x "$CUSTOM_SH"
fi

# Ensure custom.sh includes pro-custom.sh
if ! grep -q "$PRO_CUSTOM_SH" "$CUSTOM_SH"; then
    echo "bash $PRO_CUSTOM_SH &" >> "$CUSTOM_SH"
fi

# Final confirmation message
dialog --title "Install Done" --msgbox "Setup complete! MAME 0.139 is installed, and the MAME 2010 startup script will run at next boot.\n\nPlease reboot Batocera for changes to take effect.\n\nAfter rebooting, update gamelists." 10 60

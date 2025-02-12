#!/bin/bash

# Step 1: Define Directories and URLs
STARSHIP_DIR="/userdata/roms/ports/starship"
LAUNCH_SCRIPT="/userdata/roms/ports/launch_starship.sh"
KEYS_FILE="/userdata/roms/ports/launch_starship.sh.keys"
STARSHIP_ZIP_URL="TBA"
STARSHIP_APPIMAGE="starship.appimage"  # Assuming an AppImage exists inside the ZIP
KEYS_URL="https://raw.githubusercontent.com/trashbus99/profork/refs/heads/master/starship/launch_starship.sh.keys"

# Ensure the directory exists
mkdir -p "$STARSHIP_DIR"

# Step 2: Download and Extract Starship
if [ ! -f "$STARSHIP_DIR/$STARSHIP_APPIMAGE" ]; then
    echo "Downloading Starship..."
    wget -O /tmp/starship.zip "$STARSHIP_ZIP_URL"
    echo "Extracting Starship..."
    unzip /tmp/starship.zip -d "$STARSHIP_DIR"
    rm /tmp/starship.zip
fi

# Ensure the AppImage is executable
chmod +x "$STARSHIP_DIR/$STARSHIP_APPIMAGE"

# Step 3: Create the Launch Script
cat << EOF > "$LAUNCH_SCRIPT"
#!/bin/bash
export DISPLAY=:0.0
cd "$STARSHIP_DIR" || exit 1
chmod +x "$STARSHIP_APPIMAGE"
exec ./"$STARSHIP_APPIMAGE" >/dev/null 2>&1
EOF

# Make the launch script executable
chmod +x "$LAUNCH_SCRIPT"

# Step 4: Download the Key Bindings File
echo "Downloading launch_starship.sh.keys file..."
wget -O "$KEYS_FILE" "$KEYS_URL"

# Step 5: Display Instructions using dialog
dialog --msgbox "Setup complete! 🚀\n\n\
To run Starship (Star Fox 64 PC port):\n\
- Go to the PORTS section in Batocera.\n\
- Launch the game from there.\n\n\
Make sure to place your legally obtained ROM file in:\n\
$STARSHIP_DIR\n\n\
The ROM should have the correct CRC/SHA1 hash as outlined in the README." 12 60
clear

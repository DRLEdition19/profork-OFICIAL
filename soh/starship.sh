#!/bin/bash

# Step 1: Define Directories and URLs
STARSHIP_DIR="/userdata/roms/ports/starship"
LAUNCH_SCRIPT="/userdata/roms/ports/launch_starship.sh"
KEYS_FILE="/userdata/roms/ports/launch_starship.sh.keys"
STARSHIP_ZIP_URL="https://github.com/HarbourMasters/Starship/releases/download/v1.0.0/Starship-Centauri-Alfa-Windows.zip"
STARSHIP_EXE="starship.exe"  # Windows executable
KEYS_URL="https://raw.githubusercontent.com/trashbus99/profork/refs/heads/master/starship/launch_starship.sh.keys"
WINE_INSTALL_SCRIPT="https://github.com/trashbus99/profork/raw/master/scripts/ge.sh"

# Ensure the directory exists
mkdir -p "$STARSHIP_DIR"

# Step 2: Download and Extract Starship
if [ ! -f "$STARSHIP_DIR/$STARSHIP_EXE" ]; then
    echo "Downloading Starship..."
    wget -O /tmp/starship.zip "$STARSHIP_ZIP_URL"
    echo "Extracting Starship..."
    unzip /tmp/starship.zip -d "$STARSHIP_DIR"
    rm /tmp/starship.zip
fi

# Step 3: Check for Wine, Prompt User if Not Installed
if ! command -v wine &> /dev/null; then
    dialog --title "Wine Not Found" --yesno "Starship requires Wine to run.\n\nDo you want to install Wine now?" 10 50
    response=$?
    
    if [ $response -eq 0 ]; then
        echo "Installing Wine..."
        curl -L "$WINE_INSTALL_SCRIPT" | bash
    else
        dialog --msgbox "Wine is required to run Starship. Exiting." 8 40
        exit 1
    fi
fi

# Step 4: Create the Launch Script
cat << EOF > "$LAUNCH_SCRIPT"
#!/bin/bash
export DISPLAY=:0.0
cd "$STARSHIP_DIR" || exit 1
exec wine "$STARSHIP_EXE" >/dev/null 2>&1
EOF

# Make the launch script executable
chmod +x "$LAUNCH_SCRIPT"

# Step 5: Download the Key Bindings File
echo "Downloading launch_starship.sh.keys file..."
wget -O "$KEYS_FILE" "$KEYS_URL"

# Step 6: Display Instructions using dialog
dialog --msgbox "Setup complete! 🚀\n\n\
To run Starship (Star Fox 64 PC port):\n\
- Go to the PORTS section in Batocera.\n\
- Launch the game from there.\n\n\
Make sure to place your legally obtained ROM file in:\n\
$STARSHIP_DIR\n\n\
The ROM should have the correct CRC/SHA1 hash as outlined in the README." 12 60
clear

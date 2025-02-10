#!/bin/bash

# Animated intro title
print_intro() {
    local intro_message="Downloading the latest nvtop version to ~/pro/nvtop and adding it to ports..."
    local delay=0.05
    echo -n "Starting: "
    for (( i=0; i<${#intro_message}; i++ )); do
        echo -n "${intro_message:$i:1}"
        sleep $delay
    done
    echo -e "\n"
}

# Call the intro function to display the message
print_intro

# Define directories and paths
NVTOP_DIR="/userdata/system/pro/nvtop"
SCRIPT_PATH="/userdata/roms/ports/nvtop.sh"
NVTOP_SYMLINK="/usr/bin/nvtop"
CUSTOM_SH="/userdata/system/custom.sh"

# GitHub user and repository
GITHUB_USER="Syllo"
GITHUB_REPO="nvtop"

# Create the directory if it doesn't exist
mkdir -p "$NVTOP_DIR"

# Fetch the latest release download URL for the AppImage
latest_release_url=$(curl -s https://api.github.com/repos/$GITHUB_USER/$GITHUB_REPO/releases/latest | jq -r '.assets[] | select(.name | endswith(".AppImage")) | .browser_download_url')

# Extract the file name
appimage_name=$(basename "$latest_release_url")

# Download the latest AppImage version
curl -# -L "$latest_release_url" -o "$NVTOP_DIR/$appimage_name"

# Make the AppImage executable
chmod +x "$NVTOP_DIR/$appimage_name"

# Create the shell script
cat > "$SCRIPT_PATH" <<EOF
#!/bin/bash
DISPLAY=:0.0 xterm -fs 30 -maximized -fg white -bg black -fa "DejaVuSansMono" -en UTF-8 -e bash -c "DISPLAY=:0.0 $NVTOP_DIR/$appimage_name"
EOF

# Make the shell script executable
chmod +x "$SCRIPT_PATH"

# Create symlink for immediate use
ln -sf "$NVTOP_DIR/$appimage_name" "$NVTOP_SYMLINK"

# Ensure custom.sh exists
if [ ! -f "$CUSTOM_SH" ]; then
    echo "#!/bin/bash" > "$CUSTOM_SH"
    chmod +x "$CUSTOM_SH"
fi

# Add NVTOP relink on boot (if not already present)
if ! grep -q "ln -sf $NVTOP_DIR/$appimage_name $NVTOP_SYMLINK" "$CUSTOM_SH"; then
    echo "ln -sf $NVTOP_DIR/$appimage_name $NVTOP_SYMLINK" >> "$CUSTOM_SH"
fi

echo "nvtop setup is complete.  Run nvtop in terminal or ports. A symlink has been created on boot in custom.sh"
echo "DONE"
sleep 5 

# Restart EmulationStation
killall -9 emulationstation

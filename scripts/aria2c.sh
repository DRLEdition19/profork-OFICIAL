#!/bin/bash

ARIA2C_DIR="/userdata/system/pro/aria2"
ARIA2C_BIN="$ARIA2C_DIR/aria2c"
ARIA2C_URL="https://github.com/trashbus99/profork/raw/master/.dep/aria2c"
ARIA2C_SYMLINK="/usr/bin/aria2c"
CUSTOM_SH="/userdata/system/custom.sh"

echo "Creating Aria2c directory..."
mkdir -p "$ARIA2C_DIR"

echo "Downloading Aria2c..."
curl -# -L "$ARIA2C_URL" -o "$ARIA2C_BIN"

echo "Making Aria2c executable..."
chmod +x "$ARIA2C_BIN"

echo "Creating symlink in /usr/bin/aria2c for immediate use..."
ln -sf "$ARIA2C_BIN" "$ARIA2C_SYMLINK"

# Ensure custom.sh exists
if [ ! -f "$CUSTOM_SH" ]; then
    echo "#!/bin/bash" > "$CUSTOM_SH"
    chmod +x "$CUSTOM_SH"
fi

# Add Aria2c relink on boot (if not already present)
if ! grep -q "ln -sf $ARIA2C_BIN $ARIA2C_SYMLINK" "$CUSTOM_SH"; then
    echo "ln -sf $ARIA2C_BIN $ARIA2C_SYMLINK" >> "$CUSTOM_SH"
fi

# Display final dialog box
dialog --msgbox "Aria2c setup is complete!

- Aria2c has been installed and symlinked to /usr/bin/aria2c.
- It is available for immediate use and will persist on reboot.
- To verify, run: aria2c -h 

Enjoy!" 12 60


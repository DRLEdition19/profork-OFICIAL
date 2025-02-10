#!/bin/bash

XDOTOOL_DIR="/userdata/system/pro/xdotool"
XDOTOOL_BIN="$XDOTOOL_DIR/xdotool"
XDOTOOL_URL="https://github.com/trashbus99/profork/raw/master/.dep/xdotool"
XDOTOOL_SYMLINK="/usr/bin/xdotool"
CUSTOM_SH="/userdata/system/custom.sh"

echo "Creating xdotool directory..."
mkdir -p "$XDOTOOL_DIR"

echo "Downloading xdotool..."
curl -# -L "$XDOTOOL_URL" -o "$XDOTOOL_BIN"

echo "Making xdotool executable..."
chmod +x "$XDOTOOL_BIN"

echo "Creating symlink in /usr/bin/xdotool for immediate use..."
ln -sf "$XDOTOOL_BIN" "$XDOTOOL_SYMLINK"

# Ensure custom.sh exists
if [ ! -f "$CUSTOM_SH" ]; then
    echo "#!/bin/bash" > "$CUSTOM_SH"
    chmod +x "$CUSTOM_SH"
fi

# Add xdotool relink on boot (if not already present)
if ! grep -q "ln -sf $XDOTOOL_BIN $XDOTOOL_SYMLINK" "$CUSTOM_SH"; then
    echo "ln -sf $XDOTOOL_BIN $XDOTOOL_SYMLINK" >> "$CUSTOM_SH"
fi

# Display final dialog box
dialog --msgbox "xdotool setup is complete!

- xdotool has been installed and symlinked to /usr/bin/xdotool.
- It is available for immediate use and will persist on reboot.
- To verify, run: xdotool --help

Enjoy!" 12 60

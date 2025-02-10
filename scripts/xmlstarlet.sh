#!/bin/bash

XMLSTARLET_DIR="/userdata/system/pro/xmlstarlet"
XMLSTARLET_BIN="$XMLSTARLET_DIR/xmlstarlet"
XMLSTARLET_URL="https://github.com/trashbus99/profork/raw/master/.dep/xmlstarlet"
XMLSTARLET_SYMLINK="/usr/bin/xmlstarlet"
CUSTOM_SH="/userdata/system/custom.sh"

echo "Creating XMLStarlet directory..."
mkdir -p "$XMLSTARLET_DIR"

echo "Downloading XMLStarlet..."
curl -# -L "$XMLSTARLET_URL" -o "$XMLSTARLET_BIN"

echo "Making XMLStarlet executable..."
chmod +x "$XMLSTARLET_BIN"

echo "Creating symlink in /usr/bin/xmlstarlet for immediate use..."
ln -sf "$XMLSTARLET_BIN" "$XMLSTARLET_SYMLINK"

# Ensure custom.sh exists
if [ ! -f "$CUSTOM_SH" ]; then
    echo "#!/bin/bash" > "$CUSTOM_SH"
    chmod +x "$CUSTOM_SH"
fi

# Add XMLStarlet relink on boot (if not already present)
if ! grep -q "ln -sf $XMLSTARLET_BIN $XMLSTARLET_SYMLINK" "$CUSTOM_SH"; then
    echo "ln -sf $XMLSTARLET_BIN $XMLSTARLET_SYMLINK" >> "$CUSTOM_SH"
fi

# Display final dialog box
dialog --msgbox "XMLStarlet setup is complete!

- XMLStarlet has been installed and symlinked to /usr/bin/xmlstarlet.
- It is available for immediate use and will persist on reboot.
- To verify, run: xmlstarlet --help

Enjoy!" 12 60

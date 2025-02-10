#!/bin/bash

WINEGE_DIR="/userdata/system/pro/winege"
WINEGE_APPIMAGE="$WINEGE_DIR/wine-ge-8.26.AppImage"
WINEGE_URL="https://github.com/trashbus99/profork/releases/download/r1/wine-staging_ge-proton_8-26-x86_64.AppImage"
WINE_SYMLINK="/usr/bin/wine"
CUSTOM_SH="/userdata/system/custom.sh"

echo "Creating Wine-GE directory..."
mkdir -p "$WINEGE_DIR"

echo "Downloading Wine-GE 8.26 AppImage..."
curl -# -L "$WINEGE_URL" -o "$WINEGE_APPIMAGE"

echo "Making Wine-GE executable..."
chmod +x "$WINEGE_APPIMAGE"

echo "Creating symlink in /usr/bin/wine for immediate use..."
ln -sf "$WINEGE_APPIMAGE" "$WINE_SYMLINK"

# Ensure custom.sh exists
if [ ! -f "$CUSTOM_SH" ]; then
    echo "#!/bin/bash" > "$CUSTOM_SH"
    chmod +x "$CUSTOM_SH"
fi

# Add Wine-GE relink on boot (if not already present)
if ! grep -q "ln -sf $WINEGE_APPIMAGE $WINE_SYMLINK" "$CUSTOM_SH"; then
    echo "ln -sf $WINEGE_APPIMAGE $WINE_SYMLINK" >> "$CUSTOM_SH"
fi

# Display final dialog box
dialog --msgbox "Wine-GE 8.26 setup is complete!

- Wine-GE 8.26 has been installed and symlinked to /usr/bin/wine.
- It is available for immediate use and will persist on reboot.
- To verify, run: wine --version

Enjoy!" 12 60


#!/bin/bash

QEMU_DIR="/userdata/system/pro/qemu"
QEMU_APPIMAGE="$QEMU_DIR/QEMU-git-x86_64.AppImage"
QEMU_URL="https://github.com/lucasmz1/Qemu-AppImage/releases/download/continuous-stable/QEMU-git-x86_64.AppImage"
QEMU_SYMLINK="/usr/bin/qemu"
CUSTOM_SH="/userdata/system/custom.sh"

echo "Creating QEMU directory..."
mkdir -p "$QEMU_DIR"

echo "Downloading QEMU AppImage..."
curl -# -L "$QEMU_URL" -o "$QEMU_APPIMAGE"

echo "Making QEMU executable..."
chmod +x "$QEMU_APPIMAGE"

echo "Creating symlink in /usr/bin/qemu for immediate use..."
ln -sf "$QEMU_APPIMAGE" "$QEMU_SYMLINK"

# Ensure custom.sh exists
if [ ! -f "$CUSTOM_SH" ]; then
    echo "#!/bin/bash" > "$CUSTOM_SH"
    chmod +x "$CUSTOM_SH"
fi

# Add QEMU relink on boot (if not already present)
if ! grep -q "ln -sf $QEMU_APPIMAGE $QEMU_SYMLINK" "$CUSTOM_SH"; then
    echo "ln -sf $QEMU_APPIMAGE $QEMU_SYMLINK" >> "$CUSTOM_SH"
fi

# Display final dialog box
dialog --msgbox "QEMU setup is complete!

- QEMU has been installed and symlinked to /usr/bin/qemu.
- It is available for immediate use and will persist on reboot.
- To verify, run: qemu --version

Enjoy!" 12 60

#!/bin/bash

TESSERACT_DIR="/userdata/system/pro/tesseract"
TESSERACT_APPIMAGE="$TESSERACT_DIR/tesseract-5.5.0-x86_64.AppImage"
TESSERACT_URL="https://github.com/AlexanderP/tesseract-appimage/releases/download/v5.5.0/tesseract-5.5.0-x86_64.AppImage"
TESSERACT_SYMLINK="/usr/bin/tesseract"
CUSTOM_SH="/userdata/system/custom.sh"

echo "Creating Tesseract directory..."
mkdir -p "$TESSERACT_DIR"

echo "Downloading Tesseract OCR..."
curl -# -L "$TESSERACT_URL" -o "$TESSERACT_APPIMAGE"

echo "Making Tesseract executable..."
chmod +x "$TESSERACT_APPIMAGE"

echo "Creating symlink in /usr/bin/tesseract for immediate use..."
ln -sf "$TESSERACT_APPIMAGE" "$TESSERACT_SYMLINK"

# Ensure custom.sh exists
if [ ! -f "$CUSTOM_SH" ]; then
    echo "#!/bin/bash" > "$CUSTOM_SH"
    chmod +x "$CUSTOM_SH"
fi

# Add Tesseract relink on boot (if not already present)
if ! grep -q "ln -sf $TESSERACT_APPIMAGE $TESSERACT_SYMLINK" "$CUSTOM_SH"; then
    echo "ln -sf $TESSERACT_APPIMAGE $TESSERACT_SYMLINK" >> "$CUSTOM_SH"
fi

# Display final dialog box
dialog --msgbox "Tesseract OCR setup is complete!

- Tesseract has been installed and symlinked to /usr/bin/tesseract.
- It is available for immediate use and will persist on reboot.
- To verify, run: tesseract --version

Enjoy!" 12 60

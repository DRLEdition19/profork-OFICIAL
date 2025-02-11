#!/bin/bash

# Define variables
URL="https://github.com/trashbus99/profork/releases/download/r1/Quest_For_Glory_2.tar.gz"
DEST_DIR="/userdata/roms/windows"
FILENAME="Quest_for_Glory_2_Vga.pc"
TEMP_ARCHIVE="$DEST_DIR/Quest_For_Glory_2.tar.gz"
MESSAGE="QFG2 - Game downloaded and ready in $DEST_DIR"

# Ensure the destination directory exists
mkdir -p "$DEST_DIR"

# Download the tar.gz file using curl with a progress bar
echo "Downloading Quest for Glory 2..."
curl -# -L -o "$TEMP_ARCHIVE" "$URL"
if [[ $? -ne 0 ]]; then
  echo "❌ Error: Failed to download $URL"
  exit 1
fi

# Extract the archive
echo "Extracting game files..."
tar -xzvf "$TEMP_ARCHIVE" -C "$DEST_DIR"

# Identify the extracted file and rename it
EXTRACTED_FILE=$(tar -tzf "$TEMP_ARCHIVE" | head -1)  # Get the first file extracted
if [[ -n "$EXTRACTED_FILE" ]]; then
  mv "$DEST_DIR/$EXTRACTED_FILE" "$DEST_DIR/$FILENAME"
  echo "✅ Extraction complete. File renamed to: $DEST_DIR/$FILENAME"
else
  echo "⚠️ Warning: No file extracted, please check the archive."
  exit 1
fi

# Cleanup: Remove the downloaded archive
rm -f "$TEMP_ARCHIVE"

# Display completion message
echo "$MESSAGE"

# Optional: Show message box (if dialog is installed)
if command -v dialog &> /dev/null; then
  dialog --msgbox "$MESSAGE" 6 50
fi

clear


#!/bin/bash

# Define variables
URL="https://github.com/trashbus99/profork/raw/master/windows/Starfighter.tar.gz"
DEST_DIR="/userdata/roms/windows"
FILENAME="Starfighter.pc"
TEMP_ARCHIVE="$DEST_DIR/Starfighter.tar.gz"
MESSAGE="Starfighter - Game downloaded and ready in $DEST_DIR"

# Ensure the destination directory exists
mkdir -p "$DEST_DIR"

# Download the tar.gz file using curl with a progress bar
echo "Downloading Starfighter..."
curl -# -L -o "$TEMP_ARCHIVE" "$URL"
if [[ $? -ne 0 ]]; then
  echo "❌ Error: Failed to download $URL"
  exit 1
fi

# Extract the archive
echo "Extracting game files..."
tar -xzvf "$TEMP_ARCHIVE" -C "$DEST_DIR"

# Identify the first extracted file or folder
EXTRACTED_ITEM=$(tar -tzf "$TEMP_ARCHIVE" | head -1 | cut -d '/' -f1)

# Check if extraction was successful and rename if necessary
if [[ -n "$EXTRACTED_ITEM" && -e "$DEST_DIR/$EXTRACTED_ITEM" ]]; then
  # Move the extracted file to the intended name, if it's a file
  if [[ -f "$DEST_DIR/$EXTRACTED_ITEM" ]]; then
    mv "$DEST_DIR/$EXTRACTED_ITEM" "$DEST_DIR/$FILENAME"
    echo "✅ Extraction complete. File renamed to: $DEST_DIR/$FILENAME"
  else
    echo "⚠️ Warning: Extracted content is a directory. No renaming applied."
  fi
else
  echo "⚠️ Warning: No valid file extracted, please check the archive."
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

#!/bin/bash

# Define base URL and file names
BASE_URL="https://github.com/trashbus99/profork/releases/download/r1"
FILES=("Kings_Quest_1_VGA.tar.gz" "Kings_Quest_2_VGA.tar.gz" "Kings_Quest_3_VGA.tar.gz")
DEST_DIR="/userdata/roms/windows"
RENAMED_FILES=("Kings_Quest_1_VGA.pc" "Kings_Quest_2_VGA.pc" "Kings_Quest_3_VGA.pc")

# Wine Compatibility Messages
MESSAGE="Works best on Wine 10.1 or higher. Available for v40+ in wine custom downloader on profork."

# Ensure the destination directory exists
mkdir -p "$DEST_DIR"

# Loop through each file, download, extract, rename, and clean up
for i in "${!FILES[@]}"; do
    FILE="${FILES[$i]}"
    RENAMED="${RENAMED_FILES[$i]}"
    TEMP_ARCHIVE="$DEST_DIR/$FILE"

    echo "📥 Downloading $FILE..."
    curl -# -L -o "$TEMP_ARCHIVE" "$BASE_URL/$FILE"
    if [[ $? -ne 0 ]]; then
        echo "❌ Error: Failed to download $FILE"
        continue
    fi

    echo "📦 Extracting $FILE..."
    tar -xzvf "$TEMP_ARCHIVE" -C "$DEST_DIR"

    # Identify the extracted file and rename it
    EXTRACTED_FILE=$(tar -tzf "$TEMP_ARCHIVE" | head -1)
    if [[ -n "$EXTRACTED_FILE" ]]; then
        mv "$DEST_DIR/$EXTRACTED_FILE" "$DEST_DIR/$RENAMED"
        echo "✅ Extracted and renamed to: $DEST_DIR/$RENAMED"
    else
        echo "⚠️ Warning: No file extracted from $FILE"
        continue
    fi

    # Cleanup: Remove the downloaded archive
    rm -f "$TEMP_ARCHIVE"
done

# Completion message
echo "🎉 All King's Quest VGA games downloaded and extracted successfully!"
echo -e "\n$MESSAGE"

# Optional: Show dialog message if available
if command -v dialog &> /dev/null; then
    dialog --msgbox "$MESSAGE" 8 60
fi

clear

#!/bin/bash

# Path to the BUA folder
BUA_FOLDER="/userdata/system/add-ons"

# Check if the folder exists
if [ ! -d "$BUA_FOLDER" ]; then
    echo "BUA folder not detected, installing BUA...."
    curl -L bit.ly/BUAinstaller | bash
fi

# Run the main menu app
echo "add-on folder found. Loading BUA"
curl -Ls https://github.com/DTJW92/batocera-unofficial-addons/raw/main/app/batocera-unofficial-addons.sh | bash

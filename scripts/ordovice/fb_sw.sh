#!/bin//bash

echo "If Loading freezes, ctrl-c and try again"
curl -L bit.ly/foclabroc-switchoff | bash


# Dialog menu prompt
dialog --title "Batocera Version Check" \
--yesno "Are you using Batocera version 40 or lower?\n\nSelect 'Yes' to patch the launchers.\nSelect 'No' if you are running version 41 or higher." 10 50

# Capture the exit status of dialog
response=$?

if [ $response -eq 0 ]; then
    # User selected "Yes"
    echo "Patching launchers for version 40 or lower..."
    
    # Create the necessary directories if they don't exist
    mkdir -p /userdata/system/switch/configgen
    mkdir -p /userdata/system/switch/configgen/generators/ryujinx
    mkdir -p /userdata/system/switch/configgen/generators/yuzu
    rm -f /userdata/system/switch/configgen/switchlauncher.py
    rm -f /userdata/system/switch/configgen/generators/ryujinx/ryujinxMainlineGenerator.py
    rm -f /userdata/system/switch/configgen/generators/yuzu/yuzuMainlineGenerator.py
    # Download the files to the specified directories
    curl -L https://raw.githubusercontent.com/trashbus99/profork/refs/heads/master/scripts/ordovice/configgen/switchlauncher.py -o /userdata/system/switch/configgen/switchlauncher.py
    curl -L https://raw.githubusercontent.com/trashbus99/profork/refs/heads/master/scripts/ordovice/configgen/generators/ryujinx/ryujinxMainlineGenerator.py -o /userdata/system/switch/configgen/generators/ryujinx/ryujinxMainlineGenerator.py
    curl -L https://raw.githubusercontent.com/trashbus99/profork/refs/heads/master/scripts/ordovice/configgen/generators/yuzu/yuzuMainlineGenerator.py -o /userdata/system/switch/configgen/generators/yuzu/yuzuMainlineGenerator.py

    echo "Files downloaded and patched successfully!"
else
    # User selected "No" or canceled the prompt
    echo "No patches applied. Exiting..."
    exit 0
fi

echo "DONE"

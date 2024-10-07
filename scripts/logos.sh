#!/bin/bash

# Step 1: Download videostart86.sh to /userdata/system/scripts
mkdir -p ~/scripts
wget -O /userdata/system/scripts/videostart86.sh https://github.com/trashbus99/profork/raw/master/scripts/videostart86.sh

# Step 2: Convert the file to Unix format
dos2unix /userdata/system/scripts/videostart86.sh

# Step 3: Make the script executable
chmod +x /userdata/system/scripts/videostart86.sh

# Step 4: Create the directory if it doesn't exist
mkdir -p /userdata/loadingscreens

# Step 8: Announce done
clear
echo "Setup completed!"

echo "To add custom splash videos, drop mp4s in /userdata/loadingscreens matching rom folder name"

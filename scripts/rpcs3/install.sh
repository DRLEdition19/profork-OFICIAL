#!/bin/bash

# Step 1: Announce the program
echo "Profork PS3 PSN game parser"
echo "Thanks to uureel"
sleep 4
clear


# Step 2: Download the file and announce the download
echo "Downloading batocera-rpcs3-sync script to /userdata/system..."
wget https://raw.githubusercontent.com/trashbus99/profork/master/scripts/rpcs3/batocera-rpcs3-sync -O ~/batocera-rpcs3-sync
# Step 3: Make the script executable
chmod +x ~/batocera-rpcs3-sync
echo "The script has been downloaded and made executable."

# Step 4: Inform the user about how to run the script
clear
dialog --msgbox "You can run ./batocera-rpcs3-sync in /userdata/system anytime after installing pkg files in RPCS3 to parse PS3 PSN games." 10 50


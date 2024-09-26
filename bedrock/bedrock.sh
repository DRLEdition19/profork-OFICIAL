#!/bin/bash

# Define the dialog box with increased dimensions
dialog --title "Bedrock Launcher" \
       --yesno "1. This game now works properly via the Arch container. \
                \nThe appimage version is removed since keyboard support is broken in Batocera standalone \
                \n \
                \n2. This game requires you to own Minecraft Bedrock Edition for Android on your Google account.\
                \n\nCONTINUE TO ARCH CONTAINER INSTALLER?" 15 70

# Capture the exit status of dialog command
response=$?

# Check the response
if [ $response -eq 0 ]; then
    # User selected Yes, execute the curl command
  curl -L https://github.com/trashbus99/profork/raw/master/steam/steam.sh | bash
else
    # User selected No, exit the script
    exit
fi

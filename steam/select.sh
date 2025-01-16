#!/bin/bash

# Function to download prebuilt image
download_prebuilt() {
    echo "Downloading Prebuilt Image..."
    curl -L https://github.com/trashbus99/profork/raw/master/steam/install2.sh | bash
}

# Function to build container from scratch
build_from_scratch() {
    echo "Building Up-to-Date Container from Scratch..."
    curl -L https://github.com/trashbus99/profork/raw/master/steam/install_new.sh | bash
}

# Display the menu
while true; do
    CHOICE=$(dialog --clear \
                    --backtitle "Install Menu" \
                    --title "Choose Installation Method" \
                    --menu "Select an option:" 15 80 2 \
                    1 "Download Prebuilt Image (Jan 8, 2025)" \
                    2 "Build Up-to-Date Container from Scratch (Time Consuming)" \
                    3>&1 1>&2 2>&3)

    clear
    case $CHOICE in
        1)
            download_prebuilt
            break
            ;;
        2)
            build_from_scratch
            break
            ;;
        *)
            echo "Installation cancelled."
            break
            ;;
    esac
done

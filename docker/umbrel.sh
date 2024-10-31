#!/bin/bash

# Function to check if a port is in use
is_port_in_use() {
    if lsof -i:$1 > /dev/null; then
        return 0 # True, port is in use
    else
        return 1 # False, port is not in use
    fi
}

# Ensure dialog and lsof are installed
if ! command -v dialog &> /dev/null; then
    echo "Dialog is not installed. Please install dialog first."
    exit 1
fi

if ! command -v lsof &> /dev/null; then
    echo "lsof is not installed. Please install lsof first."
    exit 1
fi

# Check for Docker
if ! command -v docker &> /dev/null; then
    dialog --title "Docker Installation" --infobox "Docker could not be found. Installing Docker..." 10 50
    sleep 2
    curl -L https://github.com/trashbus99/profork/raw/master/docker/install.sh | bash
    if ! command -v docker &> /dev/null; then
        dialog --title "Docker Installation Error" --msgbox "Docker installation failed. Please install Docker manually." 10 50
        clear
        exit 1
    fi
fi

# Check if port 80 is in use, prompt user to change if necessary
port=80
if is_port_in_use $port; then
    dialog --title "Port Conflict" --inputbox "Port 80 is already in use. Enter an alternative port for Umbrel:" 10 50 8080 2>port_input
    port=$(<port_input)
    if is_port_in_use $port; then
        dialog --title "Port Error" --msgbox "Selected port $port is also in use. Please try again." 10 50
        clear
        exit 1
    fi
fi

# Create Umbrel storage directory if it doesn't exist
umbrel_data_dir="/userdata/system/umbrel"
mkdir -p "$umbrel_data_dir"

# Run the Umbrel Docker container
docker run -it --rm \
  -p "$port":80 \
  -v "$umbrel_data_dir:/data" \
  -v /var/run/docker.sock:/var/run/docker.sock \
  --stop-timeout 60 \
  dockurr/umbrel

# Final dialog message with instructions
IP=$(hostname -I | awk '{print $1}')
MSG="Umbrel Docker container has been set up.\n\nAccess Umbrel Web UI at http://$IP:$port\nData is stored in: $umbrel_data_dir\n\nYou can manage the container via Docker CLI or other Docker management tools."
dialog --title "Umbrel Setup Complete" --msgbox "$MSG" 20 70

clear

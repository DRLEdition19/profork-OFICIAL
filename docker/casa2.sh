#!/bin/bash

# Base directory for CasaOS data
casaos_data_dir="/userdata/system/casaos"

# Function to check if a port is in use
is_port_in_use() {
    if lsof -i:$1 > /dev/null; then
        return 0 # True, port is in use
    else
        return 1 # False, port is not in use
    fi
}

# Check if port 8080 is in use
if is_port_in_use 8080; then
    dialog --title "Port Conflict" --msgbox "Port 8080 is already in use. Please ensure it is available before installing CasaOS." 10 50
    clear
    exit 1
fi

# Check for Docker
if ! command -v docker &> /dev/null; then
    dialog --title "Docker Installation" --infobox "Docker could not be found. Installing Docker..." 10 50
    sleep 2 # Gives user time to read the message
    curl -L https://github.com/trashbus99/profork/raw/master/docker/install.sh | bash
    # Verify Docker installation
    if ! command -v docker &> /dev/null; then
        dialog --title "Docker Installation Error" --msgbox "Docker installation failed. Please install Docker manually." 10 50
        clear
        exit 1
    fi
fi

# Create necessary directories for CasaOS
mkdir -p "$casaos_data_dir"

# Run CasaOS using Docker CLI
dialog --title "Starting CasaOS" --infobox "Starting CasaOS using Docker CLI..." 10 50
docker run -d \
  --name=casa \
  -p 8080:8080 \
  -v "$casaos_data_dir:/DATA" \
  -v /var/run/docker.sock:/var/run/docker.sock \
  --stop-timeout 60 \
  dockurr/casa

# Check if CasaOS container started successfully
if [ "$(docker ps -q -f name=casa)" ]; then
    MSG="CasaOS Docker container has been set up successfully.\n\nAccess CasaOS Web UI at http://<your-ip>:8080\n\nData is stored in: $casaos_data_dir"
else
    MSG="Failed to start CasaOS Docker container. Please check Docker logs for more details."
fi

# Final dialog message
dialog --title "CasaOS Setup" --msgbox "$MSG" 20 70

clear


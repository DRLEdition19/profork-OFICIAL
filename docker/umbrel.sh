#!/bin/bash

# Base directory for Umbrel data
umbrel_data_dir="/userdata/system/umbrel"

# Function to check if a port is in use
is_port_in_use() {
    if lsof -i:$1 > /dev/null; then
        return 0 # True, port is in use
    else
        return 1 # False, port is not in use
    fi
}

# Check if port 80 is in use
if is_port_in_use 80; then
    dialog --title "Port Conflict" --msgbox "Port 80 is already in use. Please ensure it is available before installing Umbrel." 10 50
    clear
    exit 1
fi

# Check for Docker
# Check for Docker binary and functional service
if ! command -v docker &> /dev/null || ! docker info &> /dev/null; then
    dialog --title "Docker Installation" --infobox "Docker is not installed or the service is not running. Installing Docker..." 10 50
    sleep 2 # Gives user time to read the message
    curl -L https://github.com/trashbus99/profork/raw/master/docker/install.sh | bash
    # Verify Docker installation and service
    if ! command -v docker &> /dev/null || ! docker info &> /dev/null; then
        dialog --title "Docker Installation Error" --msgbox "Docker installation failed or the service did not start. Please install and configure Docker manually." 10 50
        clear
        exit 1
    fi
fi

# Create necessary directories for Umbrel
mkdir -p "$umbrel_data_dir"

# Run Umbrel using Docker CLI
dialog --title "Starting Umbrel" --infobox "Starting Umbrel using Docker CLI..." 10 50
docker run -d \
  --name=umbrel \
  -p 80:80 \
  -v "$umbrel_data_dir:/data" \
  -v /var/run/docker.sock:/var/run/docker.sock \
  --pid=host \
  --stop-timeout 60 \
  dockurr/umbrel

# Check if Umbrel container started successfully
if [ "$(docker ps -q -f name=umbrel)" ]; then
    MSG="Umbrel Docker container has been set up successfully.\n\nAccess Umbrel Web UI at http://<your-ip>\n\nData is stored in: $umbrel_data_dir"
else
    MSG="Failed to start Umbrel Docker container. Please check Docker logs for more details."
fi

# Final dialog message
dialog --title "Umbrel Setup" --msgbox "$MSG" 20 70

clear

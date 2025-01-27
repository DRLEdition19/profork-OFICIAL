#!/bin/bash

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


# Setup Plex directories
plex_base_dir="$HOME/plex"
mkdir -p "$plex_base_dir/config" "$plex_base_dir/tv" "$plex_base_dir/movies"

# Run the Plex Docker container
docker run -d \
  --name=plex \
  --net=host \
  -e PUID=$(id -u) \
  -e PGID=$(id -g) \
  -e TZ=$(cat /etc/timezone) \
  -e VERSION=docker \
  -v "$plex_base_dir/config:/config" \
  -v "$plex_base_dir/tv:/tv" \
  -v "$plex_base_dir/movies:/movies" \
  --device=/dev/dri:/dev/dri \
  --restart unless-stopped \
  lscr.io/linuxserver/plex:latest

# Final message with dialog
MSG="Plex Docker container has been set up.\n\nAccess Plex Web UI at http://<your-ip>:32400/web\nPlex media files are stored in: $plex_base_dir\n\nThe container can be managed via Portainer web UI on port 9443."
dialog --title "Plex Setup Complete" --msgbox "$MSG" 15 70

clear

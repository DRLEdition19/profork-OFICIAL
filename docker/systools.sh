#!/bin/bash

# Check for Docker installation
if ! command -v docker &> /dev/null; then
    dialog --title "Docker Installation" --infobox "Docker could not be found. Installing Docker..." 10 50
    sleep 2
    curl -L https://github.com/trashbus99/profork/raw/master/docker/install.sh | bash
    # Verify Docker installation
    if ! command -v docker &> /dev/null; then
        dialog --title "Docker Installation Error" --msgbox "Docker installation failed. Please install Docker manually." 10 50
        clear
        exit 1
    fi
fi

# Function to check if a port is in use
is_port_in_use() {
    netstat -tuln | grep ":$1 " > /dev/null
    return $?
}

# Function to find the next available port
find_next_available_port() {
    local port=$1
    while is_port_in_use $port; do
        port=$((port + 1))
    done
    echo $port
}

# Determine and set the ports for each service
GLANCES_PORT=$(find_next_available_port 61208)
WETTY_PORT=$(find_next_available_port 3000)
FILEBROWSER_PORT=$(find_next_available_port 8080)

# Base directory for file storage
base_dir="$HOME/docker_services"
mkdir -p "$base_dir/filebrowser_data"

# Stop containers if they already exist
for service in glances wetty filemanager; do
    if [[ "$(docker ps | grep $service)" != "" ]]; then
        docker stop $service 1>/dev/null 2>/dev/null
    fi
done

# Run the Glances container
docker run -d \
    --name glances \
    -p $GLANCES_PORT:61208 \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /run/user/1000/podman/podman.sock:/run/user/1000/podman/podman.sock \
    --restart unless-stopped \
    nicolargo/glances:latest \
    glances -w

# Run the Wetty container
docker run -d \
    --name wetty \
    --network host \
    --user 1000:1000 \
    -p $WETTY_PORT:3000 \
    -e SSL=false \
    -e FORCE_SSH=true \
    -e ALLOW_IFRAME=true \
    -v /etc/localtime:/etc/localtime:ro \
    -v /etc/passwd:/etc/passwd:ro \
    -v /etc/group:/etc/group:ro \
    -v /tmp:/tmp \
    --restart unless-stopped \
    wettyoss/wetty:latest

# Run the File Browser container
docker run -d \
    --name filemanager \
    --user "${UID}:${GID}" \
    -p $FILEBROWSER_PORT:80 \
    -e FB_NOAUTH=true \
    -v "$base_dir/filebrowser_data:/config" \
    -v /:/srv \
    --restart unless-stopped \
    filebrowser/filebrowser:latest

# Final message with dialog
MSG="Docker containers have been set up for Glances, Wetty, and File Browser.\n\n
- Glances: http://<your-ip>:$GLANCES_PORT\n
- Wetty (web-based terminal): http://<your-ip>:$WETTY_PORT/wetty\n
- Wetty with autologin: http://<your-ip>:$WETTY_PORT/wetty/ssh/root?pass=linux\n
- File Browser: http://<your-ip>:$FILEBROWSER_PORT\n\n
File Browser data is stored in: $base_dir/filebrowser_data"


clear

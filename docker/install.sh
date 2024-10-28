#!/bin/bash

# Get the machine hardware name
architecture=$(uname -m)

# Check if the architecture is x86_64 (AMD/Intel)
if [ "$architecture" != "x86_64" ]; then
    echo "This script only runs on AMD or Intel (x86_64) CPUs, not on $architecture."
    exit 1
fi

echo "Preparing & Downloading Docker & Podman..."
echo ""

# Define the directory and the URL for the file
directory="$HOME/batocera-containers"
url="https://github.com/trashbus99/profork/releases/download/r1/batocera-containers"
filename="batocera-containers" # Explicitly set the filename

# Create the directory if it doesn't exist
mkdir -p "$directory"

# Change to the directory
cd "$directory"

# Download the file with the specified filename
wget "$url" -O "$filename"

# Make the file executable
chmod +x "$filename"

echo "File '$filename' downloaded and made executable in '$directory/$filename'"

# Create a service script to handle Docker startup and shutdown
service_file="/userdata/system/services/docker"

cat << 'EOF' > "$service_file"
#!/bin/bash
# Service script to start Docker and exit gracefully in Batocera

start() {
    /userdata/system/batocera-containers/batocera-containers &
    docker start $(docker ps -aq)
}

stop() {
    docker stop $(docker ps -q)
    pkill -TERM dockerd
}

case "$1" in
    start)
        start
        exit 0
        ;;
    stop)
        stop
        exit 0
        ;;
    *)
        echo "Usage: $0 {start | stop}"
        exit 1
        ;;
esac
EOF

# Make the service script executable
chmod +x "$service_file"

# Remove any old Docker startup commands from custom.sh
custom_sh="/userdata/system/custom.sh"
if [[ -f "$custom_sh" ]]; then
    sed -i '/batocera-containers/d' "$custom_sh"
    echo "Removed old Docker startup commands from custom.sh."
fi

# Start the Docker service
"$service_file" start

# Install Portainer
echo "Installing Portainer..."
docker volume create portainer_data
docker run --device /dev/dri:/dev/dri --privileged --net host --ipc host -d --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v /media:/media -v portainer_data:/data portainer/portainer-ce:latest

# Display final message with dialog
dialog --title "Docker Setup Complete" --msgbox "Docker and Portainer are set up. Please enable the 'docker' service in the Services menu under System Settings in Batocera.\nAccess Portainer GUI via https://<batoceraipaddress>:9443" 10 50

clear
exit

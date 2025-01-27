#!/bin/bash

# Initial setup
BACKTITLE="Docker Netboot.xyz Setup"
architecture=$(uname -m)

# Check system architecture
if [ "$architecture" != "x86_64" ]; then
    dialog --title "Architecture Error" --msgbox "This script only runs on AMD or Intel (x86_64) CPUs, not on $architecture." 10 50
    clear
    exit 1
fi

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


# Get network interface
INTERFACE=$(dialog --stdout --inputbox "Enter the network interface (e.g., eth0, wlan0):" 8 45 "$(ip route | awk '/default/ { print $5 }')") || exit
clear

# Get DHCP range start
DHCP_RANGE_START=$(dialog --stdout --inputbox "Enter the DHCP range start IP (e.g., 192.168.0.1):" 8 45 "192.168.0.10") || exit
clear

# Get container IP
CONTAINER_IP=$(dialog --stdout --inputbox "Enter the container IP (e.g., 192.168.0.250):" 8 45 "192.168.0.250") || exit
clear

# Get gateway IP
GATEWAY=$(dialog --stdout --inputbox "Enter the gateway IP (e.g., 192.168.0.1):" 8 45 "$(ip route | awk '/default/ { print $3 }')") || exit
clear

# Get subnet (CIDR notation)
SUBNET=$(dialog --stdout --inputbox "Enter the subnet in CIDR format (e.g., 192.168.0.0/24):" 8 45 "192.168.0.0/24") || exit
clear

# Run Docker Container
docker run -d \
  --name=netbootxyz \
  --net=host \
  --cap-add=NET_ADMIN \
  -e INTERFACE=$INTERFACE \
  -e DHCP_RANGE_START=$DHCP_RANGE_START \
  -e GATEWAY=$GATEWAY \
  -e SUBNET=$SUBNET \
  -e CONTAINER_IP=$CONTAINER_IP \
  samdbmg/dhcp-netboot.xyz


# Final message to the user
MSG="Your Netboot.xyz docker container has been started with the following configurations:\n
- Network Interface: $INTERFACE\n
- DHCP Range Start: $DHCP_RANGE_START\n
- Gateway IP: $GATEWAY\n
- Subnet: $SUBNET\n
- Container IP: $CONTAINER_IP\n
\nYou can now boot clients via PXE and access installers and utilities through netboot.xyz.\n
\nThe Container can be managed via docker cli or portainer on port 9443."

# Use dialog to display the message
dialog --title "Netboot Setup Complete" --msgbox "$MSG" 20 70
clear


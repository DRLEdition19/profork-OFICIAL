#!/bin/bash

cd /userdata/system
rm -f Install.Full.PortMaster.sh
wget https://github.com/PortsMaster/PortMaster-GUI/releases/download/2024.10.16-1432/Install.Full.PortMaster.sh
chmod +x Install.Full.PortMaster.sh
./Install.Full.PortMaster.sh
rm Install.Full.PortMaster.sh
clear
echo "Portmaster is installed to ports. Refresh/update gamelist  It will usually launch on the second attempt."
echo "Game compatibility varies"
sleep 10
echo""
echo ""
echo "Done.."



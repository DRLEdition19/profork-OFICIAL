#!/bin/bash

cd /userdata/system
rm -f Install.Full.PortMaster.sh
wget https://github.com/PortsMaster/PortMaster-GUI/releases/download/2024.10.16-1432/Install.Full.PortMaster.sh
chmod +x Install.Full.PortMaster.sh
./Install.Full.PortMaster.sh
rm Install.Full.PortMaster.sh
clear
clear
dialog --msgbox "Portmaster is installed to ports. Refresh/update the gamelist. It will usually launch on the second launcher attempt.\n\nGame compatibility varies." 10 60




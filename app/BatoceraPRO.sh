#!/bin/bash
DISPLAY=:0.0 xterm -fs 30 -maximized -fg white -bg black -fa "DejaVuSansMono" -en UTF-8 -e bash -c "DISPLAY=:0.0  curl -L gitlab.com/trashbus/batocera-pro/raw/main/app/pro.sh | bash"


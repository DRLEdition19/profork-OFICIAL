#!bin/bash
DISPLAY=:0.0
ALLOW_ROOT=1
DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u)/bus
./conty.sh lutris

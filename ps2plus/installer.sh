#!/bin/bash
##################################################################################################################################
#---------------------------------------------------------------------------------------------------------------------------------




app=ps2plus




#---------------------------------------------------------------------------------------------------------------------------------
##################################################################################################################################
export DISPLAY=:0.0 ; cd /tmp/ ; rm "/tmp/pro-framework.sh" 2>/dev/null ; rm "/tmp/$app.sh" 2>/dev/null ;
wget --no-check-certificate --no-cache --no-cookies -q -O "/tmp/pro-framework.sh" "https://github.com/trashbus99/profork/raw/master/.dep/pro-framework.sh" ; 
wget --no-check-certificate --no-cache --no-cookies -q -O "/tmp/$app.sh" "https://github.com/trashbus99/profork/raw/master/$app/$app.sh" ; 
dos2unix /tmp/pro-framework.sh ; dos2unix "/tmp/$app.sh" ;  
source /tmp/pro-framework.sh  
bash "/tmp/$app.sh"
echo "patch -- downloading es_configs..."
sleep 4
# Define URLs and destination directory
url1="https://github.com/trashbus99/profork/blob/master/ps2plus/extras/es_features_ps2plus.cfg"
url2="https://github.com/trashbus99/profork/blob/master/ps2plus/extras/es_system_ps2plus.cfg"
destination="/userdata/system/configs/emulationstation"

# Create the destination directory if it doesn't exist
mkdir -p "$destination"

# Download the files
curl -L "$url1" -o "$destination/es_features_ps2plus.cfg"
curl -L "$url2" -o "$destination/es_system_ps2plus.cfg"

# Confirm completion
echo "Files downloaded to $destination."
echo "Downloaded cfg files"
sleep 3
# batocera.pro // 

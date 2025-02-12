#!/bin/bash
#!/bin/bash

dialog --backtitle "Batocera v41+" \
       --title "PS3+ Support Removed" \
       --yes-label "Continue" \
       --no-label "Cancel" \
       --extra-button --extra-label "Exit" \
       --yesno "Batocera v41+ no longer supports PS3+. Do you want to continue?" 7 50

response=$?

case $response in
  0) echo "User chose to continue." ;;
  1) echo "User chose to cancel." ;;
  3) echo "User chose to exit." ;;
esac

##################################################################################################################################
#---------------------------------------------------------------------------------------------------------------------------------




app=ps3plus




#---------------------------------------------------------------------------------------------------------------------------------
##################################################################################################################################
export DISPLAY=:0.0 ; cd /tmp/ ; rm "/tmp/pro-framework.sh" 2>/dev/null ; rm "/tmp/$app.sh" 2>/dev/null ;
wget --no-check-certificate --no-cache --no-cookies -q -O "/tmp/pro-framework.sh" "https://raw.githubusercontent.com/uureel/batocera.pro/main/.dep/pro-framework.sh" ; 
wget --no-check-certificate --no-cache --no-cookies -q -O "/tmp/$app.sh" "https://github.com/trashbus99/profork/raw/master/ps3plus/ps3plus.sh" ; 
dos2unix /tmp/pro-framework.sh ; dos2unix "/tmp/$app.sh" ;  
source /tmp/pro-framework.sh  
bash "/tmp/$app.sh"
# batocera.pro // 

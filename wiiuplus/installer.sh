#!/bin/bash
#!/bin/bash

dialog --backtitle "Batocera v41+" \
       --title "Wiiu+ Support Removed" \
       --yes-label "Continue" \
       --no-label "Cancel" \
       --extra-button --extra-label "Exit" \
       --yesno "Batocera v41+ no longer supports Wiiu+. Do you want to continue?" 7 50

response=$?

case $response in
  0) echo "User chose to continue." ;;
  1) echo "User chose to cancel." ;;
  3) echo "User chose to exit." ;;
esac

##################################################################################################################################
#---------------------------------------------------------------------------------------------------------------------------------




app=wiiuplus




#---------------------------------------------------------------------------------------------------------------------------------
##################################################################################################################################
export DISPLAY=:0.0 ; cd /tmp/ ; rm "/tmp/pro-framework.sh" 2>/dev/null ; rm "/tmp/$app.sh" 2>/dev/null ;
wget --no-check-certificate --no-cache --no-cookies -q -O "/tmp/pro-framework.sh" "https://github.com/trashbus99/profork/raw/master/.dep/pro-framework.sh" ; 
wget --no-check-certificate --no-cache --no-cookies -q -O "/tmp/$app.sh" "https://github.com/trashbus99/profork/raw/master/$app/$app.sh" ; 
dos2unix /tmp/pro-framework.sh ; dos2unix "/tmp/$app.sh" ;  
source /tmp/pro-framework.sh  
bash "/tmp/$app.sh"
# batocera.pro // 

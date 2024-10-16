#!/bin/bash
#batocera-lightmode.sh
#######################

echo -e "\n  reverting to default light theme for f1/gtk/pcmanfm..."

# Remove the dark theme entry from the launcher
if [[ "$(cat /usr/bin/filemanagerlauncher | grep "GTK_THEME=Adwaita-dark")" != "" ]]; then 
    sed -i '/export GTK_THEME=Adwaita-dark/d' /usr/bin/filemanagerlauncher
fi

# Remove the dark theme from the system (optional)
rm -rf /usr/share/themes/Adwaita-dark

# Delete the downloaded files (optional)
rm -rf /userdata/system/pro/dark

# Revert to the default theme by unsetting GTK_THEME
unset GTK_THEME

 echo "Done. Type batocera-save-overlay in the terminal to make persistent on reboot."  
 echo "Caution: Saving overlay will save any other system modifications you made since last reboot as well."
 sleep 8


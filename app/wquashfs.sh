#!/bin/bash

clear 

# Function to display animated title with colors
animate_title() {
    local text="Windows/Wine Freeware games"
    local delay=0.03
    local length=${#text}

    echo -ne "\e[1;36m"  # Set color to cyan
    for (( i=0; i<length; i++ )); do
        echo -n "${text:i:1}"
        sleep $delay
    done
    echo -e "\e[0m"  # Reset color
}

# Function to display animated border
animate_border() {
    local char="#"
    local width=50

    for (( i=0; i<width; i++ )); do
        echo -n "$char"
        sleep 0.02
    done
    echo
}

# Function to display controls
display_controls() {
    echo -e "\e[1;32m"  # Set color to green
    echo "K/B Controls + Gamepad Controls when launched from ports:"
    echo "  Navigate with up-down-left-right"
    echo "  Select app with A/B/SPACE and execute with Start/X/Y/ENTER"
    echo -e "\e[0m"  # Reset color
    sleep 4
}

# Function to display loading animation
loading_animation() {
    local delay=0.1
    local spinstr='|/-\'
    echo -n "Loading "
    while :; do
        for (( i=0; i<${#spinstr}; i++ )); do
            echo -ne "${spinstr:i:1}"
            echo -ne "\010"
            sleep $delay
        done
    done &
    spinner_pid=$!
    sleep 3
    kill $spinner_pid
    echo "Done!"
}

# Main script execution
clear
animate_border
animate_title
animate_border
display_controls

# Define an associative array for app names and their install commands
declare -A apps
apps=(
    # ... (populate with your apps as shown before)
    ["Zelda-2-enhanced-PC-remake"]="curl -Ls https://github.com/trashbus99/profork/raw/master/windows/zelda2.sh | bash"
    ["Celeste-Classic"]="curl -Ls https://github.com/trashbus99/profork/raw/master/windows/celeste.sh | bash" 
    ["Apotris"]="curl -Ls https://github.com/trashbus99/profork/raw/master/windows/apotris.sh | bash"
    ["Maldita-Castilla"]="curl -Ls  https://github.com/trashbus99/profork/releases/download/r1/maldita_castilla.wsquashfs | bash"
   

    # Add other apps here
)

# Prepare array for dialog command, sorted by app name
app_list=()
for app in $(printf "%s\n" "${!apps[@]}" | sort); do
    app_list+=("$app" "" OFF)
done

# Show dialog checklist
cmd=(dialog --separate-output --checklist "Select applications to install or update:" 22 76 16)
choices=$("${cmd[@]}" "${app_list[@]}" 2>&1 >/dev/tty)

# Check if Cancel was pressed
if [ $? -eq 1 ]; then
    echo "Installation cancelled."
    exit
fi

# Install selected apps
for choice in $choices; do
    applink="$(echo "${apps[$choice]}" | awk '{print $3}')"
    rm /tmp/.app 2>/dev/null
    wget --tries=10 --no-check-certificate --no-cache --no-cookies -q -O "/tmp/.app" "$applink"
    if [[ -s "/tmp/.app" ]]; then 
        dos2unix /tmp/.app 2>/dev/null
        chmod 777 /tmp/.app 2>/dev/null
        clear
        loading_animation
        sed 's,:1234,,g' /tmp/.app | bash
        echo -e "\n\n$choice DONE.\n\n"
    else 
        echo "Error: couldn't download installer for ${apps[$choice]}"
    fi
done

# Reload ES after installations
killall -9 emulationstation

echo "Exiting."

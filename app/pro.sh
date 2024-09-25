#!/bin/bash

clear 

# Function to display animated title with colors
animate_title() {
    local text="PROFORK Add-ON Installer (h/t UUREEL)"
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
    ["ARCH-CONTAINER"]="curl -Ls https://github.com/trashbus99/profork/raw/master/steam/steam.sh | bash"
    ["7ZIP"]="curl -Ls https://github.com/trashbus99/profork/raw/master/7zip/7zip.sh | bash"
    ["86BOX"]="curl -Ls https://github.com/trashbus99/profork/raw/master/86box/86box.sh | bash"
    ["ALTUS"]="curl -Ls https://github.com/trashbus99/profork/raw/master/altus/altus.sh | bash"
    ["AMAZON-LUNA"]="curl -Ls https://github.com/trashbus99/profork/raw/master/amazonluna/amazonluna.sh"
    ["ANDROID/BLISS-OS/DOCKER/QEMU"]="curl -Ls https://github.com/trashbus99/profork/raw/master/docker/bliss_install.sh | bash" 
    ["ANTIMICROX"]="curl -Ls https://github.com/trashbus99/profork/raw/master/antimicrox/antimicrox.sh | bash"
    ["APPIMAGE-PARSER"]="curl -Ls https://github.com/trashbus99/profork/raw/master/appimage/install.sh | bash"
    ["APPLEWIN/WINE"]="curl -Ls https://github.com/trashbus99/profork/raw/master/applewin/applewin.sh | bash"
    ["ATOM"]="curl -Ls https://github.com/trashbus99/profork/raw/master/atom/atom.sh | bash"
    ["BALENA-ETCHER"]="curl -Ls https://github.com/trashbus99/profork/raw/master/balena/balena.sh | bash"
    ["BLENDER"]="curl -Ls https://github.com/trashbus99/profork/raw/master/blender/blender.sh | bash"
    ["BRAVE"]="curl -Ls https://github.com/trashbus99/profork/raw/master/brave/brave.sh | bash"
    ["CASAOS/CONTAINER/DEBIAN/XFCE"]="curl -Ls https://github.com/trashbus99/profork/raw/master/docker/casa.sh | bash"
    ["CHIAKI"]="curl -Ls https://github.com/trashbus99/profork/raw/master/chiaki/chiaki.sh | bash"
    ["CHROME"]="curl -Ls https://github.com/trashbus99/profork/raw/master/chrome/chrome.sh | bash"
    ["CPU-X"]="curl -Ls https://github.com/trashbus99/profork/raw/master/cpux/cpux.sh | bash"
    ["DARK-MODE/F1"]="curl -Ls https://github.com/trashbus99/profork/raw/master/dark/dark.sh | bash"
    ["DISCORD"]="curl -Ls https://github.com/trashbus99/profork/raw/master/discord/discord.sh | bash"
    ["DOCKER"]="curl -Ls https://github.com/trashbus99/profork/raw/master/docker/install.sh | bash"    
    ["DOUBLE-COMMANDER"]="curl -Ls https://github.com/trashbus99/profork/raw/master/doublecmd/doublecmd.sh | bash"
    ["EDGE"]="curl -Ls https://github.com/trashbus99/profork/raw/master/edge/edge.sh| bash"
    ["EMUDECK/CONTAINER"]="curl -Ls https://github.com/trashbus99/profork/raw/master/steam/steam.sh | bash"
    ["EMBY/DOCKER"]="curl -Ls https://github.com/trashbus99/profork/raw/master/docker/emby.sh | bash"
    ["FERDIUM"]="curl -Ls https://github.com/trashbus99/profork/raw/master/ferdium/ferdium.sh | bash"
    ["FILEZILLA"]="curl -Ls https://github.com/trashbus99/profork/raw/master/filezilla/filezilla.sh | bash"
    ["FIREFOX"]="curl -Ls https://github.com/trashbus99/profork/raw/master/firefox/ff.sh | bash"
    ["FIGHTCADE-2"]="curl -Ls https://github.com/trashbus99/profork/raw/master/steam/steam.sh | bash"
    ["FOOBAR2000"]="curl -Ls https://github.com/trashbus99/profork/raw/master/foobar/foobar.sh | bash"
    ["GAME-MANAGER"]="curl -Ls https://github.com/trashbus99/profork/raw/master/gamelist-manager/gamelist-manager.sh | bash"
    ["GEFORCENOW"]="curl -Ls https://github.com/trashbus99/profork/raw/master/geforcenow/geforcenow.sh | bash"
    ["GPARTED"]="curl -Ls https://github.com/trashbus99/profork/raw/master/gparted/gparted.sh | bash"
    ["GREENLIGHT"]="curl -Ls https://github.com/trashbus99/profork/raw/master/greenlight/greenlight.sh | bash"
    ["GTHUMB"]="curl -Ls https://github.com/trashbus99/profork/raw/master/gthumb/gthumb.sh | bash | bash"
    ["HARD-INFO"]="curl -Ls https://github.com/trashbus99/profork/raw/master/hardinfo/hardinfo.sh | bash"
    ["HEROIC-LAUNCHER"]="curl -Ls https://github.com/trashbus99/profork/raw/master/steam/steam.sh | bash"
    ["HYPER"]="curl -Ls https://github.com/trashbus99/profork/raw/master/hyper/hyper.sh | bash"
    ["ITCH"]="curl -Ls https://github.com/trashbus99/profork/raw/master/itch/itch.sh| bash "
    ["JAVA-RUNTIME"]="curl -Ls https://github.com/trashbus99/profork/raw/master/java/java.sh | bash"
    ["JELLYFIN/DOCKER"]="curl -Ls https://github.com/trashbus99/profork/raw/master/docker/jellyfin.sh | bash"
    ["KDENLIVE"]="curl -Ls https://github.com/trashbus99/profork/raw/master/kdenlive/kdenlive.sh |bash"
    ["KITTY"]="curl -Ls https://github.com/trashbus99/profork/raw/master/kitty/kitty.sh | bash"
    ["KSNIP"]="curl -Ls https://github.com/trashbus99/profork/raw/master/ksnip/ksnip.sh | bash"
    ["KRITA"]="curl -Ls https://github.com/trashbus99/profork/raw/master/krita/krita.sh | bash"
    ["LIVECAPTIONS/SERVICE"]="curl -Ls https://github.com/trashbus99/profork/raw/master/livecaptions/livecaptions.sh | bash"
    ["LINUX-DESKTOPS-RDP/DOCKER"]="curl -Ls https://github.com/trashbus99/profork/raw/master/docker/rdesktop.sh | bash | bash"
    ["LINUX-VMS-ON-QEMU/DOCKER"]="curl -Ls https://github.com/trashbus99/profork/raw/master/docker/qemu.sh | bash | bash"
    ["LUDUSAVI"]="curl -Ls https://github.com/trashbus99/profork/raw/master/ludusavi/ludusavi.sh | bash"
    ["LUTRIS/CONTAINER"]="https://github.com/trashbus99/profork/raw/master/steam/steam.sh | bash"
    ["MEDIAELCH"]="curl -Ls https://github.com/trashbus99/profork/raw/master/mediaelch/mediaelch.sh | bash"
    ["MINECRAFT-BEDROCK-EDITION"]="curl -Ls https://raw.githubusercontent.com/trashbus99/profork/refs/heads/master/bedrock/bedrock.sh | bash"
    ["MINECRAFT-JAVA-EDITION"]="curl -Ls https://github.com/trashbus99/profork/raw/master/minecraft/minecraft.sh | bash"
    ["MOONLIGHT"]="curl -Ls https://github.com/trashbus99/profork/raw/master/moonlight/moonlight.sh | bash"
    ["MPV"]="curl -Ls https://github.com/trashbus99/profork/raw/master/mpv/mpv.sh | bash"
    ["MULTIMC-LAUNCHER"]="curl -Ls https://github.com/trashbus99/profork/raw/master/multimc/multimc.sh | bash"
    ["MUSEEKS"]="curl -Ls https://github.com/trashbus99/profork/raw/master/museeks/museeks.sh | bash"
    ["NETBOOT-XYZ/DOCKER"]="curl -Ls https://github.com/trashbus99/profork/raw/master/docker/netboot.sh | bash"
    ["NEXTCLOUD/DOCKER"]="curl -Ls https://github.com/trashbus99/profork/raw/master/docker/nextcloud.sh | bash" 
    ["NVTOP"]="curl -Ls https://github.com/trashbus99/profork/raw/master/nvtop/nvtop.sh| bash"   
    ["NOMACS"]="curl -Ls https://github.com/trashbus99/profork/raw/master/nomacs/nomacs.sh | bash"
    ["OBS-STUDIO/CONTAINER"]="curl -Ls https://github.com/trashbus99/profork/raw/master/steam/steam.sh| bash"
    ["ODIO"]="curl -Ls https://github.com/trashbus99/profork/raw/master/odio/odio.sh | bash"
    ["OLIVE"]="curl -Ls https://github.com/trashbus99/profork/raw/master/olive/olive.sh | bash"
    ["OPERA"]="curl -Ls https://github.com/trashbus99/profork/raw/master/opera/opera.sh | bash"
    ["PEAZIP"]="curl -Ls https://github.com/trashbus99/profork/raw/master/peazip/peazip.sh | bash"
    ["PHOTOCOLLAGE"]="curl -Ls https://github.com/trashbus99/profork/raw/master/photocollage/photocollage.sh | bash"
    ["PLEX/DOCKER"]="curl -Ls https://github.com/trashbus99/profork/raw/master/docker/plex.sh | bash"
    ["PLEXAMP"]="curl -Ls https://github.com/trashbus99/profork/raw/master/plexamp/installer.sh | bash"
    ["POKEMMO"]="curl -Ls https://github.com/trashbus99/profork/raw/master/pokemmo/pokemmo.sh | bash"
    ["PORTAINER/DOCKER"]="curl -Ls https://github.com/trashbus99/profork/raw/master/docker/install.sh | bash"
    ["PROTONUP-QT"]="curl -Ls https://github.com/trashbus99/profork/raw/master/protonup-qt/protonup-qt.sh | bash"
    ["PS2-MINUS"]="curl -Ls https://github.com/trashbus99/profork/raw/master/ps2minus/installer.sh | bash"
    ["PS2-PLUS"]="curl -Ls https://github.com/trashbus99/profork/raw/master/ps2plus/installer.sh | bash"
    ["PS3-PLUS"]="curl -Ls https://github.com/trashbus99/profork/raw/master/ps3plus/ps3plus.sh | bash"
    ["QBITTORRENT"]="curl -Ls https://github.com/trashbus99/profork/raw/master/qbittorrent/qbittorrent.sh | bash"
    ["QDIRSTAT"]="curl -Ls https://github.com/trashbus99/profork/raw/master/qdirstat/qdirstat.sh | bash"
    ["RHYTHMBOX"]="curl -Ls https://github.com/trashbus99/profork/raw/master/rhythmbox/rhythmbox.sh | bash"
    ["SABNZBD/DOCKER"]="curl -Ls https://github.com/trashbus99/profork/raw/master/docker/sabnzbd.sh | bash"
    ["SAK"]="curl -Ls https://github.com/trashbus99/profork/raw/master/sak/sak.sh | bash"
    ["SAYONARA"]="curl -Ls https://github.com/trashbus99/profork/raw/master/sayonara/sayonara.sh | bash"
    ["SHADPS4"]="curl -Ls https://github.com/trashbus99/profork/raw/master/shadps4/shadps4.sh | bash"
    ["SHEEPSHAVER"]="curl -Ls https://github.com/trashbus99/profork/raw/master/sheepshaver/install.sh | bash"
    ["SMPLAYER"]="curl -Ls https://github.com/trashbus99/profork/raw/master/smplayer/smplayer.sh | bash"
    ["STEAM/CONTAINER"]="curl -Ls https://github.com/trashbus99/profork/raw/master/steam/steam.sh | bash"
    ["STRAWBERRY"]="curl -Ls https://github.com/trashbus99/profork/raw/master/strawberry/strawberry.sh | bash"
    ["SUBLIME-TEXT"]="curl -Ls https://github.com/trashbus99/profork/raw/master/sublime/sublime.sh | bash"
    ["SUNSHINE"]="curl -Ls https://github.com/trashbus99/profork/raw/master/sunshine/installer.sh | bash"
    ["SYSTEM-MONITORING-CENTER"]="curl -Ls https://github.com/trashbus99/profork/raw/master/system-monitoring-center/system-monitoring-center.sh | bash"
    ["TABBY"]="curl -Ls https://github.com/trashbus99/profork/raw/master/tabby/tabby.sh | bash"
    ["TELEGRAM"]="curl https://github.com/trashbus99/profork/raw/master/telegram/telegram.sh | bash"
    ["TOTAL-COMMANDER"]="curl -Ls https://github.com/trashbus99/profork/raw/master/totalcmd/totalcmd.sh | bash"
    ["TRANSMISSION"]="curl -Ls https://github.com/trashbus99/profork/raw/master/transmission/transmission.sh | bash"
    ["VIRTUALBOX"]="curl -Ls https://github.com/trashbus99/profork/raw/master/virtualbox/vbox.sh | bash"
    ["VIVALDI"]="curl -Ls https://github.com/trashbus99/profork/raw/master/vivaldi/vivaldi.sh | bash"
    ["VLC"]="curl -Ls https://github.com/trashbus99/profork/raw/master/vlc/vlc.sh | bash"
    ["WHATSAPP"]="curl -Ls https://github.com/trashbus99/profork/raw/master/whatsapp/whatsapp.sh | bash"
    ["WIIU-PLUS"]="curl -Ls https://github.com/trashbus99/profork/raw/master/wiiuplus/installer.sh | bash"
    ["XARCHIVER"]="curl -Ls https://github.com/trashbus99/profork/raw/master/xarchiver/xarchiver.sh | bash"
    ["XCLOUD"]="curl -Ls https://github.com/trashbus99/profork/raw/master/xcloud/xcloud.sh | bash"
    ["WINDOWS-VMS/DOCKER"]="curl -Ls https://github.com/trashbus99/profork/raw/master/docker/win.sh | bash"
    ["WINE-CUSTOM-DOWNLOADER/v40+"]="curl -Ls https://github.com/trashbus99/profork/raw/master/wine-custom/wine.sh | bash"
    ["WPS-OFFICE"]="curl -Ls https://github.com/trashbus99/profork/raw/master/wps-office/wps.sh | bash"
    ["YARG/YARC-LAUNCHER"]="curl -Ls https://github.com/trashbus99/profork/raw/master/yarg/yarg.sh | bash"
    ["YOUTUBE-MUSIC"]="curl -Ls https://github.com/trashbus99/profork/raw/master/youtube-music/ytm.sh | bash" 
    ["YOUTUBE-TV"]="curl -Ls https://github.com/trashbus99/profork/raw/master/youtubetv/yttv.sh | bash"

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
curl http://127.0.0.1:1234/reloadgames

echo "Exiting."


#!/bin/bash


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
    ["ARCH-CONTAINER"]="curl -Ls https://github.com/trashbus99/profork/raw/master/steam/steam.sh"
    ["7ZIP"]="curl -Ls https://github.com/trashbus99/profork/raw/master/7zip/7zip.sh"
    ["86BOX"]="curl -Ls https://github.com/trashbus99/profork/raw/master/86box/86box.sh"
    ["ALTUS"]="curl -Ls https://github.com/trashbus99/profork/raw/master/altus/altus.sh"
    ["AMAZON-LUNA"]="curl -Ls https://github.com/trashbus99/profork/raw/master/amazonluna/amazonluna.sh"
    ["ANDROID/BLISS-OS/DOCKER/QEMU"]="curl -Ls https://github.com/trashbus99/profork/raw/main/docker/bliss_install.sh | bash" 
    ["ANTIMICROX"]="curl -Ls https://github.com/trashbus99/profork/raw/master/docker/bliss_install.sh"
    ["APPIMAGE-PARSER"]="curl -Ls https://github.com/trashbus99/profork/raw/master/appimage/install.sh"
    ["APPLEWIN/WINE"]="curl -Ls https://github.com/trashbus99/profork/raw/main/applewin/applewin.sh | bash"
    ["ATOM"]="curl -Ls https://github.com/trashbus99/profork/raw/master/atom/atom.sh"
    ["BALENA-ETCHER"]="curl -Ls https://github.com/trashbus99/profork/raw/master/balena/balena.sh"
    ["BLENDER"]="curl -Ls https://github.com/trashbus99/profork/raw/master/blender/blender.sh"
    ["BRAVE"]="curl -Ls https://github.com/trashbus99/profork/raw/master/brave/brave.sh"
    ["CASAOS/CONTAINER/DEBIAN/XFCE"]="curl -Ls https://github.com/trashbus99/profork/raw/main/docker/casa.sh | bash"
    ["CHIAKI"]="curl -Ls https://github.com/trashbus99/profork/raw/master/chiaki/chiaki.sh"
    ["CHROME"]="curl -Ls https://github.com/trashbus99/profork/raw/master/chrome/chrome.sh "
    ["CPU-X"]="https://github.com/trashbus99/profork/raw/master/cpux/cpux.sh"
    ["DARK-MODE/F1"]="curl -Ls https://github.com/trashbus99/profork/raw/master/dark/dark.sh"
    ["DISCORD"]="curl -Ls https://github.com/trashbus99/profork/raw/master/discord/discord.sh"
    ["DOCKER"]="curl -Ls  https://github.com/trashbus99/profork/raw/main/docker/install.sh | bash"    
    ["DOUBLE-COMMANDER"]="curl -Ls https://github.com/trashbus99/profork/raw/master/doublecmd/doublecmd.sh"
    ["EDGE"]="curl -Ls https://github.com/trashbus99/profork/raw/master/edge/edge.sh"
    ["EMUDECK/CONTAINER"]=""https://github.com/trashbus99/profork/raw/master/steam/steam.sh"
    ["EMBY/DOCKER"]="curl -Ls https://github.com/trashbus99/profork/raw/main/docker/emby.sh | bash"
    ["FERDIUM"]="curl -Ls https://github.com/trashbus99/profork/raw/master/ferdium/ferdium.sh"
    ["FILEZILLA"]="curl -Ls https://github.com/trashbus99/profork/raw/master/filezilla/filezilla.sh"
    ["FIREFOX"]="curl -Ls https://github.com/trashbus99/profork/raw/master/firefox/ff.sh"
    ["FIGHTCADE-2"]="curl -Ls https://github.com/trashbus99/profork/raw/master/steam/steam.sh"
    ["FOOBAR2000"]="curl -Ls https://github.com/trashbus99/profork/raw/master/foobar/foobar.sh"
    ["GAME-MANAGER"]="curl -Ls https://github.com/trashbus99/profork/raw/master/gamelist-manager/gamelist-manager.sh"
    ["GEFORCENOW"]="curl -Lshttps://github.com/trashbus99/profork/raw/master/geforcenow/geforcenow.sh"
    ["GPARTED"]="curl -Ls https://github.com/trashbus99/profork/raw/master/gparted/gparted.sh"
    ["GREENLIGHT"]="curl -Ls https://github.com/trashbus99/profork/raw/master/greenlight/greenlight.sh"
    ["GTHUMB"]="curl -Ls https://github.com/trashbus99/profork/raw/master/gthumb/gthumb.sh"
    ["HARD-INFO"]="curl -Ls https://github.com/trashbus99/profork/raw/master/hardinfo/hardinfo.sh"
    ["HEROIC-LAUNCHER"]=""https://github.com/trashbus99/profork/raw/master/steam/steam.sh"
    ["HYPER"]="curl -Ls https://github.com/trashbus99/profork/raw/master/hyper/hyper.sh"
    ["ITCH"]="curl -Ls https://github.com/trashbus99/profork/raw/master/itch/itch.sh"
    ["JAVA-RUNTIME"]="curl -Ls https://github.com/trashbus99/profork/raw/master/java/java.sh"
    ["JELLYFIN/DOCKER"]="curl -Ls https://github.com/trashbus99/profork/raw/main/docker/jellyfin.sh | bash"
    ["KDENLIVE"]="curl -Ls https://github.com/trashbus99/profork/raw/master/kdenlive/kdenlive.sh"
    ["KITTY"]="curl -Ls https://github.com/trashbus99/profork/raw/master/kitty/kitty.sh"
    ["KSNIP"]="curl -Ls https://github.com/trashbus99/profork/raw/master/ksnip/ksnip.sh"
    ["KRITA"]="curl -Ls https://github.com/trashbus99/profork/raw/master/krita/krita.sh | bash"
    ["LIVECAPTIONS/SERVICE"]="curl -Ls https://github.com/trashbus99/profork/raw/master/livecaptions/livecaptions.sh"
    ["LINUX-DESKTOPS-RDP/DOCKER"]="curl -Ls https://github.com/trashbus99/profork/raw/main/docker/rdesktop.sh | bash"
    ["LINUX-VMS-ON-QEMU/DOCKER"]="curl -Ls https://github.com/trashbus99/profork/raw/main/docker/qemu.sh | bash"
    ["LUDUSAVI"]="curl -Ls lhttps://github.com/trashbus99/profork/raw/master/ludusavi/ludusavi.sh"
    ["LUTRIS/CONTAINER"]="https://github.com/trashbus99/profork/raw/master/steam/steam.sh"
    ["MEDIAELCH"]="curl -Ls https://github.com/trashbus99/profork/raw/master/mediaelch/mediaelch.sh"
    ["MINECRAFT-BEDROCK-EDITION"]="curL -Ls https://github.com/trashbus99/profork/raw/main/main/bedrock/bedrock.sh"
    ["MINECRAFT-JAVA-EDITION"]="curl -Ls https://github.com/trashbus99/profork/raw/master/minecraft/minecraft.sh"
    ["MOONLIGHT"]="curl -Ls https://github.com/trashbus99/profork/raw/master/moonlight/moonlight.sh"
    ["MPV"]="curl -Ls https://github.com/trashbus99/profork/raw/master/mpv/mpv.sh"
    ["MULTIMC-LAUNCHER"]="curl -Ls https://github.com/trashbus99/profork/raw/master/multimc/multimc.sh"
    ["MUSEEKS"]="curl -Ls https://github.com/trashbus99/profork/raw/master/museeks/museeks.sh"
    ["NETBOOT-XYZ/DOCKER"]="curl -Ls https://github.com/trashbus99/profork/raw/master/docker/netboot.sh"
    ["NEXTCLOUD/DOCKER"]="curl -Ls https://github.com/trashbus99/profork/raw/main/docker/nextcloud.sh | bash" 
    ["NVTOP"]="curl -Ls https://github.com/trashbus99/profork/raw/master/nvtop/nvtop.sh"   
    ["NOMACS"]="curl -Ls https://github.com/trashbus99/profork/raw/master/nomacs/nomacs.sh"
    ["OBS-STUDIO/CONTAINER"]="curl -Ls https://github.com/trashbus99/profork/raw/master/steam/steam.sh"
    ["ODIO"]="curl -Ls https://github.com/trashbus99/profork/raw/master/odio/odio.sh"
    ["OLIVE"]="curl -Ls https://github.com/trashbus99/profork/raw/master/olive/olive.sh"
    ["OPERA"]="curl -Ls https://github.com/trashbus99/profork/raw/master/opera/opera.sh | bash"
    ["PEAZIP"]="curl -Ls https://github.com/trashbus99/profork/raw/master/peazip/peazip.sh"
    ["PHOTOCOLLAGE"]="curl -Ls https://github.com/trashbus99/profork/raw/master/photocollage/photocollage.sh"
    ["PLEX/DOCKER"]="curl -L https://github.com/trashbus99/profork/raw/main/docker/plex.sh | bash"
    ["PLEXAMP"]="curl -Ls https://github.com/trashbus99/profork/raw/master/plexamp/installer.sh"
    ["POKEMMO"]="curl -Ls https://github.com/trashbus99/profork/raw/master/pokemmo/pokemmo.sh"
    ["PORTAINER/DOCKER"]="curl -Ls https://github.com/trashbus99/profork/raw/main/docker/install.sh | bash"
    ["PROTONUP-QT"]="curl -Ls https://github.com/trashbus99/profork/raw/master/protonup-qt/protonup-qt.sh"
    ["PS2-MINUS"]="curl -Ls https://github.com/trashbus99/profork/raw/master/ps2minus/installer.sh"
    ["PS2-PLUS"]="curl -Ls https://github.com/trashbus99/profork/raw/master/ps2plus/installer.sh"
    ["PS3-PLUS"]="curl -Ls https://github.com/trashbus99/profork/raw/master/ps3plus/ps3plus.sh"
    ["QBITTORRENT"]="curl -Ls https://github.com/trashbus99/profork/raw/master/qbittorrent/qbittorrent.sh"
    ["QDIRSTAT"]="curl -Ls https://github.com/trashbus99/profork/raw/master/qdirstat/qdirstat.sh"
    ["RHYTHMBOX"]="curl -Ls https://github.com/trashbus99/profork/raw/master/rhythmbox/rhythmbox.sh"
    ["SABNZBD/DOCKER"]="curl -Ls https://github.com/trashbus99/profork/raw/main/docker/sabnzbd.sh | bash"
    ["SAK"]="curl -Ls https://github.com/trashbus99/profork/raw/master/sak/sak.sh"
    ["SAYONARA"]="curl -Lshttps://github.com/trashbus99/profork/raw/master/sayonara/sayonara.sh"
    ["SHEEPSHAVER"]="curl -Ls https://github.com/trashbus99/profork/raw/main/sheepshaver/install.sh | bash"
    ["SMPLAYER"]="curl -Ls https://github.com/trashbus99/profork/raw/master/smplayer/smplayer.sh"
    ["STEAM/CONTAINER"]=""https://github.com/trashbus99/profork/raw/master/steam/steam.sh"
    ["STRAWBERRY"]="curl -Ls https://github.com/trashbus99/profork/raw/master/strawberry/strawberry.sh"
    ["SUBLIME-TEXT"]="curl -Ls https://github.com/trashbus99/profork/raw/master/sublime/sublime.sh"
    ["SUNSHINE"]="curl -Ls https://github.com/trashbus99/profork/raw/master/sunshine/installer.sh"
    ["SYSTEM-MONITORING-CENTER"]="curl -Ls https://github.com/trashbus99/profork/raw/master/system-monitoring-center/system-monitoring-center.sh"
    ["TABBY"]="curl -Ls https://github.com/trashbus99/profork/raw/master/tabby/tabby.sh"
    ["TELEGRAM"]="curl https://github.com/trashbus99/profork/raw/master/telegram/telegram.sh"
    ["TOTAL-COMMANDER"]="https://github.com/trashbus99/profork/raw/master/totalcmd/totalcmd.sh"
    ["TRANSMISSION"]="curl -Ls https://github.com/trashbus99/profork/raw/master/transmission/transmission.sh"
    ["VIRTUALBOX"]="https://github.com/trashbus99/profork/raw/master/virtualbox/vbox.sh"
    ["VIVALDI"]="curl -Ls https://github.com/trashbus99/profork/raw/master/vivaldi/vivaldi.sh"
    ["VLC"]="curl -Ls https://github.com/trashbus99/profork/raw/master/vlc/vlc.sh"
    ["WHATSAPP"]="curl -Ls https://github.com/trashbus99/profork/raw/master/whatsapp/whatsapp.sh"
    ["WIIU-PLUS"]="https://github.com/trashbus99/profork/raw/master/wiiuplus/installer.sh"
    ["XARCHIVER"]="curl -Ls https://github.com/trashbus99/profork/raw/master/xarchiver/xarchiver.sh"
    ["XCLOUD"]="curl -Ls https://github.com/trashbus99/profork/raw/master/xcloud/xcloud.sh"
    ["WINDOWS-VMS/DOCKER"]="curl -Ls https://github.com/trashbus99/profork/raw/main/docker/win.sh | bash"
    ["WINE-CUSTOM-DOWNLOADER/v40+"]="curl -Ls https://github.com/trashbus99/profork/raw/main/wine-custom/wine.sh | bash"
    ["WPS-OFFICE"]="curl -Ls https://github.com/trashbus99/profork/raw/master/wps-office/wps.sh"
    ["YARG/YARC-LAUNCHER"]="curl -Ls https://github.com/trashbus99/profork/raw/master/yarg/yarg.sh"
    ["YOUTUBE-MUSIC"]="curl -Ls https://github.com/trashbus99/profork/raw/master/youtube-music/ytm.sh" 
    ["YOUTUBE-TV"]="curl -Ls https://github.com/trashbus99/profork/raw/master/youtubetv/yttv.sh"

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


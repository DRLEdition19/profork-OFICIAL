#!/bin/bash

# Check if Docker is running and inform the user if it is
if pgrep -x "dockerd" >/dev/null; then
    dialog --title "Error" --msgbox "Docker is currently running. Please remove Docker as Batocera-CLI has its own Docker implementation." 8 60
    exit 1
fi

# Display available CLI tools using dialog
cli_apps="zsh + ohmyzsh + plugins + p10k + ~/.zshrc + ~/p10k.zsh\n\
fish + ohmyfish\n\
git\n\
docker\n\
podman\n\
distrobox\n\
exa\n\
bat / batcat\n\
glances\n\
aria2c\n\
bandwhich\n\
btop\n\
dua\n\
duf\n\
fzf\n\
hyperfine\n\
icdiff\n\
micro\n\
neofetch\n\
procs\n\
ranger\n\
rgrep\n\
rip\n\
scc\n\
screenfetch\n\
sd\n\
speedtest-cli\n\
strings\n\
tldr\n\
transfersh\n\
tre\n\
xmlstarlet\n\
zoxide"

dialog --title "Batocera-CLI Available Tools" --msgbox "The following CLI apps are available in Batocera-CLI:\n\n$cli_apps" 20 70

# Announce Batocera-CLI Downloader
dialog --title "Batocera-CLI Downloader" --msgbox "Batocera-CLI Downloader is starting. This will download and set up the Batocera-CLI package for you." 8 60

# Download and extract the Batocera-CLI package
wget -O ~/cli.tar.gz https://github.com/trashbus99/profork/releases/download/r1/cli.tar.gz

# Check if the download was successful
if [[ $? -ne 0 ]]; then
    dialog --title "Error" --msgbox "Failed to download the Batocera-CLI package. Please check your network and try again." 8 60
    exit 1
fi

# Extract the package
tar -xf ~/cli.tar.gz -C ~/

# Inform the user about the setup completion
dialog --title "Installation Complete" --msgbox "Batocera-CLI setup is complete. Run '~/cli/run' to start. You can edit '~/cli/run' to set which services start up." 10 70

# Cleanup
rm ~/cli.tar.gz

#!/bin/bash
# batocera-darkmode-installer.sh
#####################

echo -e "\nPreparing dark theme for F1/GTK/PCManFM..."

# Prepare the dark theme directory
theme_dir="/userdata/system/pro/dark"
mkdir -p "$theme_dir" 2>/dev/null

# Download and set up theme files
cd "$theme_dir"
wget -q "https://github.com/trashbus99/profork/raw/master/dark/Adwaita-dark.zip"
unzip -oq ./Adwaita-dark.zip
cp -r ./Adwaita-dark /usr/share/themes/

# Download dark mode service script
service_dir="/userdata/system/services"
service_file="$service_dir/darktheme"
wget -q -O "$service_file" "https://github.com/trashbus99/profork/raw/master/dark/dark.sh"
dos2unix "$service_file" 1>/dev/null 2>/dev/null
chmod +x "$service_file" 2>/dev/null

# Create the dark theme service to apply/remove the theme
cat << 'EOF' > "$service_file"
#!/bin/bash
# Dark theme service script for Batocera

start() {
    echo -e "\nApplying dark theme for F1/GTK/PCManFM..."

    cp -r /userdata/system/pro/dark/Adwaita-dark /usr/share/themes/

    # Add dark theme to F1 launcher if not already present
    if ! grep -q "GTK_THEME=Adwaita-dark" /usr/bin/filemanagerlauncher; then
        sed -i '/export XDG_CONFIG_DIRS=\/etc\/xdg/a export GTK_THEME=Adwaita-dark' /usr/bin/filemanagerlauncher
    fi

    export GTK_THEME=Adwaita-dark
    echo -e "Dark theme applied.\n"
}

stop() {
    echo -e "\nReverting to default light theme for F1/GTK/PCManFM..."

    # Remove dark theme setting from F1 launcher
    sed -i '/export GTK_THEME=Adwaita-dark/d' /usr/bin/filemanagerlauncher

    unset GTK_THEME
    echo -e "Default theme restored.\n"
}

case "$1" in
    start)
        start
        exit 0
        ;;
    stop)
        stop
        exit 0
        ;;
    *)
        echo "Usage: $0 {start | stop}"
        exit 1
        ;;
esac
EOF

echo "Dark theme setup complete. Enable the 'darktheme' service from the Services menu in Batocera's System Settings."
sleep 5

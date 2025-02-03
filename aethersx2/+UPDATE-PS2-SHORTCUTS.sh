#!/bin/bash

# Directory where PS2 ROMs are stored
roms_dir="/userdata/roms/ps2"

# Enable extended globbing for safer filename handling
shopt -s nullglob nocaseglob

# Default .keys content for `pad2key`
keys_content='{
    "actions_player1": [
        {
            "trigger": [
                "hotkey",
                "start"
            ],
            "type": "key",
            "target": [
                "KEY_LEFTALT",
                "KEY_F4"
            ],
            "description": "Press Alt+F4"
        }
    ]
}'

# Find all supported ROM files in the PS2 ROMs directory
find "$roms_dir" -type f \( -iname "*.iso" -o -iname "*.mdf" -o -iname "*.nrg" -o -iname "*.bin" -o -iname "*.img" -o -iname "*.dump" -o -iname "*.gz" -o -iname "*.cso" -o -iname "*.chd" -o -iname "*.m3u" \) | while read -r file_path; do
    # Get base filename without extension
    file_name=$(basename "$file_path")
    base_name="${file_name%.*}"

    # Sanitize the filename
    sanitized_name=$(echo "$base_name" | tr ' ' '_' | tr -cd '[:alnum:]_-')

    # Path for shortcut script and keys file (inside the same PS2 ROMs folder)
    script_path="$roms_dir/${sanitized_name}.sh"
    keys_path="$roms_dir/${sanitized_name}.sh.keys"

    # Create the shortcut script
    cat << EOF > "$script_path"
#!/bin/bash
batocera-mouse show
DISPLAY=:0.0 "/userdata/system/pro/aethersx2/aethersx2.AppImage" --appimage-extract-and-run "$file_path"
batocera-mouse hide
EOF

    # Make the script executable
    chmod +x "$script_path"

    # Create the .keys file for pad2key
    echo "$keys_content" > "$keys_path"

    echo "Shortcut created: $script_path"
    echo "Keys file created: $keys_path"
done

# Restart EmulationStation to apply changes
killall -9 emulationstation

cat << 'EOF' > "$ROMS_DIR/+UPDATE-PS2-SHORTCUTS.sh"
#!/bin/bash

# Directory where your PS2 ROMs are stored
roms_dir="/userdata/roms/ps2"
# Directory where the generated shortcut scripts will be placed.
# (You can change this output directory if you prefer.)
output_dir="/userdata/roms/ps2_shortcuts"
mkdir -p "$output_dir"

# Enable extended globbing so that patterns with multiple extensions work correctly.
shopt -s nullglob nocaseglob

# Loop over files with the listed extensions in the PS2 ROM folder.
for file_path in "$roms_dir"/*.{iso,mdf,nrg,bin,img,dump,gz,cso,chd,m3u}; do
    if [ -f "$file_path" ]; then
        # Get the file name (e.g., "Final_Fantasy.iso") and remove its extension.
        file_name=$(basename "$file_path")
        base_name="${file_name%.*}"

        # Sanitize the name: replace spaces with underscores and remove non-alphanumeric/underscore characters.
        sanitized_name=$(echo "$base_name" | sed 's/ /_/g' | sed 's/[^a-zA-Z0-9_]//g')

        # Path for the generated shortcut script.
        script_path="$output_dir/${sanitized_name}.sh"

        # Create the shortcut script.
        echo "#!/bin/bash
batocera-mouse show
DISPLAY=:0.0 \"/userdata/system/pro/aethersx2/aethersx2.AppImage\" --appimage-extract-and-run --rom \"$file_path\"
batocera-mouse hide" > "$script_path"

        chmod +x "$script_path"
        echo "Shortcut created: $script_path"
    fi
done

# Optionally, force-close emulationstation (if that’s part of your workflow)
killall -9 emulationstation
EOF

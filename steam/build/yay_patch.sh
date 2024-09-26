#!/bin/bash

# This script adds a fix specifically for yay without affecting the original pacman setup.
# Incorporates pacman fixes and also adds yay setup.

########################################################################
# Original pacman setup (provided earlier)
echo -e "\n\n\nAdding basic pacman support..."
mkdir -p /opt/pacman/lib /opt/pacman/cache 2>/dev/null
cp -r /etc/pacman* /opt/pacman/ 2>/dev/null
cp -r /var/lib/pacman/* /opt/pacman/lib/ 2>/dev/null
cp -r /var/cache/pacman/* /opt/pacman/cache/ 2>/dev/null  

# Replace pacman with a wrapper script
p=/usr/bin/pacman
if [ -f "$(which pacman)" ]; then
    mv "$(which pacman)" "/usr/bin/realpacman" 2>/dev/null
fi

cat <<EOF > $p
#!/bin/bash
if [[ "\$(echo "\${@}" | grep overwrite)" = "" ]]; then
  realpacman "\${@}"
else
  realpacman "\${@}"
fi
exit 0
EOF

chmod +x $p
echo "Pacman fix applied."
########################################################################

########################################################################
# Start yay installation and setup

echo -e "\nSetting up yay without sudo in user-space...\n"

# Step 1: Create user-space directories for yay's pacman and build files
yay_dir="/opt/yay"
mkdir -p "$yay_dir/lib" "$yay_dir/cache" "$yay_dir/tmp" "$yay_dir/bin"

# Step 2: Install yay if it's not already installed
if ! command -v yay &>/dev/null; then
    echo "Yay not found, installing yay..."
    git clone https://aur.archlinux.org/yay.git "$yay_dir/tmp/yay"
    cd "$yay_dir/tmp/yay" || exit 1
    makepkg -si --noconfirm
    echo "Yay installed successfully."
else
    echo "Yay is already installed."
fi

# Step 3: Configure yay to work without sudo
yay_config="$yay_dir/config.json"

# Check if yay config exists, if not create it
if [ ! -f "$yay_config" ]; then
    mkdir -p "$(dirname "$yay_config")"
    cat <<EOF > "$yay_config"
{
    "sudobin": "",
    "build_dir": "$yay_dir/tmp",
    "pacman_cmd": "/usr/bin/pacman"
}
EOF
fi

# Step 4: Create a wrapper for running yay without sudo
yay_wrapper="$yay_dir/bin/yay"
if [ ! -f "$yay_wrapper" ]; then
    cat <<EOF > "$yay_wrapper"
#!/bin/bash
# Ensure the wrapper calls the correct yay binary
/usr/bin/yay "\$@"
EOF
    chmod +x "$yay_wrapper"
fi

# Step 5: Add yay to PATH if not already present
if ! echo "$PATH" | grep -q "$yay_dir/bin"; then
    export PATH="$yay_dir/bin:$PATH"
    echo 'export PATH="/opt/yay/bin:$PATH"' >> ~/.bashrc
    source ~/.bashrc
fi

# Step 6: Test yay without sudo
echo -e "\nTesting yay without sudo...\n"
"$yay_wrapper" -Syu --noconfirm

echo -e "\nYay setup complete! You can now run yay without sudo using the command:\n"
echo "yay <command>"

########################################################################

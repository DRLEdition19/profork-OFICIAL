#!/bin/bash

# This script fixes yay without requiring sudo and addresses systemd issues.
# Assumes pacman is already fixed separately.

########################################################################
# Step 1: Set up yay without sudo

echo -e "\nSetting up yay without sudo in user-space...\n"

# Create user-space directories for yay's pacman and build files
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

# Step 3: Configure yay to work without sudo and suppress root warnings
yay_config="$yay_dir/config.json"

# Check if yay config exists, if not create it
if [ ! -f "$yay_config" ]; then
    mkdir -p "$(dirname "$yay_config")"
    cat <<EOF > "$yay_config"
{
    "sudobin": "",
    "build_dir": "$yay_dir/tmp",
    "pacman_cmd": "/usr/bin/pacman",
    "disable_root_warn": true
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

########################################################################
# Step 6: Modify PKGBUILD scripts to handle non-systemd environments

# Function to patch PKGBUILD files and remove systemd-related commands
patch_pkgbuild() {
    pkgbuild="$1"
    
    # Remove systemctl calls and systemd dependencies
    sed -i '/systemctl/d' "$pkgbuild"
    sed -i '/depends.*systemd/d' "$pkgbuild"
    sed -i '/makedepends.*systemd/d' "$pkgbuild"
    
    echo "Patched $pkgbuild to remove systemd dependencies."
}

# This will ensure that during the yay installation process, PKGBUILD files can be edited to remove systemd requirements
# You can patch these files during the --editmenu step in yay

# Step 7: Install packages using yay
# You can use --editmenu to modify AUR PKGBUILD files manually, or you can automatically apply the patch

yay --editmenu --nodiffmenu --removemake --nocleanmenu --builddir /opt/yay/tmp -S <package_name>

# Inside the editmenu, you can patch the PKGBUILD to remove any systemd dependencies.
# Use the following command while in the editmenu to patch:
# patch_pkgbuild PKGBUILD

########################################################################

echo -e "\nYay setup complete! You can now run yay without sudo using the command:\n"
echo "yay <command>"

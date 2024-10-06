#!/bin/bash



sleep 3
echo "pulling Yuzu again to fix lib error..."
sleep 2
echo ""
echo ""
# Download Linux-Yuzu-EA-4176.AppImage and rename to yuzuEA.AppImage, then make it executable
wget -O "/userdata/system/switch/yuzuEA.AppImage" https://archive.org/download/yuzu_emulator_builds/yuzu/pineapple-src%20EA-4176/Linux-Yuzu-EA-4176.AppImage
chmod +x "/userdata/system/switch/yuzuEA.AppImage"
# Download yuzu-mainline-20240304-537296095.AppImage and rename to yuzu.AppImage, then make it executable
wget -O "/userdata/system/switch/yuzu.AppImage" https://archive.org/download/yuzu-emulator-latest-builds-4032024/yuzu-mainline-20240304-537296095.AppImage
chmod +x "/userdata/system/switch/yuzu.AppImage"

#!/bin/bash

# Find Chromium
CHROMIUM_DIR="$(/bin/sh ./find-chromium.sh)"
if [ -z "$CHROMIUM_DIR" ]; then
	exit 1
fi

# Get Widevine archive
#./fetch-latest-widevine.sh -o ./widevine.zip
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O google-chrome-stable_current_amd64.deb
ar xv google-chrome-stable_current_amd64.deb
rm -f google-chrome-stable_current_amd64.deb
rm -f debian-binary
rm -f control.tar.xz
xz -d data.tar.xz
tar -xvf data.tar
rm -f data.tar.xz data.tar
rm -rf usr etc
mv opt/google/chrome/WidevineCdm/* ./
rm -rf opt

# Extract Widevine and recreate this directory structure under the Chromium directory:
#	  /usr/lib/chromium/WidevineCdm
#	  ├── LICENSE
#	  ├── manifest.json
#	  └── _platform_specific
#		  └── linux_x64
#				└── libwidevinecdm.so
sudo rm -rf "$CHROMIUM_DIR/WidevineCdm/"
sudo mkdir -p "$CHROMIUM_DIR/WidevineCdm/_platform_specific/linux_x64"
sudo cp LICENSE "${CHROMIUM_DIR}/WidevineCdm/"
sudo cp manifest.json "${CHROMIUM_DIR}/WidevineCdm/"
sudo cp _platform_specific/linux_x64/libwidevinecdm.so "$CHROMIUM_DIR/WidevineCdm/_platform_specific/linux_x64/"
rm -rf LICENSE
rm -rf manifest.json
rm -rf _platform_specific
#unzip -p widevine.zip LICENSE.txt | sudo dd status=none of="${CHROMIUM_DIR}/WidevineCdm/LICENSE"
#unzip -p widevine.zip manifest.json | sudo dd status=none of="${CHROMIUM_DIR}/WidevineCdm/manifest.json"
#unzip -p widevine.zip libwidevinecdm.so | sudo dd status=none of="${CHROMIUM_DIR}/WidevineCdm/_platform_specific/linux_x64/libwidevinecdm.so"
find "$CHROMIUM_DIR/WidevineCdm" -type d -exec sudo chmod 0755 '{}' \;
find "$CHROMIUM_DIR/WidevineCdm" -type f -exec sudo chmod 0644 '{}' \;

# clean up
#rm ./widevine.zip

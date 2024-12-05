#! /bin/bash

set -e

sudo mkdir /opt/bitwarden

sudo wget 'https://vault.bitwarden.com/download/?app=desktop&platform=linux' -O /opt/bitwarden/bitwarden.AppImage
sudo wget 'https://raw.githubusercontent.com/bitwarden/brand/e755957e1ae5b84521a4a2491b791e743936af1a/icons/128x128.png' -O /opt/bitwarden/bitwarden.png

cat << EOF | sudo tee /usr/share/applications/bitwarden.desktop
[Desktop Entry]
Version=1.0
Icon=/opt/bitwarden/bitwarden.png
Terminal=false
Type=Application
Name=Bitwarden
Exec=/opt/bitwarden/bitwarden.AppImage

EOF

sudo chmod +x /opt/bitwarden/bitwarden.AppImage
sudo chmod +x /usr/share/applications/bitwarden.desktop
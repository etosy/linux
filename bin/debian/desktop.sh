#!/bin/bash
# debian gnome desktop setup

set -e

# turn of bluetooth
# nautilus items count show
# gnome-text-editor disable restore
# chrome keyring
# set default browser
# replace kitty with gnome-terminal
# gnome-terminal show bold colors
# hindi font
# gnome-termianl size 170 x 24

sudo test || true

PROJECT_ROOT="../.."
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TEMP_DIR=$PROJECT_ROOT/tmp

THIS_SCRIPT=$(basename "$0")
echo "running: $THIS_SCRIPT"

# Check if the system is Debian-based
if ! grep -q "^ID=debian" /etc/os-release; then
	echo "$THIS_SCRIPT is intended for Debian-based distributions only. Exiting."
	exit 1
fi

# exit if temp folder exist
if [ -d "$TEMP_DIR" ]; then
    echo "Please remove '$TEMP_DIR' to proceed."
    exit 1
fi

# Check for internet connectivity
if ! ping -c 1 9.9.9.9 > /dev/null 2>&1; then
    echo "No internet connection. Exiting..."
    exit 1
fi

$PROJECT_ROOT/debian/comment_deb_src.sh

$PROJECT_ROOT/debian/repo/add_repo_google.sh

sudo apt update

# install core packages
sudo apt install -y gnome-session --no-install-recommends --no-install-suggests gdm3 kitty network-manager wpasupplicant dbus-x11 wget curl vim

# install daily use packages
sudo apt install -y gnome-control-center nautilus mpv eog evince gnome-text-editor gnome-disk-utility gnome-system-monitor fonts-mlym firefox-esr

# install third party repo if any
sudo apt install -y google-chrome-stable

$PROJECT_ROOT/debian/fix_wifi.sh

$PROJECT_ROOT/gnome/gsettings_host.sh

# setup firefox profile
if [ ! -d "$TEMP_DIR" ]; then
    mkdir -p "$TEMP_DIR"
    echo "Directory '$TEMP_DIR' has been created."
fi

cd $TEMP_DIR
git clone https://github.com/celestinediask/firefox
cd firefox
./remove_bloat.sh

# import config
cd $PROJECT_ROOT/config
cp -i vimrc ~/.vimrc

cd $SCRIPT_DIR

echo "All done! If finished you may reboot to new system."

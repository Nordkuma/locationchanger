#!/bin/bash

INSTALL_DIR=/usr/local/bin
SCRIPT_NAME=locationchanger
LAUNCH_AGENTS_DIR=$HOME/Library/LaunchAgents
PLIST_NAME=$LAUNCH_AGENTS_DIR/LocationChanger.plist
APP_SUPPORT_DIR="$HOME/.locations" #/Library/Application Support/LocationChanger"



function copyScript() {
  echo "Copying script and making it executable"
  sudo chmod +x ${SCRIPT_NAME}
  sudo cp "$SCRIPT_NAME" "$INSTALL_DIR"
}


# generate a default config file if it doesn't exists
function copyConfig() {
  mkdir -p "${APP_SUPPORT_DIR}"
  echo "Copying Config"
  cp LocationChanger.conf "$APP_SUPPORT_DIR"
}

function copyPlist() {
  if [ ! -e "${LAUNCH_AGENTS_DIR}/LocationChanger.plist" ] || [ "$1" == "-f" ]; then
    mkdir -p "${LAUNCH_AGENTS_DIR}"
    echo "Copying Plist"
    cp LocationChanger.plist "$LAUNCH_AGENTS_DIR"
  fi

  launchctl load ${PLIST_NAME}

}

sudo -v
if [[ "$1" == "-p" ]]; then
  copyPlist
  exit 0
fi

if [ -e "${APP_SUPPORT_DIR}/LocationChanger.conf" ]; then
  echo "Existing config found. Do you want to overwrite it? (y/n)"
  read reply
  if [ "$reply" = "y" ]; then
    copyConfig
  fi
else
  copyConfig
fi

copyPlist

echo "Installation complete."

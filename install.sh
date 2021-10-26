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

function copyConfig() {
  mkdir -p "${APP_SUPPORT_DIR}"
  echo "Copying Config"
  cp LocationChanger.conf "$APP_SUPPORT_DIR"
}

function copyPlist() {
  mkdir -p "${LAUNCH_AGENTS_DIR}"
  echo "Copying Plist"
  cp LocationChanger.plist "$LAUNCH_AGENTS_DIR"

  launchctl load ${PLIST_NAME}
}

case $1 in
  "-p" | "plist" )
    copyPlist
    exit 0
    ;;
  "-s" | "script" )
    copyScript
    exit 0
    ;;
  "-c" | "config" )
    copyConfig
    exit 0
    ;;
  "-o" | "open" )
    case $2 in
      "plist" )
        open -R $PLIST_NAME
        ;;
      "conf" )
        open -R $APP_SUPPORT_DIR
        ;;
    esac
    exit 0
    ;;
  *)
  sudo -v
  copyScript
  if [ ! -e "${LAUNCH_AGENTS_DIR}/LocationChanger.plist" ]; then
    copyPlist
  fi
  ;;
esac

if [ -e "${APP_SUPPORT_DIR}/LocationChanger.conf" ]; then
  echo "Existing config found. Do you want to overwrite it? (y/n)"
  read reply
  if [ "$reply" = "y" ]; then
    copyConfig
  fi
else
  copyConfig
fi

echo "Installation complete."

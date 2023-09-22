#!/bin/bash

INSTALL_DIR="/usr/local/bin"
SCRIPT_FILE="locationchanger"
LAUNCH_AGENTS_DIR="${HOME}/Library/LaunchAgents"
PLIST_FILE="${LAUNCH_AGENTS_DIR}/LocationChanger.plist"
DOTFILE_DIR="${HOME}/.locationchanger"

function copyScript() {
  echo "Copying script and making it executable"
  sudo chmod +x "$SCRIPT_FILE"
  sudo cp "$SCRIPT_FILE" "$INSTALL_DIR"
}

function copyConfig() {
  mkdir -p "$DOTFILE_DIR"
  echo "Copying Config"
  cp "LocationChanger.conf" "$DOTFILE_DIR"
}

function copyPlist() {
  sudo -v
  mkdir -p "$LAUNCH_AGENTS_DIR"
  echo "Copying Plist"
  sudo chmod 664 "LocationChanger.plist"
  cp "LocationChanger.plist" "$LAUNCH_AGENTS_DIR"

  launchctl unload "$PLIST_FILE"
  launchctl load "$PLIST_FILE"
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
        open -R "$PLIST_FILE"
        ;;
      "conf" )
        open -R "$DOTFILE_DIR"
        ;;
    esac
    exit 0
    ;;
  *)
  copyScript
  if [ ! -e "${LAUNCH_AGENTS_DIR}/LocationChanger.plist" ]; then
    copyPlist
  fi
  ;;
esac

if [ -e "${DOTFILE_DIR}/LocationChanger.conf" ]; then
  echo "Existing config found. Do you want to overwrite it? (y/n)"
  read reply
  if [ "$reply" = "y" ]; then
    copyConfig
  fi
else
  copyConfig
fi

echo "Installation complete."

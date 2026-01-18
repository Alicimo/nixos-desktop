#!/usr/bin/env bash
set -euo pipefail

OSX_AIRPORT="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport"

detect_os() {
  case "$(uname -s)" in
    Darwin) echo "mac";;
    Linux)  echo "linux";;
    *)      echo "unknown";;
  esac
}

toggle_mac() {
  # macOS toggling via networksetup
  networksetup -setairportpower en0 off || true
  sleep 1
  networksetup -setairportpower en0 on
}

toggle_linux() {
  # Generic fallback for Linux systems
  sudo systemctl restart wpa_supplicant || {
    echo "Unable to restart wpa_supplicant; try: sudo rfkill block/unblock wifi"
    exit 1
  }
}

OS="$(detect_os)"

case "$OS" in
  mac)
    toggle_mac
    ;;
  linux)
    toggle_linux
    ;;
  *)
    echo "Wi-Fi toggle not supported on this OS."
    exit 1
    ;;
esac

#!/usr/bin/env bash
set -e

# -------- CONFIG --------
KEYRING="/usr/share/keyrings/signal-desktop-keyring.gpg"
SOURCES="/etc/apt/sources.list.d/signal-desktop.sources"
KEY_URL="https://updates.signal.org/desktop/apt/keys.asc"
SOURCES_URL="https://updates.signal.org/static/desktop/apt/signal-desktop.sources"

# -------- CHECKS --------
if [[ "$(uname -m)" != "x86_64" ]]; then
  echo "❌ Signal Desktop repo only supports 64-bit systems."
  exit 1
fi

if ! command -v apt >/dev/null; then
  echo "❌ This system does not use APT."
  exit 1
fi

echo "✅ Installing / updating Signal Desktop…"

echo "Removing old APT sources lists ..."
sudo rm -vf /etc/apt/sources.list.d/signal*

# -------- KEY --------
if [[ ! -f "$KEYRING" ]]; then
  echo "🔑 Adding Signal signing key..."
  curl -fsSL "$KEY_URL" | gpg --dearmor | sudo tee "$KEYRING" > /dev/null
else
  echo "🔑 Signing key already present."
fi

# -------- REPO --------
if [[ ! -f "$SOURCES" ]]; then
  echo "📦 Adding Signal repository..."
  curl -fsSL "$SOURCES_URL" | sudo tee "$SOURCES" > /dev/null
else
  echo "📦 Repository already present."
fi

# -------- INSTALL --------
echo "⬇️ Updating package list..."
sudo apt update

echo "⬆️ Installing / upgrading Signal Desktop..."
sudo apt install -y signal-desktop

echo "🎉 Signal Desktop is up to date."

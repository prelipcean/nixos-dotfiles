#!/usr/bin/env bash
# Sync NixOS configurations from system to git repository

set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
NIXOS_DIR="/etc/nixos"
HOMEMANAGER_DIR="$HOME/.config/home-manager"

echo "Syncing NixOS configurations..."

# Backup current git state
if git -C "$REPO_DIR" status --porcelain | grep -q .; then
    echo "⚠️  Repository has uncommitted changes. Stashing first..."
    git -C "$REPO_DIR" stash
fi

# Sync NixOS config
echo "📋 Syncing NixOS configuration..."
sudo cp "$NIXOS_DIR/configuration.nix" "$REPO_DIR/nixos/configuration.nix"
sudo cp "$NIXOS_DIR/hardware-configuration.nix" "$REPO_DIR/nixos/hardware-configuration.nix"
sudo chown <USERNAME>:users "$REPO_DIR/nixos/"*.nix  # Change to your username

# Sync home-manager config
echo "🏠 Syncing home-manager configuration..."
cp "$HOMEMANAGER_DIR/home.nix" "$REPO_DIR/home-manager/home.nix"

# Check for changes
echo ""
echo "📊 Changes detected:"
git -C "$REPO_DIR" diff --stat

# Ask to commit
echo ""
read -p "Commit changes? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    read -p "Commit message: " message
    git -C "$REPO_DIR" add -A
    git -C "$REPO_DIR" commit -m "$message"
    echo "✅ Committed successfully"

    read -p "Push to remote? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git -C "$REPO_DIR" push
        echo "✅ Pushed successfully"
    fi
else
    echo "❌ Skipped commit"
fi

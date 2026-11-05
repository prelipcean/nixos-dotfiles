# NixOS Configuration Repository

Personal NixOS and home-manager configurations for managing my development environment declaratively.

**System:** NixOS 26.05 (Yarara)  
**User:** `<USERNAME>` (`<YOUR_NAME>`)  
**Updated:** November 2026  
**Note:** Replace placeholders with your actual values

## Overview

This repository contains all the declarative configuration for:
- **System-wide settings** (`nixos/configuration.nix`)
- **Hardware configuration** (`nixos/hardware-configuration.nix`)
- **User environment** (`home-manager/home.nix`)

Everything is version-controlled for easy backup, recovery, and reproducibility.

## Repository Structure

```
dotfiles/
├── nixos/
│   ├── configuration.nix          # System-wide settings
│   └── hardware-configuration.nix # Hardware-specific config
├── home-manager/
│   └── home.nix                   # User environment & packages
├── .github/
│   └── workflows/                 # GitHub Actions (optional)
├── SETUP.md                       # How to use this repo
└── README.md                      # This file
```

## Quick Start

### Clone to New System

```bash
git clone <repo-url> ~/dotfiles
cd ~/dotfiles

# Copy system config
sudo cp nixos/configuration.nix /etc/nixos/
sudo cp nixos/hardware-configuration.nix /etc/nixos/

# Apply system config
sudo nixos-rebuild switch

# Apply home-manager config
home-manager switch
```

### After System Changes

```bash
# Update configs from system
sudo cp /etc/nixos/configuration.nix nixos/
sudo cp /etc/nixos/hardware-configuration.nix nixos/
cp ~/.config/home-manager/home.nix home-manager/

# Commit changes
git add -A
git commit -m "Update system config"
git push
```

## What's Included

### System (nixos/configuration.nix)
- ✅ ZSH shell (default login shell)
- ✅ KDE Plasma 6 desktop
- ✅ NetworkManager
- ✅ PipeWire audio
- ✅ CUPS printing
- ✅ Unfree packages allowed
- ✅ Bootloader: systemd-boot with EFI

### User Environment (home-manager/home.nix)
- ✅ **Terminal:** Kitty (with Catppuccin theme)
- ✅ **Shell:** ZSH (with plugins)
- ✅ **Prompt:** Starship
- ✅ **Tools:** Zoxide, FZF, Tmux, Neovim
- ✅ **Viewers:** Glow, Bat, Pandoc
- ✅ **Knowledge Base:** Obsidian, Emacs
- ✅ **Development:** Git, Node.js, Python (configurable)
- ✅ **Utilities:** ripgrep, fd, eza, tldr

## Usage

### Rebuild System

```bash
# After editing nixos/configuration.nix
sudo nixos-rebuild switch

# Or test first (doesn't activate)
sudo nixos-rebuild test

# Or build bootloader entry (can rollback)
sudo nixos-rebuild boot
```

### Update Home-Manager

```bash
# After editing home-manager/home.nix
home-manager switch

# Or test first
home-manager build
```

### Version Control Workflow

```bash
# Make changes
nvim home-manager/home.nix

# Test changes
home-manager switch

# If happy, commit
git add home-manager/home.nix
git commit -m "Add new package to home-manager"
git push
```

## System Information

- **NixOS Version:** 26.05 (Yarara)
- **Kernel:** Linux (latest stable)
- **Desktop:** KDE Plasma 6
- **Shell:** Zsh 5.9.1
- **Terminal:** Kitty 0.26.1+
- **Editor:** Neovim

## Useful Commands

```bash
# Search for packages
nix search <package-name>

# Show system generation history
sudo nixos-rebuild list-generations

# Rollback to previous generation
sudo nixos-rebuild switch --rollback

# Update nixpkgs
sudo nix-channel --update
sudo nixos-rebuild switch

# Update home-manager
home-manager switch

# Clean up old packages
nix-collect-garbage --delete-old
nix-store --gc
```

## Customization

### Adding a Package

Edit `home-manager/home.nix`:

```nix
home.packages = with pkgs; [
  # Existing packages...
  new-package    # Add here
];
```

Then apply:
```bash
home-manager switch
```

### Changing System Settings

Edit `nixos/configuration.nix` and apply:

```bash
sudo nvim /etc/nixos/configuration.nix
# OR edit local copy and copy to /etc/nixos/
sudo cp nixos/configuration.nix /etc/nixos/
sudo nixos-rebuild switch
```

## Backup & Recovery

### Backup System

```bash
# Backup entire /etc/nixos
sudo cp -r /etc/nixos ~/dotfiles/nixos-backup-$(date +%Y%m%d)

# Backup home-manager
cp ~/.config/home-manager/home.nix ~/dotfiles/home-backup-$(date +%Y%m%d).nix
```

### Recover System

```bash
# Restore from git
git checkout <commit-hash> -- nixos/

# Copy to system
sudo cp nixos/configuration.nix /etc/nixos/

# Rebuild
sudo nixos-rebuild switch
```

## Troubleshooting

### Changes not applying

```bash
# Clear home-manager cache
rm -rf ~/.cache/home-manager
home-manager switch

# For system changes
sudo nixos-rebuild switch --show-trace
```

### Package not found

```bash
# Update nixpkgs
sudo nix-channel --update

# Search for package name
nix search <name>

# Add to config and try again
home-manager switch
```

### Rebuild fails

```bash
# Show detailed error
sudo nixos-rebuild switch --show-trace 2>&1 | tail -50

# Check syntax
nix-instantiate nixos/configuration.nix
nix-instantiate home-manager/home.nix
```

## Resources

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Home-Manager Manual](https://nix-community.github.io/home-manager/)
- [Nixpkgs Search](https://search.nixos.org/packages)
- [NixOS Options](https://search.nixos.org/options)

## License

Personal configuration - use as reference, not as-is.

## Notes

- `hardware-configuration.nix` is generated by NixOS installer, don't edit manually
- Always test changes with `--build` or `test` before applying
- Keep git history for easy rollbacks
- Document why changes were made in commit messages

---

**Last Updated:** November 6, 2026  
**Maintainer:** Gheorghe Prelipcean

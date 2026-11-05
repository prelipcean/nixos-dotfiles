# Setting Up NixOS from This Repository

Complete guide to restore your NixOS environment from this git repository.

## Table of Contents

1. [Fresh NixOS Installation](#fresh-nixos-installation)
2. [Restore from Repository](#restore-from-repository)
3. [Update and Maintain](#update-and-maintain)
4. [Daily Workflow](#daily-workflow)

---

## Fresh NixOS Installation

### Step 1: Install NixOS

```bash
# Boot from NixOS live USB
# Follow standard NixOS installation
# Important: Note your hardware UUID

# During installation, generate hardware config
sudo nixos-generate-config --root /mnt
```

### Step 2: Clone Repository

```bash
# Boot into new system
# Clone this repository
git clone https://github.com/your-user/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### Step 3: Update Hardware Config

```bash
# Your hardware config is unique to your machine
# Copy from your new system
sudo cp /etc/nixos/hardware-configuration.nix nixos/hardware-configuration.nix

# OR copy the hardware config you backed up
sudo cp nixos/hardware-configuration.nix-backup /etc/nixos/hardware-configuration.nix
```

### Step 4: Apply Configuration

```bash
# Copy system config
sudo cp nixos/configuration.nix /etc/nixos/

# Rebuild system
sudo nixos-rebuild switch

# Apply home-manager
home-manager switch

# Reboot
sudo reboot
```

### Step 5: Verify Everything

```bash
# Check system
nixos-version
uname -a

# Check home-manager
home-manager --version
ls ~/.nix-profile/bin

# Verify tools
zsh --version
starship --version
glow --version
```

---

## Restore from Repository

### Quick Restore (Existing System)

If you have NixOS already installed but want to restore from this repo:

```bash
# Clone repo
git clone <repo-url> ~/dotfiles
cd ~/dotfiles

# Backup current config first
sudo cp /etc/nixos/configuration.nix /etc/nixos/configuration.nix.backup
cp ~/.config/home-manager/home.nix ~/.config/home-manager/home.nix.backup

# Copy configurations
sudo cp nixos/configuration.nix /etc/nixos/
cp home-manager/home.nix ~/.config/home-manager/

# Rebuild
sudo nixos-rebuild switch
home-manager switch

# Reboot
sudo reboot
```

### If Something Breaks

```bash
# Restore from backup
sudo cp /etc/nixos/configuration.nix.backup /etc/nixos/configuration.nix
sudo nixos-rebuild switch

# Rollback to previous generation
sudo nixos-rebuild --rollback switch
```

---

## Update and Maintain

### Regular Updates

```bash
# Update channel
sudo nix-channel --update
home-manager switch --flake

# Rebuild
sudo nixos-rebuild switch

# Clean garbage
nix-collect-garbage --delete-old
```

### Add New Package

```bash
# Edit home-manager config
nvim home-manager/home.nix

# Add to home.packages:
# home.packages = with pkgs; [
#   new-package
# ];

# Apply
home-manager switch

# If satisfied, commit
git add home-manager/home.nix
git commit -m "Add new-package to home environment"
git push
```

### Update System Settings

```bash
# Edit NixOS config
sudo nvim /etc/nixos/configuration.nix

# Test build
sudo nixos-rebuild test

# If good, switch
sudo nixos-rebuild switch

# Backup to repo
sudo cp /etc/nixos/configuration.nix nixos/
git add nixos/configuration.nix
git commit -m "Update system configuration"
git push
```

---

## Daily Workflow

### Making Changes

```bash
# Make a change
nvim ~/.config/home-manager/home.nix

# Test it
home-manager switch

# View what changed
git diff home-manager/home.nix

# Commit to version control
git add home-manager/home.nix
git commit -m "Descriptive commit message"
git push
```

### System Configuration Changes

```bash
# Edit local copy first
nvim nixos/configuration.nix

# Copy to system
sudo cp nixos/configuration.nix /etc/nixos/

# Test build (doesn't activate)
sudo nixos-rebuild test

# Apply changes
sudo nixos-rebuild switch

# Commit to git
git add nixos/configuration.nix
git commit -m "Update system config: added X service"
git push
```

### Checking Status

```bash
# Current generation number
sudo nixos-rebuild list-generations | head -5

# Home-manager status
home-manager status

# Check git status
git status
git log --oneline -5
```

---

## Important Notes

### Don't Edit These Directly

```bash
# hardware-configuration.nix is auto-generated
# Only change if switching to different hardware
sudo nixos-generate-config --root /

# Then update your git repo
sudo cp /etc/nixos/hardware-configuration.nix \
  ~/dotfiles/nixos/hardware-configuration.nix
```

### File Locations

| File | Location |
|------|----------|
| NixOS config | `/etc/nixos/configuration.nix` |
| Hardware config | `/etc/nixos/hardware-configuration.nix` |
| Home-manager config | `~/.config/home-manager/home.nix` |
| Git repo | `~/dotfiles/` |

### Syncing Configs

Always keep repo in sync with system:

```bash
# After system changes
sudo cp /etc/nixos/configuration.nix ~/dotfiles/nixos/
cp ~/.config/home-manager/home.nix ~/dotfiles/home-manager/

# Then commit
git add -A
git commit -m "Sync configurations from system"
```

---

## Useful Commands Reference

```bash
# System Management
sudo nixos-rebuild switch              # Apply and activate
sudo nixos-rebuild test                # Test without activating
sudo nixos-rebuild boot                # Apply for next boot
sudo nixos-rebuild switch --rollback   # Rollback to previous

# Home-Manager
home-manager switch                    # Apply changes
home-manager build                     # Test build
home-manager generations               # List generations
home-manager remove-generations -d 3   # Keep last 3

# Packages
nix search package-name                # Search packages
nix-env -qa                            # List all packages
nix-store --verify --repair=all        # Repair store

# Cleanup
nix-collect-garbage --delete-old       # Delete old generations
nix-store --gc                         # Garbage collect
```

---

## Troubleshooting

### Error: "conflicting configuration"

```bash
# Check what's conflicting
git diff nixos/configuration.nix
git diff home-manager/home.nix

# Resolve conflicts, then
git add .
git commit -m "Resolved conflicts"
```

### Error: "package not found"

```bash
# Update nixpkgs
sudo nix-channel --update

# Search for correct name
nix search package-name

# Update home.nix with correct name
home-manager switch
```

### System won't boot after update

```bash
# Boot into previous generation from bootloader menu
# Then rollback
sudo nixos-rebuild --rollback switch
```

---

## Recovery Scenarios

### Recover from Backup

```bash
# If you have backup of configurations
git log --oneline

# Checkout specific commit
git checkout <commit-hash> -- nixos/configuration.nix
git checkout <commit-hash> -- home-manager/home.nix

# Apply
sudo cp nixos/configuration.nix /etc/nixos/
home-manager switch
```

### Complete System Recovery

```bash
# From live USB
sudo nixos-install --root /mnt --flake ~/dotfiles#<USERNAME>  # Replace with your username

# Or manual steps
sudo cp nixos/configuration.nix /mnt/etc/nixos/
sudo cp nixos/hardware-configuration.nix /mnt/etc/nixos/
sudo nixos-install --root /mnt
```

---

## Next Steps

1. ✅ Clone/copy repository
2. ✅ Verify hardware-configuration.nix
3. ✅ Apply system configuration
4. ✅ Apply home-manager configuration
5. ✅ Test all tools work
6. ✅ Create initial commit
7. ✅ Push to remote

---

**For more help:** Check README.md and individual configuration files

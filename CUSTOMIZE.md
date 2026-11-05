# Customization Guide

This repository uses placeholders for personal data. Replace them with your values before using.

## Placeholders to Replace

### `<USERNAME>`
Your NixOS username (usually lowercase, no spaces)

**Files to update:**
- `nixos/configuration.nix` (line ~94)
- `home-manager/home.nix` (line ~4)
- `scripts/sync-config.sh` (line ~20)
- `SETUP.md` (multiple locations)

**Example:**
```bash
# Find all instances
grep -r "<USERNAME>" .

# Replace (macOS/Linux)
sed -i 's/<USERNAME>/myusername/g' nixos/configuration.nix
sed -i 's/<USERNAME>/myusername/g' home-manager/home.nix

# Or manually edit each file
```

### `<YOUR_NAME>`
Your full name for git commits and system description

**Files to update:**
- `nixos/configuration.nix` (line ~96)
- `home-manager/home.nix` (line ~201)
- `README.md` (line ~6)

**Example:**
```nix
description = "John Doe";
user.name = "John Doe";
```

### `<YOUR_EMAIL>`
Your email for git commits

**Files to update:**
- `home-manager/home.nix` (line ~202)

**Example:**
```nix
user.email = "john@example.com";
```

## Quick Setup Script

```bash
#!/bin/bash
# Replace all placeholders at once

USERNAME="your_username"
NAME="Your Full Name"
EMAIL="your@email.com"

cd ~/dotfiles

# Replace in all files
find . -type f -not -path './.git/*' -exec sed -i \
  -e "s/<USERNAME>/$USERNAME/g" \
  -e "s/<YOUR_NAME>/$NAME/g" \
  -e "s/<YOUR_EMAIL>/$EMAIL/g" \
  {} \;

echo "✅ Placeholders replaced!"
```

## Step-by-Step Customization

### 1. Determine Your Values

```bash
# Check your current username
whoami

# Check git config (if set)
git config user.name
git config user.email

# Or set them now
git config --global user.name "Your Name"
git config --global user.email "your@email.com"
```

### 2. Update Configuration Files

**Option A: Manual (Easiest)**

```bash
# Edit with your editor
nvim nixos/configuration.nix
nvim home-manager/home.nix

# Replace:
# <USERNAME> → your_username
# <YOUR_NAME> → Your Full Name
# <YOUR_EMAIL> → your@email.com
```

**Option B: Automated (sed)**

```bash
# Set your values
USERNAME="george"
NAME="Gheorghe Prelipcean"
EMAIL="george@example.com"

# Replace in all files
cd ~/dotfiles
sed -i "s/<USERNAME>/$USERNAME/g" nixos/configuration.nix home-manager/home.nix scripts/sync-config.sh
sed -i "s/<YOUR_NAME>/$NAME/g" nixos/configuration.nix home-manager/home.nix
sed -i "s/<YOUR_EMAIL>/$EMAIL/g" home-manager/home.nix
```

### 3. Verify Changes

```bash
# Check all placeholders are gone
grep -r "<USERNAME>\|<YOUR_NAME>\|<YOUR_EMAIL>" . --exclude-dir=.git

# Should output nothing if all replaced
```

### 4. Commit Changes

```bash
cd ~/dotfiles
git add -A
git commit -m "Customize configuration with personal values"
```

## Common Customizations

### Change Editor

In `home-manager/home.nix`, change:

```nix
# From
home.sessionVariables = {
  EDITOR = "nvim";
};

# To
home.sessionVariables = {
  EDITOR = "vim";  # or "emacs", "nano", etc
};
```

### Add/Remove Packages

In `home-manager/home.nix`, find `home.packages`:

```nix
home.packages = with pkgs; [
  # Add new packages here
  rust
  golang
  python3
];
```

### Change Theme

In `home-manager/home.nix`, kitty colors:

```nix
programs.kitty = {
  settings = {
    background = "#1e1e2e";  # Change hex color
    # ... other colors
  };
};
```

### Add System Services

In `nixos/configuration.nix`, add to services:

```nix
services.openssh.enable = true;
services.postgresql.enable = true;
# etc.
```

## Verification Checklist

After customization:

- [ ] All `<USERNAME>` replaced
- [ ] All `<YOUR_NAME>` replaced
- [ ] All `<YOUR_EMAIL>` replaced
- [ ] No `grep` results for placeholders
- [ ] Committed changes to git
- [ ] Tested rebuild: `home-manager switch`
- [ ] Tested system: `sudo nixos-rebuild test`

## If You Make a Mistake

```bash
# Undo changes
git checkout HEAD -- .

# Or restore from backup
git reset --hard HEAD~1

# Then try again
```

## Need Help?

- Check `README.md` for overview
- Check `SETUP.md` for installation
- Check individual config files for comments
- Visit https://nixos.org/manual for documentation

---

**Remember:** These are just templates. Customize them to match your system!

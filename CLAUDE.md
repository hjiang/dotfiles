# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal dotfiles repository for managing configuration files across multiple Linux and macOS machines using GNU Stow. The repository uses a host-based organization where shared configurations live in `shared/` and host-specific overrides live in hostname directories (`eos/`, `hestia/`, etc.).

## Common Commands

### Installation and Management

```bash
# Install dotfiles for current hostname
make install

# Uninstall dotfiles
make uninstall

# Download 3rd-party assets (cursor themes, wallpapers)
make download-assets
```

The `make install` command automatically:
1. Detects the current hostname
2. Uses `stow --restow` to create symlinks from `shared/` to `$HOME`
3. Uses `stow --restow` to create symlinks from `<hostname>/` to `$HOME` (host-specific overrides)

### Stow Configuration

Stow options are configured in `.stowrc`:
- Target directory: `$HOME`
- Uses `--dotfiles` mode (files prefixed with `dot-` become `.` in target)
- Uses `--no-folding` to create individual symlinks
- Uses `--verbose` for detailed output

## Repository Structure

### Directory Organization

```
dotfiles/
├── shared/              # Common configuration for all hosts
│   ├── dot-zshenv      # ZSH environment variables
│   ├── dot-zshrc       # ZSH interactive shell config
│   ├── dot-zsh_plugins.txt
│   └── dot-config/
│       ├── emacs/      # Emacs configuration
│       ├── foot/       # Foot terminal
│       ├── hypr/       # Hyprland compositor configs
│       ├── tmux/       # Tmux configuration
│       ├── waybar/     # Waybar status bar
│       └── wofi/       # Wofi launcher
├── eos/                # Host-specific configs for 'eos'
│   └── dot-config/hypr/hyprland-device.conf
├── hestia/             # Host-specific configs for 'hestia'
│   └── dot-config/hypr/hyprland-device.conf
└── Makefile
```

### Configuration Layering

The system uses a layering approach:
1. **Base layer**: `shared/` contains common configuration
2. **Override layer**: Host-specific directories contain overrides

For Hyprland, this is implemented via:
- `shared/dot-config/hypr/hyprland.conf` - Main config with `source = ./hyprland-device.conf` at the end
- `<hostname>/dot-config/hypr/hyprland-device.conf` - Device-specific overrides (monitor settings, scaling, etc.)

## Key Configurations

### Hyprland (Wayland Compositor)

Main config: `shared/dot-config/hypr/hyprland.conf`

- Configured programs: kitty (terminal), wofi (launcher), firefox (browser), emacs (editor)
- Screenshot tool: grim + slurp + satty
- Autostart services: gentoo-pipewire-launcher, fcitx5, hyprpolkitagent, hypridle, hyprpaper, waybar, dunst
- Uses rose-pine-hyprcursor theme
- Workspace assignments for firefox, emacs, terminals, Slack, Element
- Opacity settings for various applications
- Device-specific configs sourced from `./hyprland-device.conf`

Related configs:
- `hyprlock.conf` - Screen locker
- `hypridle.conf` - Idle management
- `hyprpaper.conf` - Wallpaper daemon

### ZSH Environment

`shared/dot-zshenv` sets up:
- XDG base directories
- Homebrew initialization (Linux and macOS)
- ASDF version manager (multiple installation methods)
- GNU tools from Homebrew (grep, sed)
- LLVM from Homebrew
- TeX Live
- PostgreSQL@17
- Cargo/Rust environment
- Custom bin directories: `$HOME/bin`, `$HOME/.local/bin`

### Waybar (Status Bar)

Located in `shared/dot-config/waybar/`:
- `config.jsonc` - Main configuration
- `style.css` - Styling
- `power_menu.xml` - Power menu widget

## Development Guidelines

### Adding New Configurations

1. Shared configs go in `shared/dot-*` or `shared/dot-config/<app>/`
2. Host-specific configs go in `<hostname>/dot-*` or `<hostname>/dot-config/<app>/`
3. Use `dot-` prefix for files that should become dotfiles (`.file`)
4. Test with `stow --no --verbose` to preview changes before applying

### Modifying Hyprland Configs

- Edit `shared/dot-config/hypr/hyprland.conf` for universal changes
- Edit `<hostname>/dot-config/hypr/hyprland-device.conf` for device-specific settings (monitors, scaling)
- The device config is sourced last and can override any setting from the main config

### Adding New Hosts

1. Create directory named after the hostname
2. Add host-specific configurations following the `dot-` naming convention
3. Run `make install` on that host to deploy

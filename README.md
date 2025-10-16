# Kitty Terminal Config

Minimal, modern Kitty configuration for Linux and macOS. Features Agave Nerd Font with a custom warm color scheme.

## Features

- Clean powerline tabs with slanted style
- Smooth cursor trail animation
- Interactive scrollbar
- Vim/Nano friendly mouse bindings
- 98% background opacity
- Optimized performance settings

## Installation

### 1. Install Kitty

**Arch Linux:**
```bash
sudo pacman -S kitty
```

**Ubuntu/Debian:**
```bash
sudo apt install kitty
```

**Fedora:**
```bash
sudo dnf install kitty
```

**RHEL/CentOS:**
```bash
sudo yum install kitty
```

**macOS:**
```bash
brew install kitty
```

### 2. Install Agave Nerd Font

**Linux:**
```bash
curl -LO https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Agave.zip
unzip Agave.zip -d ~/.local/share/fonts/
fc-cache -fv
```

**macOS:**
```bash
curl -LO https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Agave.zip
unzip Agave.zip -d ~/Library/Fonts/
```

### 3. Install Config

```bash
mkdir -p ~/.config/kitty
curl -o ~/.config/kitty/kitty.conf https://raw.githubusercontent.com/gauravgughanedev/kitty/main/kitty.conf
```

## Key Bindings

- `Ctrl+Shift+Click` - Open links
- `Shift+Click` - Select text (works in vim/nano)
- `Shift+Right Click` - Extend selection
- `Ctrl+Shift+Alt+Click` - Rectangle selection
- `Middle Click` - Paste from selection

## Color Scheme

Custom warm palette with dark background (`#181c27`) and muted earth tones. Cursor highlights in soft blue.

## Requirements

- Kitty terminal emulator
- Agave Nerd Font or any Nerd Font
- Linux or macOS

## License

MIT

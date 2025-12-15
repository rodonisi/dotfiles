#!/usr/bin/env bash

DIR="$(cd "$(dirname "$0")" && pwd)"

NVIM_DIR=$HOME/.config/nvim
NVIM_CONFIG="lazyvim"

GHOSTTY_DIR=$HOME/.config/ghostty
GHOSTTY_CONFIG="ghostty"

STARSHIP_DIR=$HOME/.config
STARSHIP_CONFIG="starship"

FISH_DIR=$HOME/.config/fish
FISH_CONFIG="fish"

HYPRSPACE_CONFIG="hyprspace"

SKETCHYBAR_DIR=$HOME/.config/sketchybar
SKETCHYBAR_CONFIG="sketchybar"

if [[ "$OSTYPE" == "darwin"* ]]; then
  LAZYGIT_DIR="$HOME/Library/Application Support/lazygit"
else
  LAZYGIT_DIR="$HOME/.config/lazygit"
fi

LAZYGIT_CONFIG="lazygit"

DEPS=(
  # nvim dependencies
  'fd'
  'fzf'
  'ripgrep'
  'rust'
  'clang-format'
  'lazygit'
  'neovim'

  # terminal dependencies
  'starship'
  'carapace'
  'zoxide'
  'fish'

  # macos setup
  'lua'
  'FelixKratz/formulae/sketchybar'
  'FelixKratz/formulae/borders'
)

CASKS=(
  'ghostty'
  # 'nikitabobko/tap/aerospace'
  'BarutSRB/tap/hyprspace'
)

install_homebrew() {
  if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "Homebrew installation is only supported on macOS. Skipping Homebrew installation."
    return
  fi

  if ! command -v brew >/dev/null 2>&1; then
    echo "Homebrew not found. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
}

install_dependencies() {
  install_homebrew

  if [[ "$OSTYPE" == "darwin"* ]] || command -v brew >/dev/null 2>&1; then
    for dep in "${DEPS[@]}"; do
      echo "Checking for $dep"
      brew list "$dep" >/dev/null 2>&1 || brew install "$dep"
    done

    for cask in "${CASKS[@]}"; do
      echo "Checking for $cask"
      brew list --cask "$cask" >/dev/null 2>&1 || brew install --cask "$cask"
    done
  fi
}

setup_dotconfig_tool() {
  SOURCE_DIR=$1
  TARGET_DIR=$2

  echo "Setting up $SOURCE_DIR configuration"

  if [ -d "$TARGET_DIR" ] && [ ! -L "$TARGET_DIR" ]; then
    echo "Backing up existing configuration to $TARGET_DIR.bak"
    mv "$TARGET_DIR" "$TARGET_DIR.bak"
  fi

  if [ -e "$TARGET_DIR" ] || [ -L "$TARGET_DIR" ]; then
    echo "Cleaning up existing configuration"
    rm -rf "$TARGET_DIR"
  fi

  echo "Creating symbolic link for $SOURCE_DIR configuration"
  ln -s "$DIR/$SOURCE_DIR/" "$TARGET_DIR"

}

setup_starship() {
  if [ -e "$STARSHIP_DIR/starship.toml" ] && [ ! -L "$STARSHIP_DIR/starship.toml" ]; then
    echo "Moving existing starship configuration to $STARSHIP_DIR/starship.bak"
    mv "$STARSHIP_DIR/starship.toml" "$STARSHIP_DIR/starship.bak"
  fi

  if [ -e "$STARSHIP_DIR/starship.toml" ] || [ -L "$STARSHIP_DIR/starship.toml" ]; then
    echo "Cleaning up existing starship symlink"
    rm -rf "$STARSHIP_DIR/starship.toml"
  fi

  echo "Creating symbolic links for starship"
  ln -s "$DIR/$STARSHIP_CONFIG/starship.toml" $"$STARSHIP_DIR/starship.toml"

}

setup_fish() {
  setup_dotconfig_tool "$FISH_CONFIG" "$FISH_DIR"

  # add local config file
  touch "$HOME"/.local.fish

  setup_starship
}

setup_neovim() {
  setup_dotconfig_tool "$NVIM_CONFIG" "$NVIM_DIR"
}

setup_ghostty() {
  setup_dotconfig_tool "$GHOSTTY_CONFIG" "$GHOSTTY_DIR"
}

setup_hyprspace() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    ln -s "$DIR/$HYPRSPACE_CONFIG/hyprspace.toml" $"$HOME/.hyprspace.toml"
  fi
}

setup_lazygit() {
  setup_dotconfig_tool "$LAZYGIT_CONFIG" "$LAZYGIT_DIR"
}

setup_sketchybar() {
  setup_dotconfig_tool "$SKETCHYBAR_CONFIG" "$SKETCHYBAR_DIR"
}

install_dependencies
setup_fish
setup_neovim
setup_ghostty
setup_lazygit
setup_hyprspace
setup_sketchybar

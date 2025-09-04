#!/usr/bin/env bash

ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}
DIR="$(cd "$(dirname "$0")" && pwd)"

NVIM_DIR=$HOME/.config/nvim
NVIM_CONFIG="lazyvim"

GHOSTTY_DIR=$HOME/.config/ghostty
GHOSTTY_CONFIG="ghostty"

STARSHIP_DIR=$HOME/.config

NUSHELL_DIR="$HOME/Library/Application Support/nushell"
NUSHELL_CONFIG="nu"

DEPS=("fd" "ripgrep" "lazygit" "neovim" "ghostty" "starship" "nushell")

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

  if [[ "$OSTYPE" == "darwin"* ]]; then
    for dep in "${DEPS[@]}"; do
      brew list "$dep" || brew install "$dep"
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

setup_zsh() {
  if [ -e "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ]; then
    echo "Moving existing configuration to $HOME/.zshrc.local"
    mv "$HOME/.zshrc" "$HOME/.zshrc.local"
  fi

  if [ -e "$HOME/.zshrc" ] || [ -L "$HOME/.zshrc" ]; then
    echo "Cleaning up existing symlink"
    rm -rf "$HOME/.zshrc"
  fi

  if [ -e "$DIR/zsh/starship.toml" ] && [ ! -L "$STARSHIP_DIR/starship.toml" ]; then
    echo "Moving existing starship configuration to $STARSHIP_DIR/starship.bak"
    mv "$STARSHIP_DIR/starship.toml" "$STARSHIP_DIR/starship.bak"
  fi

  if [ -e "$STARSHIP_DIR/starship.toml" ] || [ -L "$STARSHIP_DIR/starship.toml" ]; then
    echo "Cleaning up existing starship symlink"
    rm -rf "$STARSHIP_DIR/starship.toml"
  fi

  echo "Creating symbolic links for .zshrc"
  ln -s "$DIR/zsh/zshrc" "$HOME/.zshrc"
  ln -s "$DIR/zsh/starship.toml" $"$STARSHIP_DIR/starship.toml"
}

setup_nu() {
  if [ -e "$NUSHELL_DIR" ] && [ ! -L "$NUSHELL_DIR" ]; then
    echo "Backing up existing configuration to $NUSHELL_DIR.bak"
    mv "$NUSHELL_DIR" "$NUSHELL_DIR.bak"
  fi

  if [ -L "$NUSHELL_DIR" ] || [ -e "$NUSHELL_DIR" ]; then
    echo "Cleaning up existing configuration"
    rm -rf "$NUSHELL_DIR"
  fi

  echo "Creating symbolic link for nushell configuration"
  ln -s "$DIR/$NUSHELL_CONFIG" "$NUSHELL_DIR"
}

setup_neovim() {
  setup_dotconfig_tool "$NVIM_CONFIG" "$NVIM_DIR"
}

setup_ghostty() {
  setup_dotconfig_tool "$GHOSTTY_CONFIG" "$GHOSTTY_DIR"
}

install_dependencies
setup_nu
setup_neovim
setup_ghostty

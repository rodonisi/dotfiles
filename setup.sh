#!/usr/bin/env bash

DIR="$(cd "$(dirname "$0")" && pwd)"

NVIM_DIR=$HOME/.config/nvim
NVIM_CONFIG="lazyvim"

GHOSTTY_DIR=$HOME/.config/ghostty
GHOSTTY_CONFIG="ghostty"

DEPS=["fd" "ripgrep" "lazygit" "neovim" "ghostty"]

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
      if ! command -v "$dep" >/dev/null 2>&1; then
        echo "$dep not found. Installing with Homebrew"
        brew install "$dep"
      fi
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

setup_neovim() {
  setup_dotconfig_tool "$NVIM_CONFIG" "$NVIM_DIR"
}

setup_ghostty() {
  setup_dotconfig_tool "$GHOSTTY_CONFIG" "$GHOSTTY_DIR"
}

install_dependencies
setup_neovim
setup_ghostty

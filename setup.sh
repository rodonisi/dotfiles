#!/usr/bin/env bash

DIR="$(cd "$(dirname "$0")" && pwd)"

NVIM_DIR=$HOME/.config/nvim
NVIM_CONFIG="lazyvim"

DEPS=["fd" "rg" "lazygit" "neovim"]

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

setup_neovim() {
  echo "Setting up Neovim configuration..."

  if [[ "$OSTYPE" == "darwin"* ]]; then
    for dep in "${DEPS[@]}"; do
      if ! command -v "$dep" >/dev/null 2>&1; then
        echo "$dep not found. Installing with Homebrew"
        brew install "$dep"
      fi
    done
  fi

  if [ -d "$NVIM_DIR" ] && [ ! -L "$NVIM_DIR" ]; then
    echo "Backing up existing Neovim configuration to $NVIM_DIR.bak"
    mv "$NVIM_DIR" "$NVIM_DIR.bak"
  fi

  if [ -e "$NVIM_DIR" ] || [ -L "$NVIM_DIR" ]; then
    echo "Cleaning up existing Neovim configuration"
    rm -rf "$NVIM_DIR"
  fi

  echo "Creating symbolic link for Neovim configuration"
  ln -s "$DIR/$NVIM_CONFIG/" "$NVIM_DIR"
}

install_homebrew
setup_neovim

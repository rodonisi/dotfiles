#!/usr/bin/env bash

NVIM_DIR=$HOME/.config/nvim
DIR="$(cd "$(dirname "$0")" && pwd)"
ASTRO="astronvim"

# Setup macOS packages
if [[ "$OSTYPE" == "darwin"* ]]; then
  if ! command -v brew >/dev/null 2>&1; then
    echo "Homebrew not found. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  if ! command -v lazygit >/dev/null 2>&1; then
    echo "lazygit not found. Installing with Homebrew..."
    brew install lazygit
  fi

  if ! command -v nvim >/dev/null 2>&1; then
    echo "Neovim not found. Installing with Homebrew..."
    brew install neovim
  fi
fi

# Configure nvim

if [ -d "$NVIM_DIR" ] && [ ! -L "$NVIM_DIR" ]; then
  mv "$NVIM_DIR" "$NVIM_DIR.bak"
fi

if [ -e "$NVIM_DIR" ] || [ -L "$NVIM_DIR" ]; then
  rm -rf "$NVIM_DIR"
fi

ln -s "$DIR/$ASTRO/" "$NVIM_DIR"

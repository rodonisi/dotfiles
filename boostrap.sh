#!/usr/bin/env bash

ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}
DIR="$(cd "$(dirname "$0")" && pwd)"

NVIM_DIR=$HOME/.config/nvim
NVIM_CONFIG="lazyvim"

GHOSTTY_DIR=$HOME/.config/ghostty
GHOSTTY_CONFIG="ghostty"

STARSHIP_DIR=$HOME/.config

AEROSPACE_DIR=$HOME/.config/aerospace
AEROSPACE_CONFIG="aerospace"

if [[ "$OSTYPE" == "darwin"* ]]; then
  LAZYGIT_DIR="$HOME/Library/Application Support/lazygit"
else
  LAZYGIT_DIR="$HOME/.config/lazygit"
fi

LAZYGIT_CONFIG="lazygit"

DEPS=(
  "fd"
  "ripgrep"
  "lazygit"
  "neovim"
  "starship"
  'carapace'
)

CASKS=(
  "ghostty"
  "nikitabobko/tap/aerospace"
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

  if  [[ "$OSTYPE" == "darwin"* ]] || command -v brew >/dev/null 2>&1; then
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

setup_neovim() {
  setup_dotconfig_tool "$NVIM_CONFIG" "$NVIM_DIR"
}

setup_ghostty() {
  setup_dotconfig_tool "$GHOSTTY_CONFIG" "$GHOSTTY_DIR"
}

setup_aerospace() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    setup_dotconfig_tool "$AEROSPACE_CONFIG" "$AEROSPACE_DIR"
  fi
}

setup_lazygit() {
  setup_dotconfig_tool "$LAZYGIT_CONFIG" "$LAZYGIT_DIR"
}

install_dependencies
setup_zsh
setup_neovim
setup_ghostty
setup_aerospace
setup_lazygit

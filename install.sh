#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZSH_PLUGIN_DIR="${ZSH_PLUGIN_DIR:-$HOME/.zsh}"

install_homebrew() {
  if command -v brew >/dev/null 2>&1; then
    return
  fi

  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

load_homebrew() {
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  elif command -v brew >/dev/null 2>&1; then
    eval "$(brew shellenv)"
  else
    echo "Homebrew was not found after installation." >&2
    exit 1
  fi
}

ensure_brew_in_zprofile() {
  local zprofile="$HOME/.zprofile"
  local brew_prefix
  local shellenv_line

  brew_prefix="$(brew --prefix)"
  shellenv_line="eval \"\$($brew_prefix/bin/brew shellenv)\""

  touch "$zprofile"
  grep -Fxq "$shellenv_line" "$zprofile" || printf '\n%s\n' "$shellenv_line" >> "$zprofile"
}

install_mise() {
  if brew list mise >/dev/null 2>&1; then
    return
  fi

  brew install mise
}

clone_or_update() {
  local repo="$1"
  local dest="$2"

  if [[ -d "$dest/.git" ]]; then
    git -C "$dest" pull --ff-only
  elif [[ -e "$dest" ]]; then
    echo "Skipping $dest; it already exists and is not a git checkout." >&2
  else
    git clone "$repo" "$dest"
  fi
}

install_zsh_plugins() {
  mkdir -p "$ZSH_PLUGIN_DIR"

  clone_or_update \
    https://github.com/zsh-users/zsh-autosuggestions \
    "$ZSH_PLUGIN_DIR/zsh-autosuggestions"

  clone_or_update \
    https://github.com/zsh-users/zsh-syntax-highlighting.git \
    "$ZSH_PLUGIN_DIR/zsh-syntax-highlighting"
}

copy_dotfiles() {
  cp -f "$DOTFILES/.zshrc" "$HOME/.zshrc"
}

install_homebrew
load_homebrew
ensure_brew_in_zprofile
install_mise
install_zsh_plugins
copy_dotfiles

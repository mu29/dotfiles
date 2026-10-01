#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ "$(uname -s)" != Darwin ]]; then
  echo "This installer is for macOS." >&2
  exit 1
fi

if [[ ! -f "$DOTFILES/.zshrc" ]]; then
  echo "Missing $DOTFILES/.zshrc; keep it next to install.sh." >&2
  exit 1
fi
/bin/zsh -n "$DOTFILES/.zshrc"

# Use paths relative to the current user, including after a machine migration.
export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$HOME/.local/bin:$PNPM_HOME:$PNPM_HOME/bin:$PATH"

install_homebrew() {
  if command -v brew >/dev/null 2>&1 ||
     [[ -x /opt/homebrew/bin/brew || -x /usr/local/bin/brew ]]; then
    return
  fi

  local installer
  installer="$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  /bin/bash -c "$installer"
}

load_homebrew() {
  local brew_bin shellenv
  if command -v brew >/dev/null 2>&1; then
    brew_bin="$(command -v brew)"
  elif [[ -x /opt/homebrew/bin/brew ]]; then
    brew_bin=/opt/homebrew/bin/brew
  elif [[ -x /usr/local/bin/brew ]]; then
    brew_bin=/usr/local/bin/brew
  else
    echo "Homebrew was not found after installation." >&2
    exit 1
  fi

  shellenv="$("$brew_bin" shellenv)"
  eval "$shellenv"
}

install_zsh_plugins() {
  local formula
  for formula in zsh-autosuggestions zsh-syntax-highlighting zsh-completions; do
    if ! brew list --formula "$formula" >/dev/null 2>&1; then
      brew install "$formula"
    fi
  done
}

install_mise() {
  if ! command -v mise >/dev/null 2>&1; then
    curl -fsSL https://mise.run |
      env MISE_INSTALL_PATH="$HOME/.local/bin/mise" sh
  fi
  mise --version
}

copy_dotfiles() {
  local target="$HOME/.zshrc"
  local backup
  if [[ -e "$target" ]] && cmp -s "$DOTFILES/.zshrc" "$target"; then
    return
  fi
  if [[ -e "$target" ]]; then
    backup="$(mktemp "$HOME/.zshrc.backup.XXXXXX")"
    cp -p "$target" "$backup"
    printf 'Backed up .zshrc to %s\n' "$backup"
  fi
  cp -f "$DOTFILES/.zshrc" "$target"
}

install_pnpm() {
  if ! command -v pnpm >/dev/null 2>&1; then
    curl -fsSL https://get.pnpm.io/install.sh |
      env SHELL=/bin/zsh PNPM_HOME="$PNPM_HOME" sh -
  fi
  pnpm --version
}

install_homebrew
load_homebrew
install_zsh_plugins
install_mise

# pnpm setup may append PATH configuration; copy the dotfile first.
copy_dotfiles
install_pnpm

printf '\nInstallation complete. Open a new terminal, or run: exec zsh\n'

# brew
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# Local binaries
export PATH="$HOME/.local/bin:$PATH"

# Keep user-local commands such as codex available without shadowing Homebrew.
[[ -d "$HOME/.local/bin" && ":$PATH:" != *":$HOME/.local/bin:"* ]] && path+=("$HOME/.local/bin")

# Enable mise-managed tools in each shell.
command -v mise >/dev/null 2>&1 && eval "$(mise activate zsh)"

setopt PROMPT_SUBST
setopt SHARE_HISTORY HIST_IGNORE_DUPS

SAVEHIST=50000
HISTFILE="$HOME/.zsh_history"

autoload -Uz colors
colors

FPATH="$HOMEBREW_PREFIX/share/zsh-completions:$FPATH"

# Directory/file colors for BSD ls on macOS.
export CLICOLOR=1
export LSCOLORS="Gxfxcxdxbxegedabagacad"
alias ls="ls -G"

autoload -Uz compinit
compinit

# Enable an interactive completion menu like oh-my-zsh's default behavior.
zmodload zsh/complist
zstyle ':completion:*' menu select
bindkey -M menuselect "${terminfo[kcuu1]}" up-line-or-history
bindkey -M menuselect "${terminfo[kcud1]}" down-line-or-history

# Search command history by the text already typed at the prompt.
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search
bindkey "${terminfo[kcud1]}" down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search

# Run git prompt reads without taking optional repository locks.
_git_prompt_git() {
  GIT_OPTIONAL_LOCKS=0 command git "$@"
}

# Print the current branch, tag, or short commit SHA for the prompt.
git_prompt_info() {
  _git_prompt_git rev-parse --git-dir >/dev/null 2>&1 || return

  local ref
  ref=$(_git_prompt_git symbolic-ref --short HEAD 2>/dev/null) \
    || ref=$(_git_prompt_git describe --tags --exact-match HEAD 2>/dev/null) \
    || ref=$(_git_prompt_git rev-parse --short HEAD 2>/dev/null) \
    || return

  print -r -- "${ZSH_THEME_GIT_PROMPT_PREFIX}${ref//\%/%%}${ZSH_THEME_GIT_PROMPT_SUFFIX}"
}

# Print color escape sequences that represent the current git worktree state.
git_prompt_status() {
  _git_prompt_git rev-parse --git-dir >/dev/null 2>&1 || return

  local git_status line prompt
  local has_untracked has_added has_modified has_deleted has_renamed has_unmerged

  git_status=$(_git_prompt_git status --porcelain 2>/dev/null) || return
  [[ -n "$git_status" ]] || return

  for line in ${(f)git_status}; do
    case "$line" in
      '?? '*)
        has_untracked=1
        continue
        ;;
      (UU|AA|DD|AU|UA|DU|UD)' '*)
        has_unmerged=1
        ;;
    esac

    [[ "${line[1]}" == A || "${line[2]}" == A ]] && has_added=1
    [[ "${line[1]}" == M || "${line[2]}" == M || "${line[1]}" == T || "${line[2]}" == T ]] && has_modified=1
    [[ "${line[1]}" == D || "${line[2]}" == D ]] && has_deleted=1
    [[ "${line[1]}" == R || "${line[2]}" == R ]] && has_renamed=1
  done

  [[ -n "$has_untracked" ]] && prompt="$ZSH_THEME_GIT_PROMPT_UNTRACKED$prompt"
  [[ -n "$has_added" ]] && prompt="$ZSH_THEME_GIT_PROMPT_ADDED$prompt"
  [[ -n "$has_modified" ]] && prompt="$ZSH_THEME_GIT_PROMPT_MODIFIED$prompt"
  [[ -n "$has_renamed" ]] && prompt="$ZSH_THEME_GIT_PROMPT_RENAMED$prompt"
  [[ -n "$has_deleted" ]] && prompt="$ZSH_THEME_GIT_PROMPT_DELETED$prompt"
  [[ -n "$has_unmerged" ]] && prompt="$ZSH_THEME_GIT_PROMPT_UNMERGED$prompt"

  print -n -- "$prompt"
}

# Colors used by git_prompt_status for each git status category.
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[magenta]%}"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[blue]%}"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[cyan]%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[yellow]%}"

# Wrapper around the branch name printed by git_prompt_info.
ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg[green]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX=")%{$reset_color%}"

# Use a different path color for root shells.
user_color='yellow'
test "$UID" -eq 0 && user_color='red'

# mu29 prompt: previous exit code, cwd, git info, git status color, prompt char.
PROMPT='%(?..%{$fg_bold[red]%}exit %?
%{$reset_color%})'\
'%{$fg[$user_color]%}%~%{$reset_color%}'\
'$(git_prompt_info)'\
'$(git_prompt_status)'\
'%(!.#. $)%{$reset_color%} '

# Continuation prompt for multiline commands.
PROMPT2='%{$fg[red]%}\ %{$reset_color%}'

# Git
alias gc="git checkout"
alias gp="git pull"
alias gm="git merge"
alias gb="git branch"
alias gcp="git cherry-pick"

# Utils
export PAGER="less"
export GIT_PAGER="less"
export LESS="-R --wheel-lines=2"

alias ipcopy="ipconfig getifaddr en1 | pbcopy"

# pnpm
export PNPM_HOME='/Users/friday/Library/pnpm'
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end

source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

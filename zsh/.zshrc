# =========================
#  macOS zsh (Ghostty) — clean, working config with fzf-tab on <Tab>
# =========================

# --- PATH (Apple Silicon) ---
# If you're on Intel, change /opt/homebrew to /usr/local
typeset -U PATH path
path=(/opt/homebrew/bin $path)      # Homebrew first
path=(/opt/homebrew/opt/openssh/bin $path)  # Prefer Homebrew OpenSSH
export PATH

# --- Extra PATH entries you use ---
path+=("/Applications/Wine Staging.app/Contents/Resources/wine/bin")

# --- Prompt/theme early (doesn't touch completion) ---
source "$HOME/powerlevel10k/powerlevel10k.zsh-theme"
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# --- Quality of life tools (safe before completion) ---
# zoxide
eval "$(zoxide init zsh)"

# GPG TTY
export GPG_TTY="$(tty)"

# --- Aliases ---
if [[ "$OSTYPE" == darwin* ]]; then
  alias ls='ls -G'
  alias ll='ls -alh -G'
  alias la='ls -A -G'
  alias l='ls -CF -G'
else
  alias ls='ls --color=auto'
  alias ll='ls -alh --color=auto'
  alias la='ls -A --color=auto'
  alias l='ls -CF --color=auto'
fi

alias cat='bat'
alias nvf='nvim $(fzf -m --preview="bat --color=always {}")'

# Git
alias gc="git commit -m"
alias gca="git commit -a -m"
alias gp="git push origin HEAD"
alias gpu="git pull origin"
alias gs="git status"
alias glog="git log --graph --topo-order --pretty='%w(100,0,6)%C(yellow)%h%C(bold)%C(black)%d %C(cyan)%ar %C(green)%an%n%C(bold)%C(white)%s %N' --abbrev-commit"
alias gdiff="git diff"
alias gco="git checkout"
alias gb='git branch'
alias gba='git branch -a'
alias gadd='git add'
alias ga='git add -p'
alias gcoall='git checkout -- .'
alias gr='git remote'
alias gre='git reset'

# --- 1Password SSH agent (choose ONE strategy; this uses 1P) ---
export SSH_AUTH_SOCK="$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
# Manual agent alternative (leave commented if using 1P)
# alias start-ssh-agent='eval "$(ssh-agent -s)" && ssh-add --apple-use-keychain'

# --- nvm lazy-load ---
export NVM_DIR="$HOME/.nvm"
load_nvm() {
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
}
alias nvm='load_nvm; nvm'
alias node='load_nvm; node'
alias npm='load_nvm; npm'

# --- pyenv ---
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || path=("$PYENV_ROOT/bin" $path)
# In ~/.zprofile you should also have: eval "$(pyenv init --path)"
eval "$(pyenv init -)"

# =========================
#  Completion + fzf-tab
# =========================

# Base completion
autoload -Uz compinit
compinit
zmodload zsh/complist

# DO NOT source fzf's key-bindings (they hijack <Tab>)
# (Intentionally NOT sourcing ~/.fzf.zsh or .../fzf/shell/key-bindings.zsh)

# fzf-tab plugin (install once: git clone https://github.com/Aloxaf/fzf-tab ~/.zsh/fzf-tab)
if [[ -r ~/.zsh/fzf-tab/fzf-tab.plugin.zsh ]]; then
  source ~/.zsh/fzf-tab/fzf-tab.plugin.zsh
fi

# Let fzf-tab intercept completion instead of zsh menu cycling
unsetopt menu_complete
zstyle ':completion:*' menu no

# Styling (optional)
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':fzf-tab:*' fzf-min-height 10
zstyle ':fzf-tab:*' switch-group ',' '.'
zstyle ':fzf-tab:complete:*' fzf-preview \
  '[[ -d $realpath ]] && ls -la -- $realpath || { command -v bat >/dev/null && bat --style=plain --color=always --line-range=:200 -- $realpath || head -200 -- $realpath; }'

# Keymaps — vi mode, ensure <Tab> completes in INSERT mode
bindkey -v
bindkey -M viins '^I' complete-word

# =========================
#  Final quick sanity (comment out if you prefer silence)
# =========================
# command -v fzf >/dev/null || echo "[zshrc] WARNING: fzf not found in PATH"
# typeset -f _fzf_tab_widget >/dev/null || echo "[zshrc] WARNING: fzf-tab not loaded"
# bindkey -M viins | grep -q '\^I.*complete-word' || echo "[zshrc] WARNING: <Tab> not bound to complete-word"

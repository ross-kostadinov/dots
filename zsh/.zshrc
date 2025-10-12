# --- Faster, safe completion
autoload -Uz compinit
compinit -C

# --- PATH sanity (dedupe once)
typeset -U PATH path
export PATH

# --- Homebrew OpenSSH first
path=(/opt/homebrew/opt/openssh/bin $path)

# --- Wine
path+=("/Applications/Wine Staging.app/Contents/Resources/wine/bin")

# --- (Optional) X11 fallback – only if you really need it
# export DYLD_FALLBACK_LIBRARY_PATH="/usr/lib:/opt/X11/lib:${DYLD_FALLBACK_LIBRARY_PATH}"

# --- nvm lazy-load
export NVM_DIR="$HOME/.nvm"
load_nvm() {
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
}
alias nvm='load_nvm; nvm'
alias node='load_nvm; node'
alias npm='load_nvm; npm'

# --- pyenv (put this in ~/.zprofile ideally)
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || path=("$PYENV_ROOT/bin" $path)
# ~/.zprofile: eval "$(pyenv init --path)"
# ~/.zshrc for shell features:
eval "$(pyenv init -)"

# --- Extra PATHs
path+=("$HOME/Library/Python/3.11/bin" "$HOME/.local/bin")

# --- Aliases (macOS vs Linux)
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

alias cd='z'

# --- fzf (robust)
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

# --- 1Password SSH agent (pick ONE agent strategy)
export SSH_AUTH_SOCK="$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
# If you truly need a manual agent, use this instead and DON'T set SSH_AUTH_SOCK above:
# alias start-ssh-agent='eval "$(ssh-agent -s)" && ssh-add --apple-use-keychain'

# --- GPG + vi-mode
export GPG_TTY="$(tty)"
bindkey -v

# --- zoxide
eval "$(zoxide init zsh)"

# --- Powerlevel10k
source "$HOME/powerlevel10k/powerlevel10k.zsh-theme"
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

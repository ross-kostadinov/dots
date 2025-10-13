# --- Faster, safe completion
# autoload -Uz compinit
# compinit -C

# --- PATH sanity (dedupe once)
typeset -U PATH path
export PATH

# --- Homebrew OpenSSH first
path=(/opt/homebrew/opt/openssh/bin $path)

# --- Wine
path+=("/Applications/Wine Staging.app/Contents/Resources/wine/bin")

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
alias cat=bat

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

#Edit multiple files using nvim and fzf (use tab for file selection)
alias nvf='nvim $(fzf -m --preview="bat --color=always {}")'

# --- fzf (robust)
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

# --- 1Password SSH agent (pick ONE agent strategy)
export SSH_AUTH_SOCK="$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
# If you truly need a manual agent, use this instead and DON'T set SSH_AUTH_SOCK above:
alias start-ssh-agent='eval "$(ssh-agent -s)" && ssh-add --apple-use-keychain'

# --- GPG + vi-mode
export GPG_TTY="$(tty)"
bindkey -v

# --- zoxide
eval "$(zoxide init zsh)"

# --- Powerlevel10k
source "$HOME/powerlevel10k/powerlevel10k.zsh-theme"
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

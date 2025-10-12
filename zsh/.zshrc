# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

autoload -U compinit
compinit

export PATH="/opt/homebrew/opt/openssh/bin:$PATH"
export PATH="/Applications/Wine Staging.app/Contents/Resources/wine/bin:$PATH"
export FREETYPE_PROPERTIES="truetype:interpreter-version=35"
export DYLD_FALLBACK_LIBRARY_PATH="/usr/lib:/opt/X11/lib:$DYLD_FALLBACK_LIBRARY_PATH"

# Lazy-load nvm
export NVM_DIR="$HOME/.nvm"
function load_nvm {
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}
alias nvm="load_nvm; nvm"
alias node="load_nvm; node"
alias npm="load_nvm; npm"

# MongoDB Aliases
alias mongodb="mongod --dbpath=/Users/ross/mongodb/db2"

# Lazy-load pyenv (move this to ~/.zprofile if possible)
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"

export PATH="$PATH:/Users/ross/Library/Python/3.11/bin"
export PATH="$PATH:/Users/ross/.local/bin"

alias ll='ls -alh'

[[ ! "$PATH" == *fzf* ]] && source ~/.fzf.zsh

export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock

alias yk-ssh='eval "$(ssh-agent -s)" && ssh-add -K && ssh-add -L'
export GPG_TTY=$(tty)
bindkey -v
source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

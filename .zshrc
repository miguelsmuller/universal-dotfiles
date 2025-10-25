# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

### START BREW
# eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
if command -v brew >/dev/null 2>&1; then
  eval "$(brew shellenv)" 2>/dev/null
else
  case "$OSTYPE" in
    darwin*)
      [[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)" 2>/dev/null
      [[ -x /usr/local/bin/brew   ]] && eval "$(/usr/local/bin/brew shellenv)" 2>/dev/null
      ;;
    linux*)
      [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" 2>/dev/null
      [[ -x /linuxbrew/.linuxbrew/bin/brew       ]] && eval "$(/linuxbrew/.linuxbrew/bin/brew shellenv)" 2>/dev/null
      ;;
  esac
fi

### START DOT-FILES
export UNIVERSAL=.universal
export UNIVERSAL_GIT=.universal-bare-repo

config() {
  command git --git-dir="$HOME/$UNIVERSAL_GIT" --work-tree="$HOME" "$@"
}
alias config-update="/bin/bash $HOME/$UNIVERSAL/scripts/update_gitconfig_local.sh"


# [[ -f "$HOME/$UNIVERSAL/dot-files/load-zinit" ]] && source "$HOME/$UNIVERSAL/dot-files/load-zinit"
[[ -f ~/${UNIVERSAL}/dot-files/load-zinit ]] && source ~/${UNIVERSAL}/dot-files/load-zinit
[[ -f ~/${UNIVERSAL}/dot-files/load-zsh-plugins ]] && source ~/${UNIVERSAL}/dot-files/load-zsh-plugins
[[ -f ~/${UNIVERSAL}/dot-files/load-oh-my-zsh-theme ]] && source ~/${UNIVERSAL}/dot-files/load-oh-my-zsh-theme
[[ -f ~/${UNIVERSAL}/dot-files/load-oh-my-zsh ]] && source ~/${UNIVERSAL}/dot-files/load-oh-my-zsh


[[ -f ~/${UNIVERSAL}/dot-files/env-public ]]  && source ~/${UNIVERSAL}/dot-files/env-public
[[ -f ~/${UNIVERSAL}/dot-files/env-private ]]  && source ~/${UNIVERSAL}/dot-files/env-private
[[ -f ~/${UNIVERSAL}/dot-files/system ]]&& source ~/${UNIVERSAL}/dot-files/system
[[ -f ~/${UNIVERSAL}/dot-files/git ]] && source ~/${UNIVERSAL}/dot-files/git
[[ -f ~/${UNIVERSAL}/dot-files/docker ]] && source ~/${UNIVERSAL}/dot-files/docker
[[ -f ~/${UNIVERSAL}/dot-files/python ]] && source ~/${UNIVERSAL}/dot-files/python
[[ -f ~/${UNIVERSAL}/dot-files/java ]] && source ~/${UNIVERSAL}/dot-files/java
[[ -f ~/${UNIVERSAL}/dot-files/go ]] && source ~/${UNIVERSAL}/dot-files/go
[[ -f ~/${UNIVERSAL}/dot-files/kubernets ]] && source ~/${UNIVERSAL}/dot-files/kubernets
[[ -f ~/${UNIVERSAL}/dot-files/work-loggi ]] && source ~/${UNIVERSAL}/dot-files/work-loggi


#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

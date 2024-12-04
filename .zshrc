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


### START PYENV
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"


### START BREW
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"


### START NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


### START GVM LOAD - GO VERSION MANAGER
[[ -s "/home/migue/.gvm/scripts/gvm" ]] && source "/home/migue/.gvm/scripts/gvm"


### START DOT-FILES
export UNIVERSAL=.universal
export UNIVERSAL_GIT=.universal-bare-repo
alias config="/usr/bin/git --git-dir=$HOME/$UNIVERSAL_GIT --work-tree=$HOME"
alias config-update="/bin/bash $HOME/$UNIVERSAL/scripts/update_gitconfig_local.sh"


# [[ -f "$HOME/$UNIVERSAL/dot-files/load-zinit" ]] && source "$HOME/$UNIVERSAL/dot-files/load-zinit"
[[ -f ~/${UNIVERSAL}/dot-files/load-zinit ]] && source ~/${UNIVERSAL}/dot-files/load-zinit
[[ -f ~/${UNIVERSAL}/dot-files/load-zsh-plugins ]] && source ~/${UNIVERSAL}/dot-files/load-zsh-plugins
[[ -f ~/${UNIVERSAL}/dot-files/load-oh-my-zsh-theme ]] && source ~/${UNIVERSAL}/dot-files/load-oh-my-zsh-theme
[[ -f ~/${UNIVERSAL}/dot-files/load-oh-my-zsh ]] && source ~/${UNIVERSAL}/dot-files/load-oh-my-zsh


[[ -f ~/${UNIVERSAL}/dot-files/00-env ]]  && source ~/${UNIVERSAL}/dot-files/00-env
[[ -f ~/${UNIVERSAL}/dot-files/01-system ]]&& source ~/${UNIVERSAL}/dot-files/01-system
[[ -f ~/${UNIVERSAL}/dot-files/02-ls ]] && source ~/${UNIVERSAL}/dot-files/02-ls
[[ -f ~/${UNIVERSAL}/dot-files/03-git ]] && source ~/${UNIVERSAL}/dot-files/03-git
[[ -f ~/${UNIVERSAL}/dot-files/04-docker ]] && source ~/${UNIVERSAL}/dot-files/04-docker
[[ -f ~/${UNIVERSAL}/dot-files/05-python ]] && source ~/${UNIVERSAL}/dot-files/05-python

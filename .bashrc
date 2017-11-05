# return if not interactive shell
case $- in
    *i*) ;;
      *) return;;
esac

if [ -f ~/.bash_aliases ]; then
  source ~/.bash_aliases
fi
if [ -f ~/.bash_functions ]; then
  source ~/.bash_functions
fi

# Auto completion
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

shopt -s autocd
shopt -s checkwinsize
shopt -s histappend
export HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000

test -r ~/.dircolors && eval "$(dircolors ~/.dircolors)"

# set editing mode to VI keybindings
set -o vi

source "/usr/share/git/completion/git-prompt.sh"
export PS1='\[\033[34m\]┌─\[\e[0m\][\u@\h][\w][$(__git_ps1 "(%s)")]\n\[\033[34m\]└─◼ \[\e[0m\]'

#trap 'echo -ne "\e[0m"' DEBUG

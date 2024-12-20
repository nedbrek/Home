# command line
bindkey '^W' vi-backward-kill-word
bindkey -e
# default includes . and /
# we want backwards kill to stop on path chunks
export WORDCHARS='*?_-[]~&;!#$%^(){}<>'

# auto-complete lower to upper
autoload -U compinit
compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' ignored-patterns '*.o'

autoload -U colors && colors

# make up and down match the whole line
autoload -U up-line-or-beginning-search
zle -N up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N down-line-or-beginning-search
#bindkey '^[[A' up-line-or-beginning-search
[[ -n "${key[Up]}"      ]]  && bindkey "${key[Up]}" up-line-or-beginning-search
#bindkey '^[[B' down-line-or-beginning-search
[[ -n "${key[Down]}"    ]]  && bindkey "${key[Down]}" down-line-or-beginning-search

export HISTSIZE=2000
export SAVEHIST=$HISTSIZE
export HISTFILE=~/.zhistory
export EDITOR=vim
setopt APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS

# source control
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[red]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX=")%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="*"
ZSH_THEME_GIT_PROMPT_CLEAN=""

function git_prompt_info() {
	ref=$(git symbolic-ref HEAD 2> /dev/null) || return
	echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

parse_git_dirty () {
	if [[ -n $(git status -s 2> /dev/null) ]]; then
echo "$ZSH_THEME_GIT_PROMPT_DIRTY"
	else
echo "$ZSH_THEME_GIT_PROMPT_CLEAN"
	fi
}

PROMPT='%{$fg[blue]%}%d %%%{$reset_color%} '
RPROMPT='$(git_prompt_info)'

setopt prompt_subst

# aliases
# better defaults
builtin alias cp='cp -i'
builtin alias ln='ln -i'
builtin alias ls='ls -F'
builtin alias mv='mv -i'
builtin alias rm='rm -i'
builtin alias vi='vim'

# short forms
builtin alias d='dirs -v'
builtin alias h='history'
builtin alias les='/usr/bin/less -x3'
builtin alias less='les -S'

builtin alias 1='pushd +1'
builtin alias 2='pushd +2'
builtin alias 3='pushd +3'
builtin alias 4='pushd +4'
builtin alias 5='pushd +5'
builtin alias 6='pushd +6'
builtin alias 7='pushd +7'
builtin alias 8='pushd +8'
builtin alias 9='pushd +9'

# complex commands
lsd() {ls -l | awk '/^d/{print $NF}'}

#dirs <working directories>


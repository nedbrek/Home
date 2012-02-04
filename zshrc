# command line
bindkey '^W' vi-backward-kill-word
bindkey -e

# auto-complete lower to upper
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

autoload -U colors && colors

HISTSIZE=2000
export EDITOR=vi

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
builtin alias mv='mv -i'
builtin alias rm='rm -i'
builtin alias vi='vim'
builtin alias ls='ls -F'

# short forms
builtin alias d='dirs -v'
builtin alias h='history'

# complex commands
lsd() {ls -l | awk '/^d/{print $NF}'}


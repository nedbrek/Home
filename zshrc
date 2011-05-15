ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[red]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX=")%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="*"
ZSH_THEME_GIT_PROMPT_CLEAN=""

function git_prompt_info() {
	ref=$(git symbolic-ref HEAD 2> /dev/null) || return
	echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

PROMPT='%{$fg[blue]%}%d %%%{$reset_color%} '
RPROMPT='$(git_prompt_info)'

setopt prompt_subst

builtin alias cp='cp -i'
builtin alias mv='mv -i'
builtin alias rm='rm -i'
builtin alias vi='vim'


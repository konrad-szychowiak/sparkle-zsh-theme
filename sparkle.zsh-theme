# A multiline prompt with username, hostname, full path, return status, git branch, git dirty status, git remote status

# COLOUR SETUP
local host_type_color="green"
if [ -n "$SSH_CLIENT" ]; then
  local host_type_color="red"
fi
local host_color="%{$fg_bold[${host_type_color}]%}"
local path_color="%{$fg_bold[blue]%}"
local my_gray="$fg_bold[white]"



# SYMBOLS
local joiner="❯"
local branch=""
local errored="%{$fg[red]%}✘ "

# SEGMENTS
function join {
    local use_color
    [[ -n $1 ]] && use_color=$1 || use_color=""
    echo -n "%{$use_color%}%{$joiner%}"
}

user_segment() {
    echo -n "%{$host_color%}%n@%m%{$reset_color%}"
}

function path_segment {
    echo -n " $(join $path_color) %10c%{$reset_color%}"
}

function exit_status {
    echo -n "%(?..$errored)"
}
function su_status {
    [[ $UID -eq 0 ]] && echo -n "%{$fg_bold[yellow]%}⚡ "
}
function bg_status {
    [[ $(jobs -l | wc -l) -gt 0 ]] && echo -n "%{$fg_bold[cyan]%}⚙ "
}
function prompt_segment {
    echo -n "$(bg_status)$(su_status)$(exit_status)$(join $host_color) %{$reset_color%}"
}

function git_segment {

}

PROMPT='
$(user_segment)$(path_segment)%{$reset_color%}$(parse_git_dirty)$(git_prompt_info)
$(prompt_segment)'

# RPROMPT='${return_status}%{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX=" ❯  "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[yellow]%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%}"
ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE="%{$fg_bold[magenta]%}↓%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE="%{$fg_bold[magenta]%}↑%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIVERGED_REMOTE="%{$fg_bold[magenta]%}↕%{$reset_color%}"

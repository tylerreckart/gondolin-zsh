# Retrieve current user host
function _user_host() {
  if [[ $(who am i) =~ \([-a-zA-Z0-9\.]+\) ]]; then
    me="%n@%m"
  elif [[ logname != $USER ]]; then
    me="%n"
  fi

  if [[ -n $me ]]; then
    echo "%{$fg[cyan]%}$me%{$reset_color%}:%{$fg[cyan]%}%c%{$reset_color%}"
  fi
}

# Format for current branch indicator
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"

# Format for git prompt status indicators
ZSH_THEME_GIT_PROMPT_CLEAN=" "
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[magenta]%}? "
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[blue]%}+ "
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[yellow]%}△ "
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}✖ "
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[blue]%}» "
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[cyan]%}§ "
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg[blue]%}⇡ "
ZSH_THEME_GIT_PROMPT_BEHIND="%{$fg[magenta]%}⇣ "
ZSH_THEME_GIT_PROMPT_DIVERGED="%{$fg[cyan]%}⇕ "
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}✗%{$reset_color%} "

# Format for git_prompt_long_sha() and git_prompt_short_sha()
ZSH_THEME_GIT_PROMPT_SHA_BEFORE="%{$fg[white]%}"
ZSH_THEME_GIT_PROMPT_SHA_AFTER="%{$reset_color%} "

# Format for time since commit message
ZSH_THEME_GIT_TIME_SINCE_COMMIT_SHORT="%{$fg[white]%}"
ZSH_THEME_GIT_TIME_SHORT_COMMIT_MEDIUM="%{$fg[yellow]%}"
ZSH_THEME_GIT_TIME_SINCE_COMMIT_LONG="%{$fg[red]%}"
ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL="%{$fg[white]%}"

# Determine the time since last commit.
# If the branch is clean, use a neutral color
# Otherwise colors will vary according to time elapsed
function _git_time_since_commit() {
  # Only proceed if there is actually a commit
  if git log -1 > /dev/null 2>&1; then
    # Get the last commit
    last_commit=$(git log --pretty=format:'%at' -1 2> /dev/null)
    now=$(date +%s)
    seconds_since_last_commit=$((now - last_commit))

    # Totals
    minutes=$((seconds_since_last_commit / 60))
    hours=$((seconds_since_last_commit / 3600))
    days=$((seconds_since_last_commit / 86400))
    sub_hours=$((hours % 24))
    sub_minutes=$((minutes % 60))

    if [ $hours -ge 24 ]; then
      commit_age="${days}d "
    elif [ $minutes -gt 60 ]; then
      commit_age="${sub_hours}h${sub_minutes}m "
    else
      commit_age="${minutes}m"
    fi

    if [[ -n $(git status -s 2> /dev/null) ]]; then
      if [ "$hours" -gt 4 ]; then
        COlOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_LONG"
      elif [ "$minutes" -gt 30 ]; then
        COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_MEDIUM"
      else
        COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_SHORT"
      fi
    else
      COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL"
    fi

    echo "$COLOR$commit_age%{$reset_color%}"
  fi
}

local _git_prompt_info="%{$fg[cyan]%}%c $(git_prompt_info)%{$reset_color%}"
local _return_status="%{$fg[red]%}%(?..⍉ )%{$reset_color%}"

# The prompt
PROMPT='┌─[$(_user_host) $(git_prompt_info)$(git_prompt_status)$(git_prompt_short_sha)$(_git_time_since_commit)${_return_status}]
└─> '

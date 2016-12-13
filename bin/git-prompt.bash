#!/bin/bash

########################################################################
# Matthew's Git Bash Prompt
########################################################################
        RED="\[\033[0;31m\]"
     YELLOW="\[\033[0;33m\]"
      GREEN="\[\033[0;32m\]"
       BLUE="\[\033[0;34m\]"
  LIGHT_RED="\[\033[1;31m\]"
LIGHT_GREEN="\[\033[1;32m\]"
      WHITE="\[\033[1;37m\]"
 LIGHT_GRAY="\[\033[0;37m\]"
 COLOR_NONE="\[\e[0m\]"

function parse_git_branch {
  git rev-parse --git-dir &> /dev/null
  git_status="$(git status 2> /dev/null)"
  branch_pattern="^On branch ([^${IFS}]*)"
  remote_pattern_ahead="Your branch is ahead of '.*' by ([0-9]*) "
  remote_pattern_behind="Your branch is behind '.*' by ([0-9]*) "
  diverge_pattern="Your branch and (.*) have diverged"
  
  if [[ ! ${git_status}} =~ "working tree clean" ]]; then
    state=" ${WHITE}*"
  fi
  # add an else if or two here if you want to get more specific
  if [[ ${git_status} =~ ${remote_pattern_ahead} ]]; then
    remote_ahead=" ${YELLOW}${BASH_REMATCH[1]}↑"
  fi
  if [[ ${git_status} =~ ${remote_pattern_behind} ]]; then
    remote_behind=" ${YELLOW}${BASH_REMATCH[1]}↓"
  fi
  if [[ ${git_status} =~ ${diverge_pattern} ]]; then
    remote_diverge=" ${YELLOW}↕"
  fi
  if [[ ${git_status} =~ ${branch_pattern} ]]; then
    branch=${BASH_REMATCH[1]}
    echo " (${branch})${remote_ahead}${remote_behind}${remote_diverge}${state}"
  fi
}

function git_dirty_flag {
  git status 2> /dev/null | grep -c : | awk '{if ($1 > 0) print "⚡"}'
}


function prompt_func() {
  previous_return_value=$?;

  #The lowercase w is the full current working directory
  #prompt="${TITLEBAR}${BLUE}[${RED}\w${GREEN}$(parse_git_branch)${BLUE}]${COLOR_NONE}"

  #Capital W is just the trailing part of the current working directory
  prompt="${TITLEBAR}${BLUE}[${RED}\W${GREEN}$(parse_git_branch)${BLUE}]${COLOR_NONE}"

  # Error code
  returned_value=""
  if [[ $previous_return_value -ne 0 ]]; then
    returned_value="${RED}(${previous_return_value})${COLOR_NONE} "
  fi

  PS1="${returned_value}${prompt} "
}

PROMPT_COMMAND=prompt_func


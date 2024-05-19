#!/bin/zsh

# 1 2 3 4
# | | | `- Text
# | | `--- Text color
# | `----- Next color
# `------- Bg color
section() {
  bg_color="$1"
  n_color="$2"
  t_color="$3"
  text="$4"

  echo "%F$t_color%K$bg_color$text%F$n_color%k%f"
}

# 1
# `- Return code
return_err() {
  retcode="$1"
  if [ $retcode -ne 0 ]; then
    if [ "$retcode" -gt 128 ] && [ "$(kill -l $retcode)" != "$retcode" ]; then
      str="SIG$(kill -l $retcode)" 
    else
      str="$retcode"
    fi

    echo "$str"
  fi

  return 0
}

TMOUT=1
TRAPALRM() {
  zle reset-prompt
}

preexec() {
  unset __zsh_cmd_start
  unset __zsh_cmd_end
  unset SECTION_EXIT

  export __zsh_cmd_start=$(date '+%s%0N')
  export __zsh_PREEXEC_CALLED=1
}

# 1
# `- Time in ms
format_elapsed_time() {
  local ms_pool=$1
  local ms_sub=0

  ms_sub=$(( $ms_pool % 60000 ))
  local elapsed_min=$(( ( $ms_pool - $ms_sub ) / 60000 ))
  ms_pool=$ms_sub
  
  ms_sub=$(( $ms_pool % 1000 ))
  local elapsed_sec=$(( ( $ms_pool - $ms_sub ) / 1000 ))
  ms_pool=$ms_sub

  local elapsed_ms=$ms_pool

  local str=""

  [ $elapsed_min -gt 0 ] && str+=" ${elapsed_min}m"
  [ $elapsed_sec -gt 0 ] && str+=" ${elapsed_sec}s"
  { [ $elapsed_ms -gt 0 ] || [ $(( ! ($elapsed_min | $elapsed_sec) )) ] } && str+=" ${elapsed_ms}ms"

  echo "$str"
}

precmd() {
  local retcode=$?

  if [ ! $__zsh_cmd_start ]; then
    elapsed_ns=0
    elapsed_ms=0
  elif [ $__zsh_PREEXEC_CALLED ]; then
    __zsh_cmd_end=$(date '+%s%0N')
    elapsed_ns=$(( __zsh_cmd_end - __zsh_cmd_start ))
    elapsed_ms=$(( $elapsed_ns / 1000000 ))
    elapsed_sec=$(( $elapsed_ms / 1000 ))
  fi

  unset __zsh_PREEXEC_CALLED

  SECTION_HOST_FG="{black}"
  SECTION_ELAPSED_FG="{cyan}"
  SECTION_PATH_FG="{blue}"

  local EXIT_CODE="$(return_err $retcode)"
  if ! [ -z "$EXIT_CODE" ]; then
    SECTION_EXIT="$(section '{red}' "$SECTION_HOST_FG" '{default}' " %B$EXIT_CODE%b ")"
  fi

  SECTION_HOST="$(section "$SECTION_HOST_FG" "$SECTION_ELAPSED_FG" '{default}' ' %n@%M ')"

  SECTION_ELAPSED="$(section "$SECTION_ELAPSED_FG" "$SECTION_PATH_FG" '{default}' "$(format_elapsed_time $elapsed_ms) ")"
  SECTION_PATH="$(section "$SECTION_PATH_FG" '{black}' '{default}' ' %~ ')"

  PROMPT=""
  PROMPT+="$SECTION_EXIT"
  PROMPT+="$SECTION_HOST"
  PROMPT+="$SECTION_ELAPSED"
  PROMPT+="$SECTION_PATH"
  PROMPT+=" "

  RPROMPT='%F{blue}$(date "+%T")%f'
}
setopt PROMPT_SUBST

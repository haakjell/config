# gpin.sh — pin your `git graph` to the top of the terminal (bash).
#
# Source this from ~/.bashrc AFTER `eval "$(starship init bash)"`,
# then type `gpin` to toggle it on and off.
#
# The graph is redrawn just before each prompt, but `git log` only reruns
# when HEAD, a ref or the window size has changed.

GPIN_SHELL_LINES=${GPIN_SHELL_LINES:-10}   # rows kept for the shell at the bottom

__gpin_on=0
__gpin_key=
__gpin_out=

gpin() {
  if (( __gpin_on )); then
    __gpin_on=0
    printf '\e[r' >/dev/tty          # scroll region back to the full screen
    clear
  else
    __gpin_on=1
    __gpin_key=                      # force a fresh graph
    clear
  fi
}

__gpin_precmd() {
  local ret=$?
  (( __gpin_on )) || return $ret

  local lines cols top
  lines=$(tput lines) cols=$(tput cols)
  top=$(( lines - GPIN_SHELL_LINES ))   # last row of the pinned area

  # Outside a repo (or in a tiny window): behave like a normal terminal
  if (( top < 4 )) || ! git rev-parse --git-dir >/dev/null 2>&1; then
    printf '\e[r' >/dev/tty
    return $ret
  fi

  # Rerun git log only when HEAD, any ref or the window size changed
  local key
  key="$PWD|$lines|$cols|$({
      git symbolic-ref -q HEAD
      git rev-parse --verify -q HEAD
      git for-each-ref --format='%(objectname) %(refname)'
    } 2>/dev/null | cksum)"
  if [[ $key != "$__gpin_key" ]]; then
    __gpin_key=$key
    __gpin_out=$(git --no-pager graph --color=always -n $(( top - 1 )) 2>/dev/null \
                 | head -n $(( top - 1 )))
  fi

  # Where is the cursor? (so the prompt never ends up inside the pinned area)
  local row col
  IFS='[;' read -rs -d R -t 1 -p $'\e[6n' _ row col </dev/tty 2>/dev/tty
  row=${row:-$lines} col=${col:-1}

  local rule i=1 line
  printf -v rule '%*s' "$cols" ''
  rule=${rule// /─}

  {
    printf '\e[?7l'                                      # don't wrap long lines
    while IFS= read -r line; do
      printf '\e[%d;1H\e[2K%s\e[0m' "$i" "$line"
      (( i++ ))
    done <<< "$__gpin_out"
    for (( ; i < top; i++ )); do printf '\e[%d;1H\e[2K' "$i"; done
    printf '\e[%d;1H\e[2K\e[2m%s\e[0m' "$top" "$rule"    # dim separator line
    printf '\e[?7h'
    printf '\e[%d;%dr' $(( top + 1 )) "$lines"           # shell scrolls below it
    (( row <= top )) && row=$(( top + 1 ))
    printf '\e[%d;%dH' "$row" "$col"                     # put the cursor back
  } >/dev/tty

  return $ret
}

# Run after starship's own hook, so starship still sees the right exit status
if [[ ${PROMPT_COMMAND[*]} != *__gpin_precmd* ]]; then
  if [[ $(declare -p PROMPT_COMMAND 2>/dev/null) == "declare -a"* ]]; then
    PROMPT_COMMAND+=(__gpin_precmd)
  else
    PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND; }__gpin_precmd"
  fi
fi

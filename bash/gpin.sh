# gpin.sh — pin your `git graph` to the top of the terminal (bash 5+).
#
# Add `source /path/to/gpin.sh` to ~/.bashrc,
# then type `gpin` to toggle it on and off.
#
# The graph is redrawn just before each prompt, but `git log` only reruns
# when HEAD, a ref or the size of the pinned area has changed.
#
# Drag the dim separator line with the mouse to resize the graph.
# While gpin is on, the shell gets mouse events at the prompt, so hold
# Shift to select text or use the scroll wheel the normal way.

[[ $- == *i* ]] || return 0

GPIN_SHELL_LINES=${GPIN_SHELL_LINES:-10}   # rows kept for the shell at the bottom

__gpin_on=0
__gpin_key=
__gpin_out=
__gpin_top=0      # row of the separator, 0 when nothing is pinned
__gpin_ptop=0     # row where the current prompt starts
__gpin_drag=0

__gpin_mouse() {  # h = report mouse drags, l = stop
  printf '\e[?1002%s\e[?1006%s' "$1" "$1" >/dev/tty
}

gpin() {
  if (( __gpin_on )); then
    __gpin_on=0 __gpin_top=0
    __gpin_mouse l
    printf '\e[r' >/dev/tty          # scroll region back to the full screen
    clear
  else
    __gpin_on=1
    __gpin_key=                      # force a fresh graph
    clear
  fi
}

# Sets the caller's row and col to the cursor position
__gpin_cursor() {
  IFS='[;' read -rs -d R -t 1 -p $'\e[6n' _ row col </dev/tty 2>/dev/tty
  row=${row:-${LINES:-24}} col=${col:-1}
}

# Rerun git log only when HEAD, any ref or the pinned area's size changed
__gpin_refresh() {  # $1 = separator row, $2 = columns
  local key
  key="$PWD|$1|$2|$({
      git symbolic-ref -q HEAD
      git rev-parse --verify -q HEAD
      git for-each-ref --format='%(objectname) %(refname)'
    } 2>/dev/null | cksum)"
  if [[ $key != "$__gpin_key" ]]; then
    __gpin_key=$key
    __gpin_out=$(git --no-pager graph --color=always -n $(( $1 - 1 )) 2>/dev/null \
                 | head -n $(( $1 - 1 )))
  fi
}

# Draws the graph and separator, and makes the shell scroll below them.
# Moves the cursor, so callers put it back afterwards.
__gpin_draw() {  # $1 = separator row, $2 = lines, $3 = columns
  local top=$1 rule i=1 line
  printf -v rule '%*s' "$3" ''
  rule=${rule// /─}
  {
    printf '\e[?7l'                                      # don't wrap long lines
    while (( i < top )) && IFS= read -r line; do
      printf '\e[%d;1H\e[2K%s\e[0m' "$i" "$line"
      (( i++ ))
    done <<< "$__gpin_out"
    for (( ; i < top; i++ )); do printf '\e[%d;1H\e[2K' "$i"; done
    printf '\e[%d;1H\e[2K\e[2m%s\e[0m' "$top" "$rule"    # dim separator line
    printf '\e[?7h'
    printf '\e[%d;%dr' $(( top + 1 )) "$2"               # shell scrolls below it
  } >/dev/tty
  __gpin_top=$top
}

__gpin_precmd() {
  local ret=$?
  (( __gpin_on )) || return $ret

  local lines cols top
  lines=$(tput lines) cols=$(tput cols)
  top=$(( lines - GPIN_SHELL_LINES ))   # row of the separator

  # Outside a repo (or in a tiny window): behave like a normal terminal
  if (( top < 4 )) || ! git rev-parse --git-dir >/dev/null 2>&1; then
    __gpin_mouse l
    printf '\e[r' >/dev/tty
    __gpin_top=0
    return $ret
  fi

  __gpin_refresh "$top" "$cols"

  local row col
  __gpin_cursor
  __gpin_draw "$top" "$lines" "$cols"
  (( row <= top )) && row=$(( top + 1 ))   # prompt never inside the pinned area

  # Remember where the prompt starts, so dragging down can keep it visible.
  # Starship has already put the finished prompt in PS1 by now.
  local p=${PS1@P} nl
  nl=${p//[!$'\n']/}
  __gpin_ptop=$(( row + ${#nl} > lines ? lines - ${#nl} : row ))

  printf '\e[%d;%dH' "$row" "$col" >/dev/tty
  __gpin_mouse h
  return $ret
}

# Moves the separator to row $1 while dragging
__gpin_move() {
  local top=$1 lines=${LINES:-$(tput lines)} cols=${COLUMNS:-$(tput cols)}
  local row col need max i
  __gpin_cursor

  # At least 3 rows of graph, and never push the line you're typing off screen
  max=$(( __gpin_ptop - 1 + lines - row ))
  (( top > max )) && top=$max
  (( top < 4 )) && top=4
  (( top == __gpin_top )) && return

  if (( top > __gpin_top )); then
    # Graph grows: if it would cover the prompt, push the shell area down
    need=$(( top + 1 - __gpin_ptop ))
    if (( need > 0 )); then
      printf '\e[%d;%dr\e[%d;1H\e[%dL' $(( __gpin_top + 1 )) "$lines" \
             $(( __gpin_top + 1 )) "$need" >/dev/tty
      (( __gpin_ptop += need, row += need ))
    fi
  else
    # Graph shrinks: blank the rows it gives back to the shell
    for (( i = top + 1; i <= __gpin_top; i++ )); do
      printf '\e[%d;1H\e[2K' "$i" >/dev/tty
    done
  fi

  __gpin_draw "$top" "$lines" "$cols"
  printf '\e[%d;%dH' "$row" "$col" >/dev/tty
  GPIN_SHELL_LINES=$(( lines - top ))
}

# Readline calls this for every mouse event (SGR format: \e[<b;x;yM or m)
__gpin_mouse_event() {
  local c s=
  while IFS= read -rsn1 -t 0.05 c; do
    s+=$c
    [[ $c == [Mm] ]] && break
  done
  [[ $s =~ ^([0-9]+)\;[0-9]+\;([0-9]+)([Mm])$ ]] || return 0
  (( __gpin_on && __gpin_top )) || return 0

  local b=${BASH_REMATCH[1]} y=${BASH_REMATCH[2]}

  if [[ ${BASH_REMATCH[3]} == m ]]; then          # button released
    (( __gpin_drag )) || return 0
    __gpin_drag=0
    local lines=${LINES:-$(tput lines)} cols=${COLUMNS:-$(tput cols)} row col
    __gpin_refresh "$__gpin_top" "$cols"          # now fetch the right amount
    __gpin_cursor
    __gpin_draw "$__gpin_top" "$lines" "$cols"
    printf '\e[%d;%dH' "$row" "$col" >/dev/tty
  elif (( b == 0 )); then                         # left button pressed
    (( y == __gpin_top )) && __gpin_drag=1
  elif (( b == 32 && __gpin_drag )); then         # dragging with left button
    __gpin_move "$y"
  fi
  return 0
}

bind -x '"\e[<": __gpin_mouse_event'

# Stop mouse reporting before any command runs (Neovim, less, lazygit...)
[[ $PS0 == *'?1006l'* ]] || PS0+='\e[?1002l\e[?1006l'

# Run after starship's own hook, so starship still sees the right exit status
if [[ ${PROMPT_COMMAND[*]} != *__gpin_precmd* ]]; then
  if [[ $(declare -p PROMPT_COMMAND 2>/dev/null) == "declare -a"* ]]; then
    PROMPT_COMMAND+=(__gpin_precmd)
  else
    PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND; }__gpin_precmd"
  fi
fi

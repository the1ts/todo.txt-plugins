# shellcheck shell=bash
# edit
# We are in the edit action, return allowed files
if [[ ${COMP_WORDS[1]} = "edit" ]]; then
  # shellcheck disable=SC2207,SC2086,SC2154
  mapfile -t COMPREPLY < <(compgen -W "$(eval echo "todo done cfg")" -- "${word}")
  # If todo or done allow line number completion for each
  if [[ ${COMP_WORDS[2]} = "todo" ]]; then
    mapfile -t COMPREPLY < <(compgen -o nosort -W "$(eval echo "{1..$END}")" -- "${word}")
  elif [[ ${COMP_WORDS[2]} = "done" ]]; then
    mapfile -t COMPREPLY < <(compgen -o nosort -W "$(eval echo "{1..$DONE_END}")" -- "${word}")
  fi
fi

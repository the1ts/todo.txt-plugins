
# shellcheck shell=bash
COMMANDS="archive archivedstats list off on stats statsall unarchive"
cmd=${COMP_CWORD}
our_cmd=${COMP_WORDS[0]}
TODO_PROJ=$($our_cmd lsprj)
# Only capture todo.sh notes
if [[ ${COMP_WORDS[1]} =~ ^(timetracker|tt)$ ]]; then
  # Give commands as first complete
  if ((cmd==2)); then
    # shellcheck disable=SC2207,SC2086
	  COMPREPLY=($(compgen -W "$(eval echo $COMMANDS)" -- "${word}"));
  else
    # If cat, edit, rename or unarchive give list of notes
    case ${COMP_WORDS[2]} in
      on)
      # shellcheck disable=SC2207,SC2086
      COMPREPLY=($(compgen -W "$( (echo -e "$TODO_PROJ \n" ; $our_cmd timetracker simplelistcompleted) | sort -u)" -- "${word}"));
      ;;
      off)
      # shellcheck disable=SC2207,SC2086
      COMPREPLY=($(compgen -W "$(eval $our_cmd timetracker simplelistallstarted)" -- "${word}"));
      ;;
      archive)
      # shellcheck disable=SC2207,SC2086
      COMPREPLY=($(compgen -W "$(eval $our_cmd timetracker simplelistallstarted)" -- "${word}"));
      ;;
      unarchive)
      # shellcheck disable=SC2207,SC2086
      COMPREPLY=($(compgen -W "$(eval $our_cmd timetracker simplelistallcompleted)" -- "${word}"));
      ;;
      stats)
      # shellcheck disable=SC2207,SC2086
      COMPREPLY=($(compgen -W "$( (eval $our_cmd timetracker simplelistcompleted ; eval $our_cmd timetracker simpleliststarted ) | sort -u )" -- "${word}"));
      ;;
      archivedstats)
      # shellcheck disable=SC2207,SC2086
      COMPREPLY=($(compgen -W "$( (eval $our_cmd timetracker simplelistarchived | sed 's/^/+/g' ) | sort -u )" -- "${word}"));
      ;;
      esac
  fi
fi

# tton
# shellcheck disable=SC2207,SC2086
if [ ${COMP_WORDS[1]} = "tton" ]; then
    COMPREPLY=($(compgen -W "$( (echo -e "$TODO_PROJ \n" ; $our_cmd timetracker simplelistcompleted) | sort -u)" -- "${word}"));
fi

# ttoff
# shellcheck disable=SC2207,SC2086
if [ ${COMP_WORDS[1]} = "ttoff" ]; then
    COMPREPLY=($(compgen -W "$(eval $our_cmd timetracker simplelistallstarted)" -- "${word}"));
fi

# ttstats
# shellcheck disable=SC2207,SC2086
if [ ${COMP_WORDS[1]} = "ttstats" ]; then
    COMPREPLY=($(compgen -W "$( (eval $our_cmd timetracker simplelistcompleted ; eval $our_cmd timetracker simpleliststarted ) | sort -u )" -- "${word}"));
fi

# ttarchive
# shellcheck disable=SC2207,SC2086
if [ ${COMP_WORDS[1]} = "ttarchive" ]; then
    COMPREPLY=($(compgen -W "$(eval $our_cmd timetracker simplelistallstarted)" -- "${word}"));
fi

# ttunarchive
# shellcheck disable=SC2207,SC2086
if [ ${COMP_WORDS[1]} = "ttunarchive" ]; then
    COMPREPLY=($(compgen -W "$(eval $our_cmd timetracker simplelistallcompleted)" -- "${word}"));
fi
# todo.sh(1) completion
# Copyright 2009 Paul Mansfield <paul.mansfield@mansteck.co.uk>
# License: GNU GPL v2 or later

function _todo.sh()
{
	# Find how we are being run
	our_cmd=${COMP_WORDS[0]}
	cmd=${COMP_CWORD} 
	COMPREPLY=()
	word="${COMP_WORDS[COMP_CWORD]}"
	if ((cmd==1)); then
		# Help me pick a todo.sh action
		COMPREPLY=($( compgen -W "`todo.sh  -h| grep "^    "| awk '{print $1}'| sed 's/|/ /g' ; \
		  ls $HOME/.todo.actions.d/`" -- "$word"));
	else
		# help me pick a project
		case ${COMP_WORDS[1]} in
			"lsprj"|"listproj")
        COMPREPLY=($(compgen -W "$(eval $our_cmd lsprj | tr -d '\r')" -- "${word}"));
		  ;;
		  # help me pick a context
		  "lsc"|"listcon")
		    COMPREPLY=($(compgen -W "$(eval $our_cmd lsc | tr -d '\r')" -- "${word}"));
		  ;;
		  # help me pick a note file
			"na"|"notesarchive"|"nc"|"notescat"|"ne"|"notesedit")
		    COMPREPLY=($(compgen -W "$(eval $our_cmd lsn | tr -d '\r')" -- "${word}"));
		  ;;
		  # help me pick a context or project
			"a"|"add"|"addto"|"ls"|"list")
		    COMPREPLY=($(compgen -W "$(eval $our_cmd lsprj | tr -d '\r') $(eval $our_cmd lsc | tr -d '\r')" -- "${word}"));
		  ;;
			# help me pick a context of project if an item number is already set
      "app"|"append"|"prep"|"prepend"|"replace")
			  if [ `echo ${COMP_WORDS[2]} | grep -c "[0-9]"` = 1 ] ; then
		      COMPREPLY=($(compgen -W "$(eval $our_cmd lsprj | tr -d '\r') $(eval $our_cmd lsc | tr -d '\r')" -- "${word}"));
        fi
			;;
    esac
	fi
}
# add any aliases for todo.sh after _todo.sh
complete -F _todo.sh todo.sh t tt tw tp

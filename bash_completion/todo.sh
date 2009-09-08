# todo.sh(1) completion
# Copyright 2003 Eelco Lempsink <eelcolempsink@gmx.net>
# License: GNU GPL v2 or later

function _todo.sh()
{
	#Find how we are being run
	our_cmd=${COMP_WORDS[0]}
	cmd=${COMP_CWORD} 
	COMPREPLY=()
	word="${COMP_WORDS[COMP_CWORD]}"
	if ((cmd==1)); then
		# Help me pick a todo.sh action
		COMPREPLY=($( compgen -W "`todo.sh  -h| grep "^    "| awk '{print $1}'| sed 's/|/ /g' ; ls $HOME/.todo.actions.d/`" -- "$word"));
	else
		# help me pick a project or context
		case ${COMP_WORDS[1]} in
			"lsprj"|"listproj")
		COMPREPLY=($(compgen -W "$(eval $our_cmd lsprj | tr -d '\r')" -- "${word}"));
		;;
			"lsc"|"listcon")
		COMPREPLY=($(compgen -W "$(eval $our_cmd lsc | tr -d '\r')" -- "${word}"));
		;;
			"add"|"addto"|"append"|"prepend"|"replace")
		COMPREPLY=($(compgen -W "$(eval $our_cmd lsprj | tr -d '\r') $(eval $our_cmd lsc | tr -d '\r')" -- "${word}"));
		;;
		esac
	fi
}
complete -F _todo.sh todo.sh t tt tw tp

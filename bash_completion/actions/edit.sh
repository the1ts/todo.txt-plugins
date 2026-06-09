# shellcheck shell=bash
# edit
if [[ ${COMP_WORDS[1]} = "edit" ]]; then
	# shellcheck disable=SC2207,SC2086,SC2154
	mapfile -t COMPREPLY < <(compgen -W "$(eval echo "todo done cfg")" -- "${word}")
	if [[ ${COMP_WORDS[2]} ]]; then
		# shellcheck disable=SC2207,SC2175,SC2086
		mapfile -t COMPREPLY < <(compgen -o nosort -W "$(eval echo "+{1..$END}")" -- "${word}")
	fi
fi


# tickle
word="${COMP_WORDS[COMP_CWORD]}"
if [[ ${COMP_WORDS[1]} = "tickle" ]]; then
	# shellcheck disable=SC2207,SC2175,SC2086
	mapfile -t COMPREPLY < <(compgen -o nosort -W "$(eval echo {1..$END})" -- "${word}")
	if [[ ${COMP_WORDS[2]} =~ .*[0-9] ]]; then
		mapfile -t COMPREPLY < <(compgen -W "$(eval echo d{1..31} m{1..12})" -- "${word}")
	fi
fi

# projectview bash_completion
our_cmd=${COMP_WORDS[0]}
word="${COMP_WORDS[COMP_CWORD]}"
if [[ ${COMP_WORDS[1]} = "projectview" ]] || [[ ${COMP_WORDS[1]} = "pv" ]]; then
	mapfile -t COMPREPLY < <(compgen -W "$(eval "${our_cmd}" lsprj | tr -d '\r') $(eval "${our_cmd}" lsc | tr -d '\r')" -- "${word}")
fi

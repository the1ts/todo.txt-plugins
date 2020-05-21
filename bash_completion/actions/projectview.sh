if [[ ${COMP_WORDS[1]} = "projectview" ]] || [[ ${COMP_WORDS[1]} = "pv" ]]; then
	COMPREPLY=($(compgen -W "$(eval $our_cmd lsprj | tr -d '\r') $(eval $our_cmd lsc | tr -d '\r')" -- "${word}"));
fi


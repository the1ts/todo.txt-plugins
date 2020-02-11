# notesedit
if [[ ${COMP_WORDS[1]} =~ (enotesedit|ene) ]] ; then
	# shellcheck disable=SC2207,SC2086
	COMPREPLY=($(compgen -W "$(eval $our_cmd listenotes)" -- "${word}"));
fi

# notescat
if [[ ${COMP_WORDS[1]} =~ (enotescat|enc) ]]; then
	# shellcheck disable=SC2207,SC2086
	COMPREPLY=($(compgen -W "$(eval $our_cmd listenotes)" -- "${word}"));
fi

# notesarchive
if [[ ${COMP_WORDS[1]} =~ (enotesarchive|ena) ]]; then
	# shellcheck disable=SC2207,SC2086
	COMPREPLY=($(compgen -W "$(eval $our_cmd listenotes)" -- "${word}"));
fi

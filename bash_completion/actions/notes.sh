# notesedit 
if [[ ${COMP_WORDS[1]} =~ (notesedit|ne) ]]; then
	# shellcheck disable=SC2207,SC2086
	COMPREPLY=($(compgen -W "$(eval $our_cmd listnotes)" -- "${word}"));
fi

# notescat
if [[ ${COMP_WORDS[1]} =~ (notescat|nc) ]]; then
	# shellcheck disable=SC2207,SC2086
	COMPREPLY=($(compgen -W "$(eval $our_cmd listnotes)" -- "${word}"));
fi

# notesarchive
if [[ ${COMP_WORDS[1]} =~ (notesarchive|na) ]]; then
	# shellcheck disable=SC2207,SC2086
	COMPREPLY=($(compgen -W "$(eval $our_cmd listnotes)" -- "${word}"));
fi

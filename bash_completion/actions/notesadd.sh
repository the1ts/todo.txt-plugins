# notesadd
if [[ ${COMP_WORDS[1]} = "notesadd" ]]; then
	# shellcheck disable=SC2207,SC2175,SC2086
	COMPREPLY=($(compgen -o nosort -W "$(echo "+";eval echo {1..$END})" -- "${word}"));
	if [[ ${COMP_WORDS[2]} =~ .*[0-9]  ]]; then
		COMPREPLY=($(compgen -W "$(eval $our_cmd lsp | tr -d '\r' | sed 's/^/+/g') $(eval $our_cmd lsc | tr -d '\r') $(eval $our_cmd lsn | tr -d '\r')" -- "${word}"));
	fi
fi

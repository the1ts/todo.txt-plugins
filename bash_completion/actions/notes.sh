# notesedit 
if [[ ${COMP_WORDS[1]} = "notesedit" ]] || [[ ${COMP_WORDS[1]} = "ne" ]]; then
    COMPREPLY=($(compgen -W "$(eval $our_cmd listnotes)" -- "${word}"));
fi

# notescat
if [[ ${COMP_WORDS[1]} = "notescat" ]] || [[ ${COMP_WORDS[1]} = "nc" ]]; then
    COMPREPLY=($(compgen -W "$(eval $our_cmd listnotes)" -- "${word}"));
fi

# notesarchive
if [[ ${COMP_WORDS[1]} = "notesarchive" ]] || [[ ${COMP_WORDS[1]} = "na" ]]; then
    COMPREPLY=($(compgen -W "$(eval $our_cmd listnotes)" -- "${word}"));
fi

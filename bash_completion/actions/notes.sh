# notesedit 
if [ ${COMP_WORDS[1]} = "notesedit" -o ${COMP_WORDS[1]} = "ne" ]; then
    COMPREPLY=($(compgen -W "$(eval $our_cmd listnotes)" -- "${word}"));
fi

# notescat
if [ ${COMP_WORDS[1]} = "notescat" -o ${COMP_WORDS[1]} = "nc" ]; then
    COMPREPLY=($(compgen -W "$(eval $our_cmd listnotes)" -- "${word}"));
fi

# notesarchive
if [ ${COMP_WORDS[1]} = "notearchive" -o ${COMP_WORDS[1]} = "na" ]; then
    COMPREPLY=($(compgen -W "$(eval $our_cmd listnotes)" -- "${word}"));
fi

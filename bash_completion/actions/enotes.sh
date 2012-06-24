# notesedit 
if [ ${COMP_WORDS[1]} = "enotesedit" -o ${COMP_WORDS[1]} = "ene" ]; then
    COMPREPLY=($(compgen -W "$(eval $our_cmd listenotes)" -- "${word}"));
fi

# notescat
if [ ${COMP_WORDS[1]} = "enotescat" -o ${COMP_WORDS[1]} = "enc" ]; then
    COMPREPLY=($(compgen -W "$(eval $our_cmd listenotes)" -- "${word}"));
fi

# notesarchive
if [ ${COMP_WORDS[1]} = "enotearchive" -o ${COMP_WORDS[1]} = "ena" ]; then
    COMPREPLY=($(compgen -W "$(eval $our_cmd listenotes)" -- "${word}"));
fi

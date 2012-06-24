# Timetracker first options
if [ ${COMP_WORDS[1]} = "timetracker" -a ${#COMP_WORDS[@]} -eq 3 ]; then
    TTCOMMANDS="archive archivedstats list off on stats statsall unarchive"
    COMPREPLY=($(compgen -W "${TTCOMMANDS}" -- "${word}"));
    # Timetracker second level completion
fi

# Timetracker second options
if [ ${COMP_WORDS[1]} = "timetracker" -a ${#COMP_WORDS[@]} -gt 3 ]; then
    case ${COMP_WORDS[@]:1:2} in
    "timetracker on")
        COMPREPLY=($(compgen -W "$(eval $our_cmd listproj)" -- "${word}"));
    ;;
    "timetracker off"|"timetracker archive"|"timetracker stats")
        COMPREPLY=($(compgen -W "$(eval $our_cmd timetracker simplelist)" -- "${word}"));
    ;;
    "timetracker archivedstats"|"timetracker unarchive")
        COMPREPLY=($(compgen -W "$(eval $our_cmd timetracker simplearchivedlist)" -- "${word}"));
    ;;
    "timetracker statsall")
        COMPREPLY=($(compgen -W "$(eval $our_cmd timetracker simplelistall)" -- "${word}"));
   ;;
    esac
fi

# tt
if [ ${COMP_WORDS[1]} = "tt" ]; then
    COMPREPLY=($(compgen -W "archive list on off stats unarchive" -- "${word}"));
fi

# tton
if [ ${COMP_WORDS[1]} = "tton" ]; then
    COMPREPLY=($(compgen -W "$(eval $our_cmd lsp | tr -d '\r' | sed 's/^/+/g')" -- "${word}"));
fi

# ttoff
if [ ${COMP_WORDS[1]} = "ttoff" ]; then
    COMPREPLY=($(compgen -W "$(eval $our_cmd timetracker list | grep -A 2 Current | tail -1)" -- "${word}"));
fi

# ttarchive
if [ ${COMP_WORDS[1]} = "ttarchive" ]; then
    COMPREPLY=($(compgen -W "$(eval $our_cmd timetracker list | grep -A 2 Current | tail -1)" -- "${word}"));
fi

# ttunarchive
if [ ${COMP_WORDS[1]} = "ttunarchive" ]; then
    COMPREPLY=($(compgen -W "$(eval $our_cmd timetracker list | grep -A 2 Archived | tail -1)" -- "${word}"));
fi

# ttstats, use timetracker list to get current projects only
if [ ${COMP_WORDS[1]} = "ttstats" ]; then
    COMPREPLY=($(compgen -W "$(eval $our_cmd timetracker list | grep -A 2 Current | tail -1)" -- "${word}"));
fi

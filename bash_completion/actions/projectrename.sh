# Projectrename first options (List of all projects)
if [[ ${COMP_WORDS[1]} =~ (projectrename|prr) ]] && \
	[[ ${#COMP_WORDS[@]} -eq 3 ]]; then
	# shellcheck disable=SC2207,SC2086,SC2030
	COMPREPLY=($(compgen -W "$(export TODOTXT_PLAIN=1; eval $our_cmd listproj \
		| sort -n)" -- "${word}"));
fi
# Projectrename second options (List of all projects the one we are renaming)
if [[ ${COMP_WORDS[1]} =~ (projectrename|prr) ]] && \
	[[ ${#COMP_WORDS[@]} -eq 4 ]]; then
	# shellcheck disable=SC2207,SC2086,SC2030,SC2031
	COMPREPLY=($(compgen -W "$(export TODOTXT_PLAIN=1; eval $our_cmd listproj \
		| sort -n | grep -v ${COMP_WORDS[2]})" -- "${word}"));
fi
# Projectrename third options 
# (List all items containing the project we are renaming)
	# shellcheck disable=SC2207,SC2086,SC2030,SC2031
if [[ ${COMP_WORDS[1]} =~ (projectrename|prr) ]] && \
	[[ ${#COMP_WORDS[@]} -eq 5 ]]; then
	COMPREPLY=($(compgen -W "$(export TODOTXT_PLAIN=1; \
		eval $our_cmd ls ${COMP_WORDS[2]} | awk '/^[0-9]/{print $1}' \
		| tr -d '\r' | sort -n)" -- "${word}"));
fi

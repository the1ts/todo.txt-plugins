# Projectrename first options (List of all projects)
our_cmd=${COMP_WORDS[0]}
word="${COMP_WORDS[COMP_CWORD]}"
if [[ ${COMP_WORDS[1]} =~ (projectrename|prr) ]] &&
	[[ ${#COMP_WORDS[@]} -eq 3 ]]; then
	# shellcheck disable=SC2207,SC2086,SC2030
	mapfile -t COMPREPLY < <(compgen -W "$(eval "${our_cmd}" lsprj)" -- "${word}")
fi
# Projectrename second options (List of all projects the one we are renaming)
if [[ ${COMP_WORDS[1]} =~ (projectrename|prr) ]] &&
	[[ ${#COMP_WORDS[@]} -eq 4 ]]; then
	# shellcheck disable=SC2207,SC2086,SC2030,SC2031
	mapfile -t COMPREPLY < <(compgen -W "$(eval "${our_cmd}" lsprj | grep -v ${COMP_WORDS[2]})" -- "${word}")
fi
# Projectrename third options
# (List all items containing the project we are renaming)
# shellcheck disable=SC2207,SC2086,SC2030,SC2031
if [[ ${COMP_WORDS[1]} =~ (projectrename|prr) ]] &&
	[[ ${#COMP_WORDS[@]} -eq 5 ]]; then
	mapfile -t COMPREPLY < <(compgen -W "$(eval "${our_cmd}" ls ${COMP_WORDS[2]} | awk '/^[0-9]/{print $1}')" -- "${word}")
fi

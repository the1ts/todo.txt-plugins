# shellcheck shell=bash
COMMANDS="add archive cat edit grep list listarchived rename unarchive"
cmd=${COMP_CWORD}
our_cmd=${COMP_WORDS[0]}
word="${COMP_WORDS[COMP_CWORD]}"
# Only capture todo.sh notes
if [[ ${COMP_WORDS[1]} = notes ]]; then
	# Give commands as first complete
	if ((cmd == 2)); then
		# shellcheck disable=SC2207,SC2086
		mapfile -t COMPREPLY < <(compgen -W "$(eval echo $COMMANDS)" -- "${word}")
	else
		# If add give back list of items 1 to END
		if [[ ${COMP_WORDS[2]} = add ]]; then
			# shellcheck disable=SC2086
			END=$(TODOTXT_VERBOSE=0 eval ${our_cmd} list | wc -l | cut -d ' ' -f 1)
			# shellcheck disable=SC2207,SC2086,SC2175
			mapfile -t COMPREPLY < <(compgen -W "$(eval echo "{1..${END}}" | tr '\n' ' ')" -- "${word}")
			# If add and number give list of notes
			if [[ ${COMP_WORDS[3]} =~ .*[0-9] ]]; then
				# shellcheck disable=SC2207,SC2086
				mapfile -t COMPREPLY < <(compgen -W "$(eval ${our_cmd} lsn)" -- "${word}")
			fi
		fi
		# If cat, edit, rename or unarchive give list of notes
		if [[ ${COMP_WORDS[2]} =~ (cat|edit|rename|unarchive) ]]; then
			# shellcheck disable=SC2207,SC2086
			mapfile -t COMPREPLY < <(compgen -W "$(eval ${our_cmd} lsn)" -- "${word}")
		fi
	fi
fi


# -*- mode: shell-script; sh-basic-offset: 8; indent-tabs-mode: t -*-
# ex: ts=8 sw=8 noet filetype=sh
#
# todo.sh(1) completion
# Copyright 2003 Eelco Lempsink <eelcolempsink@gmx.net>
# License: GNU GPL v2 or later

_todo.sh()
{
	local cur

	COMPREPLY=()
	#cur=`_get_cword`
	cur="${COMP_WORDS[COMP_CWORD]}"

	case "$cur" in
	    *)
		    COMPREPLY=( $( compgen -W "`todo.sh  -h| grep "^    "| awk '{print $1}'| sed 's/|/ /g' ; ls $HOME/.todo.actions.d/` " -- $cur ) )
		;;
	esac

	return 0
}
complete -F _todo.sh $default todo.sh

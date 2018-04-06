#!/bin/sh
#
# When you give the standard `ls` multiple TERMS, it runs through them
# one by one, passing the matches on to the next TERM. 
# So `todo.sh ls foo bar` first finds all tasks with 'foo' and 
# then takes the output of that and looks for 'bar'. 
# 
# This changes that behavior so that `ls foo bar` selects all
# tasks with either 'foo' or 'bar', regardless of the order they're in.
#
# A shorter way to say this might be that the default `ls` uses
# 'AND' between terms and this uses 'OR'.
#
# I wrote this to replace the default `ls` and it mostly just works
# as a wrapper around the regular `ls` that intervenes when you 
# provide it with multiple positive TERMS but otherwise sends
# you along to the regular `ls`
#
# Author: Jon Smajda
# License: GPL, http://www.gnu.org/copyleft/gpl.html
# URL: http://github.com/smajda/todo.actions.d


action=$1
shift

# what to display in todo.sh -h, appended to very end
[ "$action" = "usage" ] && {
    echo "  `basename $0` [TERM...]"
    echo "    A wrapper around the standard 'ls' that changes "
    echo "    the search logic for multiple positive TERMS from" 
    echo "    AND to OR"
    echo "    See $0"
    echo ""
    exit
}


# if there aren't arguments, just run regular ls and quit
if [[ -z "$@" ]];
then
    "$TODO_SH" command ls
    exit
fi

# if there's only one argument, just run regular ls and quit
if [[ ! `echo "${@}" | grep ' '` ]]
then
    "$TODO_SH" command ls "$@"
    exit
fi


### If more than one TERM:
# separate search_terms into hide and show terms.
for search_term in "$@"
do
    # add the - terms to hide_terms, others to show_terms
    if [ ${search_term:0:1} != '-' ]
    then
        show_terms=${show_terms}' '${search_term}
    else
        hide_terms=${hide_terms}' '${search_term}
    fi
done

if [[ ! -z ${show_terms} ]];
then

    for term in ${show_terms}
    do
        # escape the +'s
        term=`echo -n "$term "| sed -e 's/\+/\\\+/g' -e 's/\ $//g'`

        # insert |'s
        grep_terms=${grep_terms}'|'${term}

        # remove | for first item
        grep_terms=`echo -n ${grep_terms} | sed 's/^|//g'`
    done

    # send the hide terms to ls and grep for show terms
    "$TODO_SH" command ls ${hide_terms} | grep -E ${grep_terms}
else
    "$TODO_SH" command ls "$@"
fi


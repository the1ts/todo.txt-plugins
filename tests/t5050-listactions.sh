#!/bin/bash

test_description='lists actions functionality
'
. ./test-lib.sh

# Set our current actions directory
export TODO_ACTIONS_DIR=$TEST_DIRECTORY/../actions/lists

test_todo_session 'listactions usage' <<EOF
>>> todo.sh listactions usage
    listactions
      list all possible actions
=== 0
EOF

test_todo_session 'lsac usage' <<EOF
>>> todo.sh lsac usage
    listactions
      list all possible actions
=== 0
EOF

test_todo_session 'listactions run' <<EOF
>>> todo.sh listactions
a
add
addm
addto
archive
command
del
delpri
do
done
duplicate
help
lf
list
listactions
listaddons
listall
listcon
listfile
listpri
listproj
lsa
lsac
lsp
lsprj
lsprjnopri
move
mv
p
prep
prepend
pri
replace
report
rm
shorthelp
=== 0
EOF

test_done

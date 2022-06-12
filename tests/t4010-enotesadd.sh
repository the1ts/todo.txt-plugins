#!/bin/bash

test_description='enotes actions functionality
'
. ./test-lib.sh -i

export TODO_ACTIONS_DIR=$TEST_DIRECTORY/../actions/enotes

cat > todo.txt <<EOF
Buy tools
Fix bicycle
Ride bike
EOF

test_todo_session 'enotesadd show usage' <<EOF
>>> todo.sh enotesadd usage
    enotes add [ITEMS] [ENOTESFILE]
      append ENOTESFILE to ITEMS and edit ENOTESFILE if new
=== 1
EOF

test_todo_session 'ena show usage' <<EOF
>>> todo.sh ena usage
    enotes add [ITEMS] [ENOTESFILE]
      append ENOTESFILE to ITEMS and edit ENOTESFILE if new
=== 1
EOF

test_todo_session 'enotesadd enote to task' <<EOF
>>> todo.sh enotesadd 1 test
1 Buy tools enote:test
TODO: enote:test added to item 1
=== 0
EOF

test_todo_session 'enotesadd item only no note' <<EOF
>>> todo.sh enotesadd 1
      No enotesfile given
    enotes add [ITEMS] [ENOTESFILE]
      append ENOTESFILE to ITEMS and edit ENOTESFILE if new
=== 1
EOF

test_todo_session 'enotesadd no item only note' <<EOF
>>> todo.sh enotesadd testing
      No item given
    enotes add [ITEMS] [ENOTESFILE]
      append ENOTESFILE to ITEMS and edit ENOTESFILE if new
=== 1
EOF

test_todo_session 'enotesadd item nonexistant' <<EOF
>>> todo.sh enotesadd 100 testing
      ITEM 100 not in todo file
    enotes add [ITEMS] [ENOTESFILE]
      append ENOTESFILE to ITEMS and edit ENOTESFILE if new
=== 1
EOF

test_todo_session 'enotesadd multiple items and note' <<EOF
>>> todo.sh enotesadd 2 3 testing
2 Fix bicycle enote:testing
TODO: enote:testing added to item 2
3 Ride bike enote:testing
TODO: enote:testing added to item 3
=== 0
EOF

test_done

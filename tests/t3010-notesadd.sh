#!/bin/bash

test_description='notes actions functionality
'
. ./test-lib.sh -i

export TODO_ACTIONS_DIR=$TEST_DIRECTORY/../actions/notes

cat > todo.txt <<EOF
Buy tools
Fix bicycle
Ride bike
EOF

test_todo_session 'notesadd show usage' <<EOF
>>> todo.sh notesadd usage
    notes add [ITEMS] [NOTESFILE]
      append NOTESFILE to ITEMS and edit NOTESFILE if new
=== 1
EOF

test_todo_session 'na show usage' <<EOF
>>> todo.sh na usage
    notes add [ITEMS] [NOTESFILE]
      append NOTESFILE to ITEMS and edit NOTESFILE if new
=== 1
EOF

test_todo_session 'notesadd note to task' <<EOF
>>> todo.sh notesadd 1 test
1 Buy tools note:test
TODO: note:test added to item 1
=== 0
EOF

test_todo_session 'notesadd item only no note' <<EOF
>>> todo.sh notesadd 1
      No notesfile given
    notes add [ITEMS] [NOTESFILE]
      append NOTESFILE to ITEMS and edit NOTESFILE if new
=== 1
EOF

test_todo_session 'notesadd no item only note' <<EOF
>>> todo.sh notesadd testing
      No item given
    notes add [ITEMS] [NOTESFILE]
      append NOTESFILE to ITEMS and edit NOTESFILE if new
=== 1
EOF

test_todo_session 'notesadd item nonexistant' <<EOF
>>> todo.sh notesadd 100 testing
      ITEM 100 not in todo file
    notes add [ITEMS] [NOTESFILE]
      append NOTESFILE to ITEMS and edit NOTESFILE if new
=== 1
EOF

test_todo_session 'notesadd multiple items and note' <<EOF
>>> todo.sh notesadd 2 3 testing
2 Fix bicycle note:testing
TODO: note:testing added to item 2
3 Ride bike note:testing
TODO: note:testing added to item 3
=== 0
EOF

test_done

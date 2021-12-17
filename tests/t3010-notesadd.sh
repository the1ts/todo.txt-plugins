#!/bin/bash

test_description='notes actions functionality
'
. ./test-lib.sh

export TODO_ACTIONS_DIR=$TEST_DIRECTORY/../actions/notes

cat > todo.txt <<EOF
Buy tools
Fix bicycle
Ride bike
EOF

test_todo_session 'notesadd show usage' <<EOF
>>> todo.sh notesadd usage
    notesadd [ITEMS] [NOTESFILE]
      add NOTESFILE in ITEMS
=== 0
EOF

test_todo_session 'na show usage' <<EOF
>>> todo.sh na usage
    notesadd [ITEMS] [NOTESFILE]
      add NOTESFILE in ITEMS
=== 0
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
    notesadd [ITEMS] [NOTESFILE]
      add NOTESFILE in ITEMS
=== 1
EOF

test_todo_session 'notesadd no item only note' <<EOF
>>> todo.sh notesadd testing
      No item given
    notesadd [ITEMS] [NOTESFILE]
      add NOTESFILE in ITEMS
=== 1
EOF

test_todo_session 'notesadd item nonexistant' <<EOF
>>> todo.sh notesadd 100 testing
      No item 100
    notesadd [ITEMS] [NOTESFILE]
      add NOTESFILE in ITEMS
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

#!/bin/bash

test_description='list unsorted action functionality
'
. ./test-lib.sh

export TODO_ACTIONS_DIR=$TEST_DIRECTORY/../actions/lists

cat >todo.txt <<EOF
Ride bike +fix
Buy tools +purchase
Fix bicycle +repair
EOF

test_todo_session 'lsu show usage' <<EOF
>>> todo.sh lsu usage
    lsu
      lists todo.txt file unsorted
=== 0
EOF

test_todo_session 'lsu show list' <<EOF
>>> todo.sh lsu
1 Ride bike +fix
2 Buy tools +purchase
3 Fix bicycle +repair
--
TODO: 3 of 3 tasks shown
=== 0
EOF
test_done

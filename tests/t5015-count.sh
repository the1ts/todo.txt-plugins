#!/bin/bash

test_description='count number of items action functionality
'
. ./test-lib.sh

export TODO_ACTIONS_DIR=$TEST_DIRECTORY/../actions/count

cat >todo.txt <<EOF
Ride bike +fix
Buy tools +purchase
Fix bicycle +repair
EOF

test_todo_session 'count show usage' <<EOF
>>> todo.sh count usage
    count
      count how many lines in todo.txt file can take normal search items
=== 0
EOF

test_todo_session 'count items' <<EOF
>>> todo.sh count
3
=== 0
EOF

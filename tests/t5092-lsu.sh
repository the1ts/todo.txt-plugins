#!/bin/bash

test_description='notes actions functionality
'
. ./test-lib.sh

export TODO_ACTIONS_DIR=$TEST_DIRECTORY/../actions/lists
# Set editor to cat so it tests nicely.
export EDITOR="cat"

# Create our todo.txt file
cat > todo.txt <<EOF
Fix bicycle note:testing
Another line
EOF

test_todo_session 'lsu usage' <<EOF
>>> todo.sh lsu usage
    lsu
      lists todo.txt file unsorted
=== 0
EOF

# As we are doing and unsorted, Fix... is above Another...
test_todo_session 'lsu' <<EOF
>>> todo.sh lsu
1 Fix bicycle note:testing
2 Another line
--
TODO: 2 of 2 tasks shown
=== 0
EOF

test_done
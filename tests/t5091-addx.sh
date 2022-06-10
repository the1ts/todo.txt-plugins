#!/bin/bash

test_description='notes actions functionality
'
. ./test-lib.sh

export TODO_ACTIONS_DIR=$TEST_DIRECTORY/../actions/misc
# Set editor to cat so it tests nicely.
export EDITOR="cat"

# Create our todo.txt file
cat > todo.txt <<EOF
Fix bicycle note:testing
EOF

test_todo_session 'addx usage' <<EOF
>>> todo.sh addx usage
    addx [TASK]
      Add item already completed
=== 0
EOF

# Test adding and doing, lsa in plain will show our new task done
test_todo_session 'addx new item' <<EOF
>>> todo.sh addx new task ; TODOTXT_PLAIN=1 todo.sh lsa
2 new task
TODO: 2 added.
1 Fix bicycle note:testing
0 x 2009-02-13 new task
--
TODO: 1 of 1 tasks shown
DONE: 1 of 1 tasks shown
total 2 of 2 tasks shown
=== 0
EOF

test_todo_session 'addx no task' <<EOF
>>> todo.sh addx
      No task given
    addx [TASK]
      Add item already completed
=== 1
EOF

test_done

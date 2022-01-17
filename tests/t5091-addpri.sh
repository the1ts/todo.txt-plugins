#!/bin/bash

test_description='Add task with priority
'
. ./test-lib.sh

export TODO_ACTIONS_DIR=$TEST_DIRECTORY/../actions/misc
# Set editor to cat so it tests nicely.
export EDITOR="cat"

# Create our todo.txt file
cat > todo.txt <<EOF
Fix bicycle note:testing
EOF

test_todo_session 'addpri usage' <<EOF
>>> todo.sh addpri usage
    addpri [PRIORITY] [TASK]
      Add item with priority
=== 0
EOF

test_todo_session 'addpri create a new task' <<EOF
>>> todo.sh addpri D Test task
2 (D) Test task
TODO: 2 added.
=== 0
EOF

test_todo_session 'addpri no priority set' <<EOF
>>> todo.sh addpri
      No priority set
    addpri [PRIORITY] [TASK]
      Add item with priority
=== 1
EOF

test_todo_session 'addpri priority is not a single letter' <<EOF
>>> todo.sh addpri AB Test task
      Priority must be a single letter A-Z
    addpri [PRIORITY] [TASK]
      Add item with priority
=== 1
EOF

test_todo_session 'addpri priority is set, task blank' <<EOF
>>> todo.sh addpri A
      No task given
    addpri [PRIORITY] [TASK]
      Add item with priority
=== 1
EOF

test_done

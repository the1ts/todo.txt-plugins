#!/bin/bash
#

# shellcheck disable=SC2034
test_description='Bash context completion functionality

This test checks todo_completion of contextview
'
# shellcheck disable=SC1091
. ./test-lib.sh -i

# Set our current actions directory
export TODO_ACTIONS_DIR=$TEST_DIRECTORY/../actions/contextview
# Set editor to cat so it tests nicely.
export EDITOR="cat"
export TODO_ACTIONS_COMP=$TEST_DIRECTORY/../bash_completion/actions
complete -r todo.sh
# shellcheck disable=SC1091
source "${TEST_DIRECTORY}/../bash_completion/todo.txt"
cat >todo.txt <<EOF
(B) smell the +roses @outside @outdoor +shared
notice the sunflowers +sunflowers @outside @garden +shared +landscape note:garden
touch the grass +recover
stop
EOF
test_todo_completion 'contextview complete projects and contexts' 'todo.sh contextview ' '+landscape +recover +roses +shared +sunflowers @garden @outdoor @outside'
test_todo_completion 'contextview complete contexts' 'todo.sh contextview @' '@garden @outdoor @outside'
test_todo_completion 'contextview complete projects' 'todo.sh contextview +' '+landscape +recover +roses +shared +sunflowers'

test_done

#!/bin/bash
#

# shellcheck disable=SC2034
test_description='Bash context completion functionality

This test checks todo_completion of enotes
'
# shellcheck disable=SC1091
. ./test-lib.sh -i 

# Set our current actions directory
export TODO_ACTIONS_DIR=$TEST_DIRECTORY/../actions/enotes
# Set editor to cat so it tests nicely.
export EDITOR="cat"
export TODO_ACTIONS_COMP=$TEST_DIRECTORY/../bash_completion/actions
# Remove existing bash completion for todo.sh and add in our one.
complete -r todo.sh
# shellcheck disable=SC1091
source "${TEST_DIRECTORY}/../bash_completion/todo.txt"
mkdir -p enotes/archive
cat > todo.txt <<EOF
(B) smell the +roses @outside @outdoor +shared enote:roses
notice the sunflowers +sunflowers @outside @garden +shared +landscape enote:garden
stop
EOF
cat > ./enotes/archive/todo-test_garden.10100000.enc << EOF
test note first line
test note second line
test note third line
EOF
test_todo_completion 'enotes add item' 'todo.sh enotes add ' '1 2 3'
test_todo_completion 'enotes add enote:roses to item 3' 'todo.sh enotes add 3 enote:r' 'enote:roses'
test_todo_completion 'enotes cat enote:roses' 'todo.sh enotes cat enote:g' 'enote:garden'
test_todo_completion 'enotes edit enote:garden' 'todo.sh enotes edit enote:g' 'enote:garden'
test_todo_completion 'enotes rename enote:g' 'todo.sh enotes rename enote:g' 'enote:garden'
test_todo_completion 'enotes unarchive enote:g' 'todo.sh enotes unarchive enote:g' 'enote:garden'

test_done
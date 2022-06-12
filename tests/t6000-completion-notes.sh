#!/bin/bash
#

# shellcheck disable=SC2034
test_description='Bash context completion functionality

This test checks todo_completion of notes
'
# shellcheck disable=SC1091
. ./test-lib.sh -i

# Set our current actions directory
export TODO_ACTIONS_DIR=$TEST_DIRECTORY/../actions/notes
# Set editor to cat so it tests nicely.
export EDITOR="cat"
export TODO_ACTIONS_COMP=$TEST_DIRECTORY/../bash_completion/actions
complete -r todo.sh
# shellcheck disable=SC1091
source "${TEST_DIRECTORY}/../bash_completion/todo.txt"
mkdir -p notes/archive
cat > todo.txt <<EOF
(B) smell the +roses @outside @outdoor +shared note:roses
notice the sunflowers +sunflowers @outside @garden +shared +landscape note:garden
stop
EOF
cat > ./notes/archive/todo-test_garden.10100000.txt << EOF                                                         
test note first line
test note second line
test note third line
EOF
cat > ./notes/archive/todo-test_roses.10100000.txt << EOF                                                         
are red
EOF
test_todo_completion 'notes' 'todo.sh notes ' 'add archive cat edit grep list listarchived rename unarchive'
test_todo_completion 'notes add item' 'todo.sh notes add ' '1 2 3'
test_todo_completion 'notes add note:roses to item 3' 'todo.sh notes add 3 note:r' 'note:roses'
test_todo_completion 'notes cat note:roses' 'todo.sh notes cat note:g' 'note:garden'
test_todo_completion 'notes edit note:garden' 'todo.sh notes edit note:g' 'note:garden'
test_todo_completion 'notes rename note:g' 'todo.sh notes rename note:g' 'note:garden'
test_todo_completion 'notes unarchive note:g' 'todo.sh notes unarchive note:g' 'note:garden'

test_done
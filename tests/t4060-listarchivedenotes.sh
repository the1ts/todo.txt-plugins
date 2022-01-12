#!/bin/bash

test_description='notes actions functionality
'
. ./test-lib.sh

# Set our current actions directory
export TODO_ACTIONS_DIR=$TEST_DIRECTORY/../actions/enotes
# Set editor to cat so it tests nicely.
export EDITOR="cat"

# Create our notes and archive directories
mkdir -p notes/archive
# Create our todo.txt file
cat > todo.txt <<EOF
Buy tools enote:test
Fix bicycle enote:testing
Ride bike enote:testing
EOF
# Create our notes file with some content
cat > notes/todo-test.enc << EOF
test note first line
test note second line
EOF
# Create our notes file with some content
cat > ./notes/archive/todo-testing.enc << EOF
test note first line
test note second line
EOF
cat > ./notes/archive/todo-previous.10100000.enc << EOF
test note first line
test note second line
test note third line
EOF

test_todo_session 'listarchivedenotes usage' <<EOF
>>> todo.sh listarchivedenotes usage
    listarchivedenotes [TERM]
      List archived encrypted notes
=== 0
EOF

test_todo_session 'lsaen usage' <<EOF
>>> todo.sh lsaen usage
    listarchivedenotes [TERM]
      List archived encrypted notes
=== 0
EOF

test_todo_session 'listarchivedenotes all' <<EOF
>>> todo.sh listarchivedenotes
enote:previous
enote:testing
=== 0
EOF

test_todo_session 'listarchivedenotes containing term' <<EOF
>>> todo.sh listarchivedenotes test
enote:testing
=== 0
EOF

test_todo_session 'listarchivedenotes unable to find term' <<EOF
>>> todo.sh listarchivedenotes foobar
      No notes with the term "foobar"
    listarchivedenotes [TERM]
      List archived encrypted notes
=== 1
EOF

test_done

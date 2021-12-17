#!/bin/bash

test_description='notes actions functionality
'
. ./test-lib.sh

# Set our current actions directory
export TODO_ACTIONS_DIR=$TEST_DIRECTORY/../actions/notes
# Set editor to cat so it tests nicely.
export EDITOR="cat"

# Create our notes and archive directories
mkdir -p notes/archive
# Create our todo.txt file
cat > todo.txt <<EOF
Buy tools note:test
Fix bicycle note:testing
Ride bike note:testing
EOF
# Create our notes file with some content
cat > notes/todo-test.txt << EOF                                                         
test note first line
test note second line
EOF
# Create our notes file with some content
cat > ./notes/todo-testing.txt << EOF                                                         
test note first line
test note second line
EOF
cat > ./notes/archive/todo-test-previous.10100000.txt << EOF                                                         
test note first line
test note second line
test note third line
EOF

test_todo_session 'listnotes usage' <<EOF
>>> todo.sh listnotes usage
    listnotes [TERM]
      List notes
=== 0
EOF

test_todo_session 'lsn usage' <<EOF
>>> todo.sh lsn usage
    listnotes [TERM]
      List notes
=== 0
EOF

test_todo_session 'listnotes all' <<EOF
>>> todo.sh listnotes
note:test
note:testing
=== 0
EOF

test_todo_session 'listnotes containing term' <<EOF
>>> todo.sh listnotes testing
note:testing
=== 0
EOF

test_todo_session 'listnotes unable to find term' <<EOF
>>> todo.sh listnotes foobar
      No notes with the term "foobar"
    listnotes [TERM]
      List notes
=== 1
EOF

test_done

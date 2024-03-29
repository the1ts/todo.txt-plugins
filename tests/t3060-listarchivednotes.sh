#!/bin/bash

test_description='notes actions functionality
'
. ./test-lib.sh -i

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

test_todo_session 'listarchivednotes usage' <<EOF
>>> todo.sh listarchivednotes usage
    notes listarchived [TERM...]
      List archived notes
=== 1
EOF

test_todo_session 'lsan usage' <<EOF
>>> todo.sh lsan usage
    notes listarchived [TERM...]
      List archived notes
=== 1
EOF

test_todo_session 'listarchivednotes all' <<EOF
>>> todo.sh listarchivednotes
note:test-previous
=== 0
EOF

test_todo_session 'listarchivednotes containing term' <<EOF
>>> todo.sh listarchivednotes test
note:test-previous
=== 0
EOF

test_todo_session 'listarchivednotes unable to find term' <<EOF
>>> todo.sh listarchivednotes foobar
      No notes with the term "foobar"
    notes listarchived [TERM...]
      List archived notes
=== 1
EOF


test_done

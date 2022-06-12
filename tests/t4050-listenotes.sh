#!/bin/bash

test_description='enotes actions functionality
'
. ./test-lib.sh -i

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
cat > ./notes/todo-testing.enc << EOF                                                         
test note first line
test note second line
EOF
cat > ./notes/archive/todo-test-previous.10100000.enc << EOF                                                         
test note first line
test note second line
test note third line
EOF

test_todo_session 'listenotes usage' <<EOF
>>> todo.sh enotes list usage
    enotes list [TERM...]
      List encrypted notes
=== 1
EOF

test_todo_session 'lsen usage' <<EOF
>>> todo.sh lsen usage
    enotes list [TERM...]
      List encrypted notes
=== 1
EOF

test_todo_session 'listenotes all' <<EOF
>>> todo.sh listenotes
enote:test
enote:testing
=== 0
EOF

test_todo_session 'listenotes containing term' <<EOF
>>> todo.sh listenotes testing
enote:testing
=== 0
EOF

test_todo_session 'listenotes unable to find term' <<EOF
>>> todo.sh listenotes foobar
      No encrypted notes with the term "foobar"
    enotes list [TERM...]
      List encrypted notes
=== 1
EOF

test_done

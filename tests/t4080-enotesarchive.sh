#!/bin/bash

test_description='enotes actions functionality
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
# Not encrypting as they aren't opened by this action
cat > notes/todo-test.enc << EOF                                                         
test note first line
test note second line
EOF
cat > ./notes/archive/todo-test-previous.10100000.enc << EOF
test note first line
test note second line
test note third line
EOF

test_todo_session 'enotesarchive usage' <<EOF
>>> todo.sh enotesarchive usage
    enotesarchive
      archive encrypted notes files nolonger in todo file.
=== 0
EOF

test_todo_session 'enar usage' <<EOF
>>> todo.sh enar usage
    enotesarchive
      archive encrypted notes files nolonger in todo file.
=== 0
EOF

# Create our note file not in todo.txt
cat > ./notes/todo-archive_file.enc << EOF                                                         
File to test archiving
EOF

test_todo_session 'enotesarchive run' <<EOF
>>> todo.sh enotesarchive 
TODO: Archived enote:archive_file
=== 0
EOF

test_todo_session 'enotesarchive run nothing to archive' <<EOF
>>> todo.sh enotesarchive
TODO: Nothing to archive
=== 1
EOF

test_done

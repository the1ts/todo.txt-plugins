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

test_todo_session 'notesarchive usage' <<EOF
>>> todo.sh notesarchive usage
    notes archive
      Archive NOTESFILE not in todo.txt
=== 1
EOF

test_todo_session 'nar usage' <<EOF
>>> todo.sh nar usage
    notes archive
      Archive NOTESFILE not in todo.txt
=== 1
EOF

# Create our note file not in todo.txt
cat > ./notes/todo-archive_file.txt << EOF                                                         
File to test archiving
EOF

test_todo_session 'notesarchive run' <<EOF
>>> todo.sh notesarchive 
TODO: Archived note:archive_file
=== 0
EOF

test_todo_session 'notesarchive run nothing to archive' <<EOF
>>> todo.sh notesarchive
TODO: Nothing to archive
=== 1
EOF

test_done

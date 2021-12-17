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
cat > ./notes/archive/todo-test_previous.10100000.txt << EOF                                                         
test note first line
test note second line
test note third line
EOF
cat > ./notes/archive/todo-testing.1010000.txt << EOF                                                         
test note first line
test note second line
older
EOF
cat > ./notes/archive/todo-testing.1020000.txt << EOF                                                         
test note first line
test note second line
younger
EOF

test_todo_session 'notesunarchive usage' <<EOF
>>> todo.sh notesunarchive usage
    notesunarchive [NOTESFILE]
      unarchive notes files, this brings back the last
      version of the notefile
=== 0
EOF

test_todo_session 'nuar usage' <<EOF
>>> todo.sh nuar usage
    notesunarchive [NOTESFILE]
      unarchive notes files, this brings back the last
      version of the notefile
=== 0
EOF

test_todo_session 'notesunarchive for note never archived' <<EOF
>>> todo.sh notesunarchive foobar
      No archived notes file named foobar. Use listarchivedenotes to find them
    notesunarchive [NOTESFILE]
      unarchive notes files, this brings back the last
      version of the notefile
=== 1
EOF

test_todo_session 'notesunarchive unarchive file' <<EOF
>>> todo.sh notesunarchive testing; cat notes/todo-testing.txt
TODO: Notes file todo-testing.txt restored from newest archive
test note first line
test note second line
younger
=== 0
EOF

test_todo_session 'notesunarchive notefile not in todo.txt' <<EOF
>>> todo.sh notesunarchive test_previous
      Note file test_previous not mentioned in todo
      use listnotes to find them
    notesunarchive [NOTESFILE]
      unarchive notes files, this brings back the last
      version of the notefile
=== 1
EOF

test_done

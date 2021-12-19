#!/bin/bash

test_description='notes actions functionality
'
. ./test-lib.sh

export TODO_ACTIONS_DIR=$TEST_DIRECTORY/../actions/notes

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

test_todo_session 'notescat usage' <<EOF
>>> todo.sh notescat usage
    notescat [NOTESFILE]
      Cat notes file, use listnotes to get list of notes
=== 0
EOF

test_todo_session 'nc usage' <<EOF
>>> todo.sh notescat usage
    notescat [NOTESFILE]
      Cat notes file, use listnotes to get list of notes
=== 0
EOF

test_todo_session 'notescat no notes file' <<EOF
>>> todo.sh notescat
      No notes file
    notescat [NOTESFILE]
      Cat notes file, use listnotes to get list of notes
=== 1
EOF

test_todo_session 'notescat show' <<EOF
>>> todo.sh notescat note:test
test note first line
test note second line
=== 0
EOF

test_todo_session 'notescat show no such note' <<EOF
>>> todo.sh notescat note:notafile
      Notes file notafile not in todo.txt file,
      use listnotes to find notes files
    notescat [NOTESFILE]
      Cat notes file, use listnotes to get list of notes
=== 1
EOF

test_done

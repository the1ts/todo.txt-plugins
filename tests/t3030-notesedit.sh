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

test_todo_session 'notesedit usage' <<EOF
>>> todo.sh notesedit usage
    notes edit [NOTESFILE]
      Edit notes file, in \$EDITOR.
      use listnotes to get list of notes files
=== 1
EOF

test_todo_session 'ne usage' <<EOF
>>> todo.sh ne usage
    notes edit [NOTESFILE]
      Edit notes file, in \$EDITOR.
      use listnotes to get list of notes files
=== 1
EOF

test_todo_session 'notesedit no notefile' <<EOF
>>> todo.sh notesedit
      No notes file
    notes edit [NOTESFILE]
      Edit notes file, in \$EDITOR.
      use listnotes to get list of notes files
=== 1
EOF

test_todo_session 'notesedit no such notefile' <<EOF
>>> todo.sh notesedit note:notafile
      No such notes file, use listnotes to find notes files
    notes edit [NOTESFILE]
      Edit notes file, in \$EDITOR.
      use listnotes to get list of notes files
=== 1
EOF

test_todo_session 'notesedit show a notefile' <<EOF
>>> todo.sh notesedit note:test
test note first line
test note second line
=== 0
EOF

test_done

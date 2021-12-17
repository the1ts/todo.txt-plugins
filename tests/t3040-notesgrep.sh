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

test_todo_session 'notesgrep usage' <<EOF
>>> todo.sh notesgrep usage
    notesgrep [-a] [TERM...]
      List notes that contain a TERM within them
      -a show archived notes
=== 0
EOF

test_todo_session 'ng usage' <<EOF
>>> todo.sh ng usage
    notesgrep [-a] [TERM...]
      List notes that contain a TERM within them
      -a show archived notes
=== 0
EOF

test_todo_session 'notesgrep no term' <<EOF
>>> todo.sh notesgrep
    No TERM
    notesgrep [-a] [TERM...]
      List notes that contain a TERM within them
      -a show archived notes
=== 1
EOF

test_todo_session 'notesgrep term not found' <<EOF
>>> todo.sh notesgrep foobar
No current Notes containing "foobar"
=== 1
EOF

test_todo_session 'notesgrep term not found in current or archive' <<EOF
>>> todo.sh notesgrep -a foobar
No current Notes containing "foobar"
No archived Notes containing "foobar"
=== 1
EOF

test_todo_session 'notesgrep term found' <<EOF
>>> todo.sh notesgrep second
Notes Files containing "second"
-----------
note:test
note:testing
=== 0
EOF

# Blank line becomes space for EOF usage
test_todo_session 'notesgrep term found also in archive' <<EOF
>>> todo.sh notesgrep -a second | sed '/^$/d'
Notes Files containing "second"
-----------
note:test
note:testing
Archived Notes Files containing "second"
--------------------
note:test-previous
=== 0
EOF

test_todo_session 'notesgrep term found only in archive' <<EOF
>>> todo.sh notesgrep -a third | sed '/^$/d'
No current Notes containing "third"
Archived Notes Files containing "third"
--------------------
note:test-previous
=== 0
EOF

test_done

#!/bin/bash

test_description='enotes actions functionality
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

test_todo_session 'notesrename usage' <<EOF
>>> todo.sh notesrename usage
    notes rename [ORIGINAL_NOTESFILE] [NEW_NOTESFILE]
      rename ORIGINAL_NOTESFILE to NEW_NOTESFILE
      the note: is not required, but added
=== 1
EOF

test_todo_session 'nr usage' <<EOF
>>> todo.sh nr usage
    notes rename [ORIGINAL_NOTESFILE] [NEW_NOTESFILE]
      rename ORIGINAL_NOTESFILE to NEW_NOTESFILE
      the note: is not required, but added
=== 1
EOF

test_todo_session 'notesrename not enough options' <<EOF
>>> todo.sh notesrename foobar
    check number of options
    notes rename [ORIGINAL_NOTESFILE] [NEW_NOTESFILE]
      rename ORIGINAL_NOTESFILE to NEW_NOTESFILE
      the note: is not required, but added
=== 1
EOF

test_todo_session 'notesrename too many options' <<EOF
>>> todo.sh notesrename foo bar wibble
    check number of options
    notes rename [ORIGINAL_NOTESFILE] [NEW_NOTESFILE]
      rename ORIGINAL_NOTESFILE to NEW_NOTESFILE
      the note: is not required, but added
=== 1
EOF

test_todo_session 'notesrename original note not in todo.txt' <<EOF
>>> todo.sh notesrename foo bar
    foo is not a current note, use listnotes to find notes.
    notes rename [ORIGINAL_NOTESFILE] [NEW_NOTESFILE]
      rename ORIGINAL_NOTESFILE to NEW_NOTESFILE
      the note: is not required, but added
=== 1
EOF

test_todo_session 'notesrename rename original note to new note todo.txt only' <<EOF
>>> todo.sh notesrename testing test1; cat todo.txt
TODO: Changed note:testing to note:test1 in todo.txt
Buy tools note:test
Fix bicycle note:test1
Ride bike note:test1
=== 0
EOF

cat > done.txt << EOF                                                         
2021-01-01 test line 1 note:test2
2021-01-01 test line 2 note:test4
EOF

cat > todo.txt << EOF                                                         
test new line note:test2
EOF

test_todo_session 'notesrename rename original note to new note todo.txt and done.txt' <<EOF
>>> todo.sh notesrename test2 test3; cat todo.txt done.txt
TODO: Changed note:test2 to note:test3 in todo.txt
TODO: Changed note:test2 to note:test3 in done.txt
test new line note:test3
2021-01-01 test line 1 note:test3
2021-01-01 test line 2 note:test4
=== 0
EOF

test_todo_session 'notesrename rename original note to new note done.txt only' <<EOF
>>> todo.sh notesrename test4 test5; cat done.txt
TODO: Changed note:test4 to note:test5 in done.txt
2021-01-01 test line 1 note:test3
2021-01-01 test line 2 note:test5
=== 0
EOF

test_done

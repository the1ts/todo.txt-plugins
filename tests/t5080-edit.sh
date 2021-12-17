#!/bin/bash

test_description='notes actions functionality
'
. ./test-lib.sh

export TODO_ACTIONS_DIR=$TEST_DIRECTORY/../actions/misc
# Set editor to cat so it tests nicely.
export EDITOR="cat"

# Create our todo.txt file
cat > todo.txt <<EOF
Buy tools note:test
Fix bicycle note:testing
Ride bike note:testing
EOF
# Create our notes file with some content
cat > done.txt <<EOF
2021-01-01 test line 1 note:test2
2021-01-01 test line 2 note:test4
EOF

test_todo_session 'edit usage' <<EOF
>>> todo.sh edit usage
    edit [todo|done|cfg] [line number]
      Allows editing of the todo.txt files.
      todo.txt (todo), done.txt (done) or config (cfg)
      files in your default editor or vi
=== 0
EOF

test_todo_session 'edit with no file' <<EOF
>>> todo.sh edit
Buy tools note:test
Fix bicycle note:testing
Ride bike note:testing
=== 0
EOF

test_todo_session 'edit todo file' <<EOF
>>> todo.sh edit todo
Buy tools note:test
Fix bicycle note:testing
Ride bike note:testing
=== 0
EOF

test_todo_session 'edit done file' <<EOF
>>> todo.sh edit done
2021-01-01 test line 1 note:test2
2021-01-01 test line 2 note:test4
=== 0
EOF

# Since cfg file is long, check for first 5 lines with blank lines stripped
test_todo_session 'edit config file' <<EOF
>>> todo.sh edit cfg | sed '/^$/d' | head -5
# === EDIT FILE LOCATIONS BELOW ===
# Your todo.txt directory (this should be an absolute path)
#export TODO_DIR="/net/nas1/volume1/scratcharea/paulbm/git/home/github/todo.txt-plugins/tests/trash directory.t5080-edit"
export TODO_DIR="/net/nas1/volume1/scratcharea/paulbm/git/home/github/todo.txt-plugins/tests/trash directory.t5080-edit"
# Your todo/done/report.txt locations
=== 0
EOF

test_todo_session 'edit with bad file to edit' <<EOF
>>> todo.sh edit notafile
      Not a valid file
    edit [todo|done|cfg] [line number]
      Allows editing of the todo.txt files.
      todo.txt (todo), done.txt (done) or config (cfg)
      files in your default editor or vi
=== 1
EOF

# TODO test for line number editing
test_done
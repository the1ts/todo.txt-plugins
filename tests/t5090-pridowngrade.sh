#!/bin/bash

test_description='notes actions functionality
'
. ./test-lib.sh

export TODO_ACTIONS_DIR=$TEST_DIRECTORY/../actions/misc
# Set editor to cat so it tests nicely.
export EDITOR="cat"

# Create our todo.txt file
cat > todo.txt <<EOF
(B) Buy tools note:test
Fix bicycle note:testing
(Z) Ride bike note:testing
(D) Train dog
(E) Be Good +test
(F) Do here @wibble
EOF

test_todo_session 'pridowngrade usage' <<EOF
>>> todo.sh pridowngrade usage
    pridowngrade [TERM]
      Decreases the priority of all items matching TERM
      Without TERM it runs across all priroties
      For changes by line number use builtin pri
=== 0
EOF

test_todo_session 'pridowngrade with simple TERM' <<EOF
>>> todo.sh pridowngrade Train
4 (E) Train dog
TODO: 4 re-prioritized from (D) to (E).
=== 0
EOF

test_todo_session 'pridowngrade with project TERM' <<EOF
>>> todo.sh pridowngrade +test
5 (F) Be Good +test
TODO: 5 re-prioritized from (E) to (F).
=== 0
EOF

test_todo_session 'pridowngrade with context TERM' <<EOF
>>> todo.sh pridowngrade @wibble
6 (G) Do here @wibble
TODO: 6 re-prioritized from (F) to (G).
=== 0
EOF

test_todo_session 'pridowngrade with no TERM' <<EOF
>>> todo.sh pridowngrade
1 (C) Buy tools note:test
TODO: 1 re-prioritized from (B) to (C).
4 (F) Train dog
TODO: 4 re-prioritized from (E) to (F).
5 (G) Be Good +test
TODO: 5 re-prioritized from (F) to (G).
6 (H) Do here @wibble
TODO: 6 re-prioritized from (G) to (H).
3 (Z) Ride bike note:testing
TODO: 3 already prioritized (Z).
=== 0
EOF

# Create our todo.txt file without priorities
cat > todo.txt <<EOF
Buy tools note:test
Fix bicycle note:testing
Ride bike note:testing
EOF

test_todo_session 'pridowngrade with no priorities in todo.txt' <<EOF
>>> todo.sh pridowngrade
      No priorites in our search of todo.txt
    pridowngrade [TERM]
      Decreases the priority of all items matching TERM
      Without TERM it runs across all priroties
      For changes by line number use builtin pri
=== 1
EOF

# Create our todo.txt file without priorities
cat > todo.txt <<EOF
Buy tools note:test
Fix bicycle note:testing
(A) Ride bike note:testing
EOF

test_todo_session 'pridowngrade with no priorities in our search of todo.txt' <<EOF
>>> todo.sh pridowngrade None
      No priorites in our search of todo.txt
    pridowngrade [TERM]
      Decreases the priority of all items matching TERM
      Without TERM it runs across all priroties
      For changes by line number use builtin pri
=== 1
EOF

# TODO test for line number editing
test_done

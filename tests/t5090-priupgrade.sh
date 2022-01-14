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

test_todo_session 'priupgrade usage' <<EOF
>>> todo.sh priupgrade usage
    priupgrade [TERM]
      Increases the priority of all items matching TERM
      Without TERM it runs across all priroties
      For changes by line number use builtin pri
=== 0
EOF

test_todo_session 'priupgrade with simple TERM' <<EOF
>>> todo.sh priupgrade Train
4 (C) Train dog
TODO: 4 re-prioritized from (D) to (C).
=== 0
EOF

test_todo_session 'priupgrade with project TERM' <<EOF
>>> todo.sh priupgrade +test
5 (D) Be Good +test
TODO: 5 re-prioritized from (E) to (D).
=== 0
EOF

test_todo_session 'priupgrade with context TERM' <<EOF
>>> todo.sh priupgrade @wibble
6 (E) Do here @wibble
TODO: 6 re-prioritized from (F) to (E).
=== 0
EOF

test_todo_session 'priupgrade with no TERM' <<EOF
>>> todo.sh priupgrade
1 (A) Buy tools note:test
TODO: 1 re-prioritized from (B) to (A).
4 (B) Train dog
TODO: 4 re-prioritized from (C) to (B).
5 (C) Be Good +test
TODO: 5 re-prioritized from (D) to (C).
6 (D) Do here @wibble
TODO: 6 re-prioritized from (E) to (D).
3 (X) Ride bike note:testing
TODO: 3 re-prioritized from (Z) to (X).
=== 0
EOF

# Create our todo.txt file without priorities
cat > todo.txt <<EOF
Buy tools note:test
Fix bicycle note:testing
Ride bike note:testing
EOF

test_todo_session 'priupgrade with no priorities in todo.txt' <<EOF
>>> todo.sh priupgrade
      No priorites in our search of todo.txt
    priupgrade [TERM]
      Increases the priority of all items matching TERM
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

test_todo_session 'priupgrade with no priorities in our search of todo.txt' <<EOF
>>> todo.sh priupgrade None
      No priorites in our search of todo.txt
    priupgrade [TERM]
      Increases the priority of all items matching TERM
      Without TERM it runs across all priroties
      For changes by line number use builtin pri
=== 1
EOF

# TODO test for line number editing
test_done

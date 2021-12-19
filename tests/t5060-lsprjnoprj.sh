#!/bin/bash

test_description='projectview action functionality
'
. ./test-lib.sh

export TODO_ACTIONS_DIR=$TEST_DIRECTORY/../actions/lists

cat > todo.txt <<EOF
(A) Buy tools +purchase
Fix bicycle +repair
Ride bike +fix
EOF

test_todo_session 'lsprjnopri show usage' <<EOF
>>> todo.sh lsprjnopri usage
    lsprjnopri
      List projects with no priorities set
=== 0
EOF

test_todo_session 'lsprjnopri show no priority' <<EOF
>>> todo.sh lsprjnopri 
No priority set in fix
===============================
3 Ride bike +fix
=====================================
No priority set in repair
===============================
2 Fix bicycle +repair
=====================================
=== 0
EOF

cat > todo.txt <<EOF
(A) Buy tools +purchase
(C) Fix bicycle +repair
(B) Ride bike +fix
EOF

test_todo_session 'lsprjnopri all projects have priority' <<EOF
>>> todo.sh lsprjnopri 
      All projects have priorities set
=== 0
EOF

cat > todo.txt <<EOF
Buy tools
Fix bicycle
Ride bike
EOF

test_todo_session 'lsprjnopri no projects in todo.txt' <<EOF
>>> todo.sh lsprjnopri 
      No projects in todo.txt
    lsprjnopri
      List projects with no priorities set
=== 1
EOF
test_done

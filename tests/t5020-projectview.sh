#!/bin/bash

test_description='projectview action functionality
'
. ./test-lib.sh

export TODO_ACTIONS_DIR=$TEST_DIRECTORY/../actions/projectview

cat > todo.txt <<EOF
Buy tools +purchase
Fix bicycle +repair
Ride bike
EOF

test_todo_session 'projectview show usage' <<EOF
>>> todo.sh projectview usage
    projectview [TERM...]
      Show todo items containing TERM, grouped by project, and displayed
      in priority order. If no TERM provided, displays entire todo.txt.
      If any TERMs are a project it uses the non-project terms
      to search within these projects
=== 0
EOF

test_todo_session 'pv show usage' <<EOF
>>> todo.sh pv usage
    projectview [TERM...]
      Show todo items containing TERM, grouped by project, and displayed
      in priority order. If no TERM provided, displays entire todo.txt.
      If any TERMs are a project it uses the non-project terms
      to search within these projects
=== 0
EOF

# Adding sed to remove blanklines which break EOF
test_todo_session 'projectview no term' <<EOF
>>> todo.sh projectview | sed '/^$/d'
=====  Projects  =====
---  purchase  ---
1 Buy tools +purchase
---  repair  ---
2 Fix bicycle +repair
--- Not in projects ---
3 Ride bike
=== 0
EOF

test_todo_session 'projectview with context as term' <<EOF
>>> todo.sh projectview +purchase | sed '/^$/d'
=====  Projects  =====
---  purchase  ---
1 Buy tools +purchase
=== 0
EOF

test_todo_session 'projectview with not a context term' <<EOF
>>> todo.sh projectview bike | sed '/^$/d'
=====  Projects  =====
--- Not in projects ---
3 Ride bike
=== 0
EOF

test_todo_session 'projectview with multiple terms' <<EOF
>>> todo.sh projectview tools +purchase | sed '/^$/d'
=====  Projects  =====
---  purchase  ---
1 Buy tools +purchase
=== 0
EOF

test_todo_session 'projectview with term not in todo.txt' <<EOF
>>> todo.sh projectview foobar
      "foobar" not found in todo.txt
    projectview [TERM...]
      Show todo items containing TERM, grouped by project, and displayed
      in priority order. If no TERM provided, displays entire todo.txt.
      If any TERMs are a project it uses the non-project terms
      to search within these projects
=== 1
EOF

test_todo_session 'projectview with project not in todo.txt' <<EOF
>>> todo.sh projectview +foobar
      project "foobar" not found in todo.txt
    projectview [TERM...]
      Show todo items containing TERM, grouped by project, and displayed
      in priority order. If no TERM provided, displays entire todo.txt.
      If any TERMs are a project it uses the non-project terms
      to search within these projects
=== 1
EOF

test_todo_session 'projectview with term not in project' <<EOF
>>> todo.sh projectview +purchase bike
      "bike" not found in project "purchase" in todo.txt
    projectview [TERM...]
      Show todo items containing TERM, grouped by project, and displayed
      in priority order. If no TERM provided, displays entire todo.txt.
      If any TERMs are a project it uses the non-project terms
      to search within these projects
=== 1
EOF

test_done

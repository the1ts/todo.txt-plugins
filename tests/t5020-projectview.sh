#!/bin/bash

test_description='projectview action functionality
'
. ./test-lib.sh

export TODO_ACTIONS_DIR=$TEST_DIRECTORY/../actions/projectview

cat >todo.txt <<EOF
Buy tools +purchase @pc
Fix bicycle +repair @garage
Ride bike @grass
EOF

test_todo_session 'projectview show usage' <<EOF
>>> todo.sh projectview usage
    projectview [TERM...]
      Show todo items containing TERM, grouped by project, and displayed
      in priority order. If no TERM provided, displays entire todo.txt
      in project sections.
      If any TERMs are not a project it will override all that are a project
      as they are more specific than projects
=== 0
EOF

test_todo_session 'pv show usage' <<EOF
>>> todo.sh pv usage
    projectview [TERM...]
      Show todo items containing TERM, grouped by project, and displayed
      in priority order. If no TERM provided, displays entire todo.txt
      in project sections.
      If any TERMs are not a project it will override all that are a project
      as they are more specific than projects
=== 0
EOF

# Adding sed to remove blanklines which break EOF
test_todo_session 'projectview no term' <<EOF
>>> todo.sh projectview | sed '/^$/d'
=====  Projects  =====
---  purchase  ---
1 Buy tools +purchase @pc
---  repair  ---
2 Fix bicycle +repair @garage
--- Not in projects ---
3 Ride bike @grass
=== 0
EOF

test_todo_session 'projectview with context as term' <<EOF
>>> todo.sh projectview @pc | sed '/^$/d'
=====  Projects  =====
---  purchase  ---
1 Buy tools +purchase @pc
=== 0
EOF

test_todo_session 'projectview with word as term' <<EOF
>>> todo.sh projectview bike | sed '/^$/d'
=====  Projects  =====
--- Not in projects ---
3 Ride bike @grass
=== 0
EOF

test_todo_session 'projectview with project as term' <<EOF
>>> todo.sh projectview +purchase | sed '/^$/d'
=====  Projects  =====
---  purchase  ---
1 Buy tools +purchase @pc
=== 0
EOF

test_todo_session 'projectview with word and project, word overrides project as its more specific' <<EOF
>>> todo.sh projectview +purchase bicycle | sed '/^$/d'
=====  Projects  =====
---  repair  ---
2 Fix bicycle +repair @garage
=== 0
EOF

test_todo_session 'projectview with muliple project (or not and)' <<EOF
>>> todo.sh projectview +purchase +repair | sed '/^$/d'
=====  Projects  =====
---  purchase  ---
1 Buy tools +purchase @pc
---  repair  ---
2 Fix bicycle +repair @garage
=== 0
EOF

test_todo_session 'projectview with muliple search terms (and, not or), in a single item, note case insensitive' <<EOF
>>> todo.sh projectview fix bicycle | sed '/^$/d'
=====  Projects  =====
---  repair  ---
2 Fix bicycle +repair @garage
=== 0
EOF

test_todo_session 'projectview with muliple search terms (and, not or), not in single item, but if terms are or not and would find two lines' <<EOF
>>> todo.sh projectview tools buy | sed '/^$/d'
      "tools buy" not found in todo.txt
    projectview [TERM...]
      Show todo items containing TERM, grouped by project, and displayed
      in priority order. If no TERM provided, displays entire todo.txt
      in project sections.
      If any TERMs are not a project it will override all that are a project
      as they are more specific than projects
=== 0
EOF

test_todo_session 'projectview with term not in todo.txt' <<EOF
>>> todo.sh projectview foobar
      "foobar" not found in todo.txt
    projectview [TERM...]
      Show todo items containing TERM, grouped by project, and displayed
      in priority order. If no TERM provided, displays entire todo.txt
      in project sections.
      If any TERMs are not a project it will override all that are a project
      as they are more specific than projects
=== 1
EOF

test_todo_session 'projectview with project not in todo.txt' <<EOF
>>> todo.sh projectview +foobar
      project "foobar" not found in todo.txt
    projectview [TERM...]
      Show todo items containing TERM, grouped by project, and displayed
      in priority order. If no TERM provided, displays entire todo.txt
      in project sections.
      If any TERMs are not a project it will override all that are a project
      as they are more specific than projects
=== 1
EOF

test_done

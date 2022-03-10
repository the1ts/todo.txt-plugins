#!/bin/bash

test_description='contextview action functionality
'
. ./test-lib.sh

export TODO_ACTIONS_DIR=$TEST_DIRECTORY/../actions/contextview

cat > todo.txt <<EOF
Buy tools @purchase
Fix bicycle @repair
Ride bike
EOF

test_todo_session 'contextview show usage' <<EOF
>>> todo.sh contextview usage
    contextview [TERM...]
      Show todo items containing TERM, grouped by context, and displayed in
      priority order. If no TERM provided, displays entire todo.txt.
      If any TERMS are a context it uses the non-context terms
      to search within those contexts.
=== 0
EOF

test_todo_session 'cv show usage' <<EOF
>>> todo.sh cv usage
    contextview [TERM...]
      Show todo items containing TERM, grouped by context, and displayed in
      priority order. If no TERM provided, displays entire todo.txt.
      If any TERMS are a context it uses the non-context terms
      to search within those contexts.
=== 0
EOF

# Adding sed to remove blanklines which break EOF
test_todo_session 'contextview no term' <<EOF
>>> todo.sh contextview | sed '/^$/d'
===== Contexts =====
--- purchase ---
1 Buy tools @purchase
--- repair ---
2 Fix bicycle @repair
--- No context ---
3 Ride bike
=== 0
EOF

test_todo_session 'contextview with context as term' <<EOF
>>> todo.sh contextview @purchase | sed '/^$/d'
===== Contexts =====
--- purchase ---
1 Buy tools @purchase
=== 0
EOF

test_todo_session 'contextview with not a context as term' <<EOF
>>> todo.sh contextview bike | sed '/^$/d'
===== Contexts =====
--- No context ---
3 Ride bike
=== 0
EOF

test_todo_session 'contextview with multiple terms' <<EOF
>>> todo.sh contextview tools @purchase | sed '/^$/d'
===== Contexts =====
--- purchase ---
1 Buy tools @purchase
=== 0
EOF

test_todo_session 'contextview with term not in todo.txt' <<EOF
>>> todo.sh contextview foobar
      "foobar" not found in todo.txt
    contextview [TERM...]
      Show todo items containing TERM, grouped by context, and displayed in
      priority order. If no TERM provided, displays entire todo.txt.
      If any TERMS are a context it uses the non-context terms
      to search within those contexts.
=== 1
EOF

test_todo_session 'contextview with context not in todo.txt' <<EOF
>>> todo.sh contextview @foobar
      context "foobar" not found in todo.txt
    contextview [TERM...]
      Show todo items containing TERM, grouped by context, and displayed in
      priority order. If no TERM provided, displays entire todo.txt.
      If any TERMS are a context it uses the non-context terms
      to search within those contexts.
=== 1
EOF

test_todo_session 'contextview with term not in context' <<EOF
>>> todo.sh contextview @purchase bike
      "bike" not found in context "@purchase" in todo.txt
    contextview [TERM...]
      Show todo items containing TERM, grouped by context, and displayed in
      priority order. If no TERM provided, displays entire todo.txt.
      If any TERMS are a context it uses the non-context terms
      to search within those contexts.
=== 1
EOF

test_done

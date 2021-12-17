#!/bin/bash

test_description='rename actions functionality
'
. ./test-lib.sh

# Set our current actions directory
export TODO_ACTIONS_DIR=$TEST_DIRECTORY/../actions/rename

# Create our todo.txt file
cat > todo.txt <<EOF
Buy tools @foo
Fix bicycle @foo
Ride bike @wibble
EOF

test_todo_session 'contextrename usage' <<EOF
>>> todo.sh contextrename usage
    contextrename [OLD CONTEXT] [NEW CONTEXT] [ITEM#]
      Rename old context to new context in ITEM#
      If no ITEM# given the rename all instances of old context
=== 0
EOF

test_todo_session 'cor usage' <<EOF
>>> todo.sh cor usage
    contextrename [OLD CONTEXT] [NEW CONTEXT] [ITEM#]
      Rename old context to new context in ITEM#
      If no ITEM# given the rename all instances of old context
=== 0
EOF

test_todo_session 'contextrename not enough options' <<EOF
>>> todo.sh contextrename foobar
      Not enough options
    contextrename [OLD CONTEXT] [NEW CONTEXT] [ITEM#]
      Rename old context to new context in ITEM#
      If no ITEM# given the rename all instances of old context
=== 1
EOF

test_todo_session 'contextrename item not a number' <<EOF
>>> todo.sh contextrename foo bar wibble
      ITEM# should be a LINE number
    contextrename [OLD CONTEXT] [NEW CONTEXT] [ITEM#]
      Rename old context to new context in ITEM#
      If no ITEM# given the rename all instances of old context
=== 1
EOF

test_todo_session 'contextrename original context not in todo.txt' <<EOF
>>> todo.sh contextrename badcontext bar
      Cannot find context badcontext
    contextrename [OLD CONTEXT] [NEW CONTEXT] [ITEM#]
      Rename old context to new context in ITEM#
      If no ITEM# given the rename all instances of old context
=== 1
EOF

test_todo_session 'contextrename original context found but not at line number' <<EOF
>>> todo.sh contextrename foo bar 3
      Cannot find context foo in line number 3
    contextrename [OLD CONTEXT] [NEW CONTEXT] [ITEM#]
      Rename old context to new context in ITEM#
      If no ITEM# given the rename all instances of old context
=== 1
EOF

test_todo_session 'contextrename multiple items one bad' <<EOF
>>> todo.sh contextrename test foo 1 test
      ITEM# should be a LINE number
    contextrename [OLD CONTEXT] [NEW CONTEXT] [ITEM#]
      Rename old context to new context in ITEM#
      If no ITEM# given the rename all instances of old context
=== 1
EOF

test_todo_session 'contextrename old context to new context everywhere' <<EOF
>>> todo.sh contextrename foo bar
1: Buy tools @bar
TODO: 1 updated context foo to bar.
2: Fix bicycle @bar
TODO: 2 updated context foo to bar.
=== 0
EOF

test_todo_session 'contextrename old context to new context for item' <<EOF
>>> todo.sh contextrename bar foo 2
2: Fix bicycle @foo
TODO: 2 updated context bar to foo.
=== 0
EOF

# Create our todo.txt file
cat >> todo.txt <<EOF
Rent tools @foo
EOF

test_todo_session 'contextrename old context to new context for multiple items' <<EOF
>>> todo.sh contextrename foo test 2 4
2: Fix bicycle @test
TODO: 2 updated context foo to test.
4: Rent tools @test
TODO: 4 updated context foo to test.
=== 0
EOF


test_done

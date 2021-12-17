#!/bin/bash

test_description='rename actions functionality
'
. ./test-lib.sh

# Set our current actions directory
export TODO_ACTIONS_DIR=$TEST_DIRECTORY/../actions/rename

# Create our todo.txt file
cat > todo.txt <<EOF
Buy tools +foo
Fix bicycle +foo
Ride bike +wibble
EOF

test_todo_session 'projectrename usage' <<EOF
>>> todo.sh projectrename usage
    projectrename [OLD PROJECT] [NEW PROJECT] [ITEM#]
      Rename old project to new project in ITEM#
      If no ITEM# given the rename all instances of old project
=== 0
EOF

test_todo_session 'prr usage' <<EOF
>>> todo.sh prr usage
    projectrename [OLD PROJECT] [NEW PROJECT] [ITEM#]
      Rename old project to new project in ITEM#
      If no ITEM# given the rename all instances of old project
=== 0
EOF

test_todo_session 'projectrename not enough options' <<EOF
>>> todo.sh projectrename foobar
      Not enough options
    projectrename [OLD PROJECT] [NEW PROJECT] [ITEM#]
      Rename old project to new project in ITEM#
      If no ITEM# given the rename all instances of old project
=== 1
EOF

test_todo_session 'projectrename item not a number' <<EOF
>>> todo.sh projectrename foo bar wibble
      ITEM# should be a LINE number
    projectrename [OLD PROJECT] [NEW PROJECT] [ITEM#]
      Rename old project to new project in ITEM#
      If no ITEM# given the rename all instances of old project
=== 1
EOF

test_todo_session 'projectrename original project not in todo.txt' <<EOF
>>> todo.sh projectrename badproject bar
      Cannot find project badproject
    projectrename [OLD PROJECT] [NEW PROJECT] [ITEM#]
      Rename old project to new project in ITEM#
      If no ITEM# given the rename all instances of old project
=== 1
EOF

test_todo_session 'projectrename original project found but not at line number' <<EOF
>>> todo.sh projectrename foo bar 3
      Cannot find project foo in line number 3
    projectrename [OLD PROJECT] [NEW PROJECT] [ITEM#]
      Rename old project to new project in ITEM#
      If no ITEM# given the rename all instances of old project
=== 1
EOF

test_todo_session 'projectrename multiple items one bad' <<EOF
>>> todo.sh projectrename test foo 1 test
      ITEM# should be a LINE number
    projectrename [OLD PROJECT] [NEW PROJECT] [ITEM#]
      Rename old project to new project in ITEM#
      If no ITEM# given the rename all instances of old project
=== 1
EOF

test_todo_session 'projectrename old project to new project everywhere' <<EOF
>>> todo.sh projectrename foo bar
1: Buy tools +bar
TODO: 1 updated project foo to bar.
2: Fix bicycle +bar
TODO: 2 updated project foo to bar.
=== 0
EOF

test_todo_session 'projectrename old project to new project for item' <<EOF
>>> todo.sh projectrename bar foo 2
2: Fix bicycle +foo
TODO: 2 updated project bar to foo.
=== 0
EOF

# Create our todo.txt file
cat >> todo.txt <<EOF
Rent tools +foo
EOF

test_todo_session 'projectrename old project to new project for multiple items' <<EOF
>>> todo.sh projectrename foo test 2 4
2: Fix bicycle +test
TODO: 2 updated project foo to test.
4: Rent tools +test
TODO: 4 updated project foo to test.
=== 0
EOF

test_done

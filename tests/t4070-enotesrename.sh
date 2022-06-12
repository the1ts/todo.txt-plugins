#!/bin/bash

test_description='enotes actions functionality
'
. ./test-lib.sh -i

# Set our current actions directory
export TODO_ACTIONS_DIR=$TEST_DIRECTORY/../actions/enotes
# Set editor to cat so it tests nicely.
export EDITOR="cat"

# Create our notes and archive directories
mkdir -p notes/archive
# Create our todo.txt file
cat > todo.txt <<EOF
Buy tools enote:test
Fix bicycle enote:testing
Ride bike enote:testing
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

test_todo_session 'enotesrename usage' <<EOF
>>> todo.sh enotesrename usage
    enotes rename [ORIGINAL_ENOTESFILE] [NEW_ENOTESFILE]
      rename ORIGINAL_ENOTESFILE to NEW_ENOTESFILE
      renames in todo.txt and enotefile
      the enote: is not required, but added
=== 1
EOF

test_todo_session 'enr usage' <<EOF
>>> todo.sh enr usage
    enotes rename [ORIGINAL_ENOTESFILE] [NEW_ENOTESFILE]
      rename ORIGINAL_ENOTESFILE to NEW_ENOTESFILE
      renames in todo.txt and enotefile
      the enote: is not required, but added
=== 1
EOF

test_todo_session 'enotesrename not enough options' <<EOF
>>> todo.sh enotesrename foobar
    check number of options
    enotes rename [ORIGINAL_ENOTESFILE] [NEW_ENOTESFILE]
      rename ORIGINAL_ENOTESFILE to NEW_ENOTESFILE
      renames in todo.txt and enotefile
      the enote: is not required, but added
=== 1
EOF

test_todo_session 'enotesrename too many options' <<EOF
>>> todo.sh enotesrename foo bar wibble
    check number of options
    enotes rename [ORIGINAL_ENOTESFILE] [NEW_ENOTESFILE]
      rename ORIGINAL_ENOTESFILE to NEW_ENOTESFILE
      renames in todo.txt and enotefile
      the enote: is not required, but added
=== 1
EOF

test_todo_session 'enotesrename original enote not in todo.txt' <<EOF
>>> todo.sh enotesrename foo bar
    foo is not a current enote, use listenotes to find enotes.
    enotes rename [ORIGINAL_ENOTESFILE] [NEW_ENOTESFILE]
      rename ORIGINAL_ENOTESFILE to NEW_ENOTESFILE
      renames in todo.txt and enotefile
      the enote: is not required, but added
=== 1
EOF

test_todo_session 'enotesrename rename original enote to new enote todo.txt only' <<EOF
>>> todo.sh enotesrename testing test1; cat todo.txt
TODO: Changed enote:testing to enote:test1 in todo.txt
Buy tools enote:test
Fix bicycle enote:test1
Ride bike enote:test1
=== 0
EOF

cat > done.txt << EOF                                                         
2021-01-01 test line 1 enote:test2
2021-01-01 test line 2 enote:test4
EOF

cat > todo.txt << EOF                                                         
test new line enote:test2
EOF

test_todo_session 'enotesrename rename original enote to new enote todo.txt and done.txt' <<EOF
>>> todo.sh enotesrename test2 test3; cat todo.txt done.txt
TODO: Changed enote:test2 to enote:test3 in todo.txt
TODO: Changed enote:test2 to enote:test3 in done.txt
test new line enote:test3
2021-01-01 test line 1 eenote:test3
2021-01-01 test line 2 enote:test4
=== 0
EOF

test_todo_session 'enotesrename rename original enote to new enote done.txt only' <<EOF
>>> todo.sh enotesrename test4 test5; cat done.txt
TODO: Changed enote:test4 to enote:test5 in done.txt
2021-01-01 test line 1 eenote:test3
2021-01-01 test line 2 eenote:test5
=== 0
EOF

test_done

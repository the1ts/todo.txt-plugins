#!/bin/bash

test_description='notes actions functionality
'
. ./test-lib.sh

export TODO_ACTIONS_DIR=$TEST_DIRECTORY/../actions/tickle
export TICKLER_DIR="./tickler"

# Make directories
mkdir -p "${TICKLER_DIR}/days/{01..31}/"
mkdir -p "${TICKLER_DIR}/months/{01..12}/"

# Create our notes file with some content
cat > todo.txt << EOF                                                         
tickle for day 5
tickle for month 3
EOF

test_todo_session 'tickle usage' <<EOF
>>> todo.sh tickle usage
    tickle ITEM [dmNUMBER]
      Move a line from todo.txt to day or month file in \${TODO_DIR}/tickler/.
      If [dm]<number> is omitted you will be prompted to enter a day or
      month and then number.
=== 0
EOF

test_todo_session 'tickle item not in todo.txt' <<EOF
>>> todo.sh tickle 16 d5
    Item number 16 does not exist in todo file.
    tickle ITEM [dmNUMBER]
      Move a line from todo.txt to day or month file in \${TODO_DIR}/tickler/.
      If [dm]<number> is omitted you will be prompted to enter a day or
      month and then number.
=== 1
EOF

test_todo_session 'tickle day not valid' <<EOF
>>> todo.sh tickle 1 d32
    Day number not a valid day of month
    tickle ITEM [dmNUMBER]
      Move a line from todo.txt to day or month file in \${TODO_DIR}/tickler/.
      If [dm]<number> is omitted you will be prompted to enter a day or
      month and then number.
=== 1
EOF

test_todo_session 'tickle month not valid' <<EOF
>>> todo.sh tickle 1 m13
    Month number not a valid month of year
    tickle ITEM [dmNUMBER]
      Move a line from todo.txt to day or month file in \${TODO_DIR}/tickler/.
      If [dm]<number> is omitted you will be prompted to enter a day or
      month and then number.
=== 1
EOF

test_todo_session 'tickle item 2 to day 5' <<EOF
>>> todo.sh tickle 2 d5
TODO: Moved todo item 2 to /days/05/05.txt
=== 0
EOF

test_todo_session 'tickle item 1 to month 3' <<EOF
>>> todo.sh tickle 1 m3
TODO: Moved todo item 1 to /months/03/03.txt
=== 0
EOF

test_todo_session 'tickled usage' <<EOF
>>> todo.sh tickled usage
    tickled
      list all tickled items
=== 0
EOF

# date is captured and returns Feb 13th 2009 04:40 UTC
test_todo_session 'tickled run' <<EOF
>>> todo.sh tickled
2009-02-05 tickle for month 3
2009-03-01 tickle for day 5
=== 0
EOF

# cleanup tickler directory for last run
rm -rf "${TICKLER_DIR}"

test_todo_session 'tickled run' <<EOF
>>> todo.sh tickled
      No tickled files
    tickled
      list all tickled items
=== 1
EOF

test_done

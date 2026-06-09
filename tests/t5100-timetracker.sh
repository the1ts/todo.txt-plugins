#!/bin/bash

# shellcheck disable=SC2034
test_description='timetracker actions functionality
'
# shellcheck disable=SC1091
. ./test-lib.sh -i

export TODO_ACTIONS_DIR=$TEST_DIRECTORY/../actions/timetracker

export USAGE="    timetracker on|off|list|archive|unarchive|stats|archivedstats|statsall [PROJECT]
      Track time spent on a project."

cat >todo.txt <<EOF
Buy tools +testing
Fix bicycle +foobar
Ride bike
EOF

mkdir -p tt/todo/archive/
cat >tt/todo/standard.tt <<EOF
1329951682
EOF
cat >tt/todo/archive/foobar.tt <<EOF
1329951682
EOF

test_todo_session 'timetracker simpleliststarted' <<EOF
>>> todo.sh timetracker simpleliststarted
+standard
=== 0
EOF

test_todo_session 'timetracker simplelistarchivedstarted' <<EOF
>>> todo.sh timetracker simplelistarchivedstarted
+foobar
=== 0
EOF

test_todo_session 'timetracker simplelistallstarted' <<EOF
>>> todo.sh timetracker simplelistallstarted
+foobar
+standard
=== 0
EOF

test_done

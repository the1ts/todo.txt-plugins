#!/bin/bash
#

# shellcheck disable=SC2034
test_description='Bash context completion functionality

This test checks todo_completion of enotes
'
# shellcheck disable=SC1091
. ./test-lib.sh -i 

# Set our current actions directory
export TODO_ACTIONS_DIR=$TEST_DIRECTORY/../actions/timetracker
# Set editor to cat so it tests nicely.
export EDITOR="cat"
export TODO_ACTIONS_COMP=$TEST_DIRECTORY/../bash_completion/actions
# Remove existing bash completion for todo.sh and add in our one.
complete -r todo.sh
# shellcheck disable=SC1091
source "${TEST_DIRECTORY}/../bash_completion/todo.txt"

mkdir -p tt/todo/archive
cat > todo.txt <<EOF
(B) smell the +roses @outside @outdoor +shared enote:roses
notice the sunflowers +sunflowers @outside @garden +shared +landscape enote:garden
stop
EOF
cat > tt/todo/foobar.tt <<EOF
1329951682
EOF
cat > tt/todo/finish.tt <<EOF
1329951682:1330051682
EOF
cat > tt/todo/archive/standard.tt <<EOF
1329951682
EOF

test_todo_completion 'timetracker show options' 'todo.sh timetracker ' 'archive archivedstats list off on stats statsall unarchive'
test_todo_completion 'tt show options' 'todo.sh tt ' 'archive archivedstats list off on stats statsall unarchive'
test_todo_completion 'timetracker on show projects' 'todo.sh timetracker on ' '+finish +landscape +roses +shared +sunflowers'
test_todo_completion 'tton show projects' 'todo.sh tton ' '+finish +landscape +roses +shared +sunflowers'
test_todo_completion 'tt on show projects' 'todo.sh tt on ' '+finish +landscape +roses +shared +sunflowers'
test_todo_completion 'timetracker off show started projects only non-archived' 'todo.sh timetracker off ' '+foobar +standard'
test_todo_completion 'ttoff show started projects only non-archived' 'todo.sh ttoff ' '+foobar +standard'
test_todo_completion 'tt off show started projects only non-archived' 'todo.sh tt off ' '+foobar +standard'
cat > tt/todo/archive/was.tt <<EOF
1329951682
EOF
test_todo_completion 'timetracker off show started projects archived and non-archived' 'todo.sh timetracker off ' '+foobar +standard +was'
test_todo_completion 'tt off show started projects archived and non-archived' 'todo.sh tt off ' '+foobar +standard +was'
test_todo_completion 'ttoff show started projects archived and non-archived' 'todo.sh ttoff ' '+foobar +standard +was'
test_todo_completion 'timetracker archive show projects completed and started' 'todo.sh timetracker archive ' '+foobar +standard +was'
test_todo_completion 'ttarchive show projects completed and started' 'todo.sh ttarchive ' '+foobar +standard +was'
test_todo_completion 'tt archive show projects completed and started' 'todo.sh tt archive ' '+foobar +standard +was'
cat > tt/todo/start.tt <<EOF
1329951682:1359951682
EOF
test_todo_completion 'timetracker unarchive show projects archived' 'todo.sh timetracker unarchive ' '+finish +start'
test_todo_completion 'ttunarchive show projects archived' 'todo.sh ttunarchive ' '+finish +start'
test_todo_completion 'tt unarchive show projects archived' 'todo.sh tt unarchive ' '+finish +start'
test_todo_completion 'timetracker stats show current projects' 'todo.sh timetracker stats ' '+finish +foobar +start'
test_todo_completion 'ttstats show current projects' 'todo.sh ttstats ' '+finish +foobar +start'
test_todo_completion 'tt stats show current projects' 'todo.sh tt stats ' '+finish +foobar +start'
test_todo_completion 'timetracker stats show archived projects' 'todo.sh timetracker archivedstats ' '+standard +was'

test_done
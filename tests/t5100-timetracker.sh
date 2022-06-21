#!/bin/bash

# shellcheck disable=SC2034
test_description='notes actions functionality
'
# shellcheck disable=SC1091
. ./test-lib.sh -i

export TODO_ACTIONS_DIR=$TEST_DIRECTORY/../actions/timetracker

export USAGE="    timetracker on|off|list|archive|unarchive|stats|archivedstats|statsall [project]
      Track time spent on a project."

cat > todo.txt <<EOF
Buy tools +testing
Fix bicycle +foobar
Ride bike
EOF

mkdir -p tt/todo/archive/
cat > tt/todo/archive/foobar.tt <<EOF
1329951682:1339955682
EOF

#
## on
#

test_todo_session 'timetracker show usage' <<EOF
>>> todo.sh timetracker usage
$USAGE
=== 1
EOF

test_todo_session 'tt show usage' <<EOF
>>> todo.sh tt usage
$USAGE
=== 1
EOF

test_todo_session 'tton show usage' <<EOF
>>> todo.sh tton usage
$USAGE
=== 1
EOF

test_todo_session 'timetracker no project' <<EOF
>>> todo.sh timetracker on
$USAGE
      No project given
=== 1
EOF

test_todo_session 'timetracker on for project not in todo.txt' <<EOF
>>> todo.sh timetracker on wibble
$USAGE
      Project wibble is not in todo.txt
=== 1
EOF

test_todo_session 'timetracker on for project in todo.txt file' <<EOF
>>> todo.sh timetracker on testing
Starting clock on testing
=== 0
EOF

rm -rf tt/todo/testing.tt
test_todo_session 'timetracker on for +project in todo.txt file' <<EOF
>>> todo.sh timetracker on +testing
Starting clock on testing
=== 0
EOF

test_todo_session 'timetracker on for project testing already started' <<EOF
>>> todo.sh timetracker on testing
$USAGE
      Project testing is still active, cannot turn on the clock
=== 1
EOF

test_todo_session 'timetracker on for project archived project answer yes' <<EOF
>>> yes | todo.sh timetracker on foobar
Project foobar is archived, unarchive?
Unarchiving and starting clock on foobar
=== 0
EOF

# Revert back to archived foobar
rm -rf tt/todo//foobar.tt
cat > tt/todo/archive/foobar.tt <<EOF
1329951682:1339955682
EOF

test_todo_session 'timetracker on for project archived project answer no' <<EOF
>>> yes n | todo.sh timetracker on foobar
Project foobar is archived, unarchive?
Not unarchiving
=== 1
EOF

#
## off
#

test_todo_session 'ttoff show usage' <<EOF
>>> todo.sh ttoff usage
$USAGE
=== 1
EOF

cat > tt/todo/testing.tt <<EOF
1329951682
EOF

test_todo_session 'timetracker off running project' <<EOF
>>> todo.sh timetracker off testing
Stopping clock on testing
=== 0
EOF

cat > tt/todo/testing.tt <<EOF
1329951682
EOF

test_todo_session 'timetracker off running +project' <<EOF
>>> todo.sh timetracker off +testing
Stopping clock on testing
=== 0
EOF

cat > tt/todo/archive/foobararchive.tt <<EOF
1329951682
EOF

test_todo_session 'timetracker off running archived project' <<EOF
>>> todo.sh timetracker off foobararchive
Stopping clock on foobararchive which is archived
=== 0
EOF

test_todo_session 'timetracker off no such project tt file' <<EOF
>>> todo.sh timetracker off nosuch
$USAGE
      Project nosuch does not exist in todo.txt
=== 1
EOF

cat >> todo.txt <<EOF
Testing stuffs +nosuch
EOF

test_todo_session 'timetracker off project - no such project in todo.txt or tt files' <<EOF
>>> todo.sh timetracker off nosuch
$USAGE
      No sign of tt file for project nosuch
=== 1
EOF

#
## list
#

test_todo_session 'timetracker list Current and Archived' <<EOF
>>> todo.sh timetracker list | sed '/^$/d'
Projects being time tracked
===========================
Current
-------
testing
Archived
--------
foobar
foobararchive
=== 0
EOF

rm -rf "tt/todo/archive/foobararchive.tt"

test_todo_session 'timetracker list Current and Archived' <<EOF
>>> todo.sh timetracker list | sed '/^$/d'
Projects being time tracked
===========================
Current
-------
testing
Archived
--------
foobar
=== 0
EOF

rm -rf "tt/todo/archive/foobar.tt"

test_todo_session 'timetracker list Current no Archived' <<EOF
>>> todo.sh timetracker list | sed '/^$/d'
Projects being time tracked
===========================
Current
-------
testing
=== 0
EOF

rm -rf "tt/todo/archive/foobar.tt" "tt/todo/testing.tt" "tt/todo/Archived.tt"

test_todo_session 'timetracker list no project files' <<EOF
>>> todo.sh timetracker list | sed '/^$/d'
$USAGE
      No files to list
=== 0
EOF

#
## archive
#

test_todo_session 'timetracker archive no project files' <<EOF
>>> todo.sh timetracker archive
$USAGE
      No project given
=== 1
EOF

cat > tt/todo/testing.tt <<EOF
1329951682:15000000
EOF

test_todo_session 'timetracker archive finished project' <<EOF
>>> todo.sh timetracker archive testing
Archived testing
=== 0
EOF

cat > tt/todo/testing.tt <<EOF
1329951682:15000000
EOF

test_todo_session 'timetracker archive finished +project' <<EOF
>>> todo.sh timetracker archive testing
Archived testing
=== 0
EOF

cat > tt/todo/testing.tt <<EOF
1329951682
EOF

test_todo_session 'timetracker archive started project' <<EOF
>>> todo.sh timetracker archive testing
Setting project testing as finished now and archiving
=== 0
EOF

cat > tt/todo/testing.tt <<EOF
1329951682
EOF

test_todo_session 'timetracker archive started +project' <<EOF
>>> todo.sh timetracker archive +testing
Setting project testing as finished now and archiving
=== 0
EOF

test_todo_session 'timetracker archive no project' <<EOF
>>> todo.sh timetracker archive testing
$USAGE
      Project testing does not exist
=== 1
EOF

#
## unarchive
#

# Create a started archived project
rm -rf tt/todo/*.tt tt/todo/archive/*.tt
cat > tt/todo/archive/testing.tt <<EOF
1329951682
EOF

test_todo_session 'timetracker unarchive started project' <<EOF
>>> todo.sh timetracker unarchive testing
Project testing unarchived
=== 0
EOF

# Create a started archived project
rm -rf tt/todo/*.tt tt/todo/archive/*.tt
cat > tt/todo/archive/testing.tt <<EOF
1329951682
EOF

test_todo_session 'timetracker unarchive started +project' <<EOF
>>> todo.sh timetracker unarchive +testing
Project testing unarchived
=== 0
EOF

# Create a completedarchived project
rm -rf tt/todo/*.tt tt/todo/archive/*.tt
cat > tt/todo/archive/testing.tt <<EOF
1329951682:125321532
EOF

test_todo_session 'timetracker unarchive completed project' <<EOF
>>> todo.sh timetracker unarchive testing
Project testing unarchived
=== 0
EOF

# Create a completedarchived project
rm -rf tt/todo/*.tt tt/todo/archive/*.tt
cat > tt/todo/archive/testing.tt <<EOF
1329951682:125321532
EOF

test_todo_session 'timetracker unarchive completed +project' <<EOF
>>> todo.sh timetracker unarchive +testing
Project testing unarchived
=== 0
EOF

rm -rf tt/todo/*.tt tt/todo/archive/*.tt

test_todo_session 'timetracker unarchive none timetracker project' <<EOF
>>> todo.sh timetracker unarchive testing
$USAGE
      Project testing not archived
=== 1
EOF

#
## stats
#

test_todo_session 'timetracker stats no project' <<EOF
>>> todo.sh timetracker stats
$USAGE
      No timetracker projects exist
=== 1
EOF

cat > tt/todo/testing.tt <<EOF
1329951682:1329971682
EOF

test_todo_session 'timetracker stats current project' <<EOF
>>> todo.sh timetracker stats testing
Stats for Project: testing
==========================
5 hours 33 minutes 20 seconds 
=== 0
EOF

test_todo_session 'timetracker stats current +project' <<EOF
>>> todo.sh timetracker stats +testing
Stats for Project: testing
==========================
5 hours 33 minutes 20 seconds 
=== 0
EOF

rm -rf tt/todo/testing.tt

test_todo_session 'timetracker stats no current project' <<EOF
>>> todo.sh timetracker stats testing
$USAGE
      No current timetracker projects
=== 1
EOF

cat > tt/todo/archive/testing.tt <<EOF
1329951682:1329971682
EOF

test_todo_session 'timetracker stats only archived project' <<EOF
>>> todo.sh timetracker stats testing
$USAGE
      No current timetracker projects
=== 1
EOF

test_todo_session 'timetracker stats only archived +project' <<EOF
>>> todo.sh timetracker stats +testing
$USAGE
      No current timetracker projects
=== 1
EOF

mkdir -p tt/todo/archive
rm -rf tt/todo/testing.tt
cat > tt/todo/complete.tt <<EOF
1329951682
EOF
cat > tt/todo/testing.tt <<EOF
1329951682:1329971682
EOF

test_todo_session 'timetracker stats current and completed project' <<EOF
>>> todo.sh timetracker stats | sed '/^$/d'
Stats for Project: complete
===========================
Timer still running for complete
Stats for Project: testing
==========================
5 hours 33 minutes 20 seconds 
=== 0
EOF

#
## archivedstats
#

rm -rf tt/todo/archive/testing.tt

test_todo_session 'timetracker archivedstats no project' <<EOF
>>> todo.sh timetracker archivedstats
$USAGE
      No timetracker projects exist
=== 1
EOF

cat > tt/todo/archive/testing.tt <<EOF
1329951682:1329971682
EOF

test_todo_session 'timetracker archivedstats current project' <<EOF
>>> todo.sh timetracker archivedstats testing
Stats for archived Project: testing
===================================
5 hours 33 minutes 20 seconds 
=== 0
EOF

test_todo_session 'timetracker archivedstats current +project' <<EOF
>>> todo.sh timetracker archivedstats +testing
Stats for archived Project: testing
===================================
5 hours 33 minutes 20 seconds 
=== 0
EOF

rm -rf tt/todo/archive/testing.tt

test_todo_session 'timetracker archivedstats no current project' <<EOF
>>> todo.sh timetracker archivedstats testing
$USAGE
      No archived timetracker projects
=== 1
EOF

cat > tt/todo/testing.tt <<EOF
1329951682:1329971682
EOF

test_todo_session 'timetracker archivedstats only current project' <<EOF
>>> todo.sh timetracker archivedstats testing
$USAGE
      No archived timetracker projects
=== 1
EOF

#
## statsall
#

rm -rf tt/todo/
mkdir -p tt/todo/archive/

test_todo_session 'timetracker statsall no project' <<EOF
>>> todo.sh timetracker statsall
$USAGE
      No timetracker projects exist
=== 1
EOF

cat > tt/todo/testing.tt <<EOF
1329951682:1329971682
EOF

test_todo_session 'timetracker statsall 1 current project' <<EOF
>>> todo.sh timetracker statsall
Stats for Project: testing
==========================
5 hours 33 minutes 20 seconds 
=== 0
EOF

rm -rf tt/todo/testing.tt
cat > tt/todo/archive/around.tt <<EOF
1329951682:1329986682
EOF

test_todo_session 'timetracker statsall 1 archived project' <<EOF
>>> todo.sh timetracker statsall
Stats for archived Project: around
==================================
9 hours 43 minutes 20 seconds 
=== 0
EOF

cat > tt/todo/testing.tt <<EOF
1329951682:1329971682
EOF

test_todo_session 'timetracker statsall current and archived projects' <<EOF
>>> todo.sh timetracker statsall
Stats for Project: testing
==========================
5 hours 33 minutes 20 seconds 
Stats for archived Project: around
==================================
9 hours 43 minutes 20 seconds 
=== 0
EOF

cat > tt/todo/archive/about.tt <<EOF
1329951682:1329985682
EOF
cat > tt/todo/standard.tt <<EOF
1329951682:1329971182
EOF

test_todo_session 'timetracker statsall multiple current and archived projects' <<EOF
>>> todo.sh timetracker statsall
Stats for Project: standard
===========================
5 hours 25 minutes 
Stats for Project: testing
==========================
5 hours 33 minutes 20 seconds 
Stats for archived Project: about
=================================
9 hours 26 minutes 40 seconds 
Stats for archived Project: around
==================================
9 hours 43 minutes 20 seconds 
=== 0
EOF
test_done

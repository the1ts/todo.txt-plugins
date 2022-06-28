#!/bin/bash

# shellcheck disable=SC2034
test_description='notes actions functionality
'
# shellcheck disable=SC1091
. ./test-lib.sh -i

export TODO_ACTIONS_DIR=$TEST_DIRECTORY/../actions/timetracker

export USAGE="    timetracker on|off|list|archive|unarchive|stats|archivedstats|statsall [PROJECT]
      Track time spent on a project."

cat > todo.txt <<EOF
Buy tools +testing
Fix bicycle +foobar
Ride bike
EOF

mkdir -p tt/todo/archive/
# cat > tt/todo/archive/foobar.tt <<EOF
# 1329951682:1339955682
# EOF

# #
# ## no subaction
# #

# test_todo_session 'timetracker show usage' <<EOF
# >>> todo.sh timetracker usage
# $USAGE
# === 1
# EOF

# test_todo_session 'tt show usage' <<EOF
# >>> todo.sh tt usage
# $USAGE
# === 1
# EOF

# #
# ## on
# #

# export localUsage="    timetracker on [PROJECT]
#       Start tracking time in PROJECT"

# test_todo_session 'tton show usage' <<EOF
# >>> todo.sh tton usage
# $localUsage
# === 1
# EOF

# test_todo_session 'timetracker no project' <<EOF
# >>> todo.sh timetracker on
# $localUsage
#       No project given
# === 1
# EOF

# test_todo_session 'timetracker on for project not in todo.txt' <<EOF
# >>> todo.sh timetracker on wibble
# $localUsage
#       Project wibble is not in todo.txt
# === 1
# EOF

# test_todo_session 'timetracker on for project in todo.txt file' <<EOF
# >>> todo.sh timetracker on testing
# Starting clock on testing
# === 0
# EOF

# rm -rf tt/todo/testing.tt
# test_todo_session 'timetracker on for +project in todo.txt file' <<EOF
# >>> todo.sh timetracker on +testing
# Starting clock on testing
# === 0
# EOF

# test_todo_session 'timetracker on for project testing already started' <<EOF
# >>> todo.sh timetracker on testing
# $localUsage
#       Project testing is still active, cannot turn on the clock
# === 1
# EOF

# test_todo_session 'timetracker on for project archived project answer yes' <<EOF
# >>> yes | todo.sh timetracker on foobar
# Project foobar is archived, unarchive?
# Unarchiving and starting clock on foobar
# === 0
# EOF

# # Revert back to archived foobar
# rm -rf tt/todo//foobar.tt
# cat > tt/todo/archive/foobar.tt <<EOF
# 1329951682:1339955682
# EOF

# test_todo_session 'timetracker on for project archived project answer no' <<EOF
# >>> yes n | todo.sh timetracker on foobar
# Project foobar is archived, unarchive?
# Not unarchiving
# === 1
# EOF

# #
# ## off
# #

# export localUsage="    timetracker off [PROJECT]
#       Stop tracking time in PROJECT"

# test_todo_session 'ttoff show usage' <<EOF
# >>> todo.sh ttoff usage
# $localUsage
# === 1
# EOF

# cat > tt/todo/testing.tt <<EOF
# 1329951682
# EOF

# test_todo_session 'timetracker off running project' <<EOF
# >>> todo.sh timetracker off testing
# Stopping clock on testing
# === 0
# EOF

# cat > tt/todo/testing.tt <<EOF
# 1329951682
# EOF

# test_todo_session 'timetracker off running +project' <<EOF
# >>> todo.sh timetracker off +testing
# Stopping clock on testing
# === 0
# EOF

# cat > tt/todo/archive/foobararchive.tt <<EOF
# 1329951682
# EOF

# test_todo_session 'timetracker off running archived project' <<EOF
# >>> todo.sh timetracker off foobararchive
# Stopping clock on foobararchive which is archived
# === 0
# EOF

# test_todo_session 'timetracker off no such project tt file' <<EOF
# >>> todo.sh timetracker off nosuch
# $localUsage
#       Project nosuch does not exist in todo.txt
# === 1
# EOF

# cat >> todo.txt <<EOF
# Testing stuffs +nosuch
# EOF

# test_todo_session 'timetracker off project - no such project in todo.txt or tt files' <<EOF
# >>> todo.sh timetracker off nosuch
# $localUsage
#       No tt file for project nosuch
# === 1
# EOF

# #
# ## list
# #

# export localUsage="    timetracker list
#       Show list of current and archived projects"

# test_todo_session 'timetracker list usage' <<EOF
# >>> todo.sh timetracker list usage
# $localUsage
# === 0
# EOF

# test_todo_session 'ttlist usage' <<EOF
# >>> todo.sh tt list usage
# $localUsage
# === 0
# EOF

# test_todo_session 'timetracker list Current and Archived' <<EOF
# >>> todo.sh timetracker list | sed '/^$/d'
# Projects being time tracked
# ===========================
# Current
# -------
# testing
# Archived
# --------
# foobar
# foobararchive
# === 0
# EOF

# rm -rf "tt/todo/archive/foobararchive.tt"

# test_todo_session 'timetracker list Current and Archived after removal' <<EOF
# >>> todo.sh timetracker list | sed '/^$/d'
# Projects being time tracked
# ===========================
# Current
# -------
# testing
# Archived
# --------
# foobar
# === 0
# EOF

# rm -rf "tt/todo/archive/foobar.tt"

# test_todo_session 'timetracker list Current no Archived' <<EOF
# >>> todo.sh timetracker list | sed '/^$/d'
# Projects being time tracked
# ===========================
# Current
# -------
# testing
# === 0
# EOF

# rm -rf "tt/todo/archive/foobar.tt" "tt/todo/testing.tt" "tt/todo/Archived.tt"

# test_todo_session 'timetracker list no project files' <<EOF
# >>> todo.sh timetracker list | sed '/^$/d'
# $localUsage
#       No files to list
# === 0
# EOF

# #
# ## archive
# #

# export localUsage="    timetracker archive [PROJECT]
#       Archive current projects"

# test_todo_session 'timetracker archive usage' <<EOF
# >>> todo.sh timetracker archive usage
# $localUsage
# === 0
# EOF

# test_todo_session 'ttarchive usage' <<EOF
# >>> todo.sh ttarchive usage
# $localUsage
# === 0
# EOF

# test_todo_session 'timetracker archive no project files' <<EOF
# >>> todo.sh timetracker archive
# $localUsage
#       No project given
# === 1
# EOF

# cat > tt/todo/testing.tt <<EOF
# 1329951682:15000000
# EOF

# test_todo_session 'timetracker archive finished project' <<EOF
# >>> todo.sh timetracker archive testing
# Archived testing
# === 0
# EOF

# cat > tt/todo/testing.tt <<EOF
# 1329951682:15000000
# EOF

# test_todo_session 'timetracker archive finished +project' <<EOF
# >>> todo.sh timetracker archive testing
# Archived testing
# === 0
# EOF

# cat > tt/todo/testing.tt <<EOF
# 1329951682
# EOF

# test_todo_session 'timetracker archive started project' <<EOF
# >>> todo.sh timetracker archive testing
# Setting project testing as finished now and archiving
# === 0
# EOF

# cat > tt/todo/testing.tt <<EOF
# 1329951682
# EOF

# test_todo_session 'timetracker archive started +project' <<EOF
# >>> todo.sh timetracker archive +testing
# Setting project testing as finished now and archiving
# === 0
# EOF

# test_todo_session 'timetracker archive no project' <<EOF
# >>> todo.sh timetracker archive testing
# $localUsage
#       Project testing does not exist
# === 1
# EOF

# #
# ## unarchive
# #

# export localUsage="    timetracker unarchive [PROJECT]
#       Unarchive projects"

# test_todo_session 'timetracker unarchive usage' <<EOF
# >>> todo.sh timetracker unarchive usage
# $localUsage
# === 0
# EOF

# test_todo_session 'ttunarchive usage' <<EOF
# >>> todo.sh ttunarchive usage
# $localUsage
# === 0
# EOF

# # Create a started archived project
# rm -rf tt/todo/*.tt tt/todo/archive/*.tt
# cat > tt/todo/archive/testing.tt <<EOF
# 1329951682
# EOF

# test_todo_session 'timetracker unarchive started project' <<EOF
# >>> todo.sh timetracker unarchive testing
# Project testing unarchived
# === 0
# EOF

# # Create a started archived project
# rm -rf tt/todo/*.tt tt/todo/archive/*.tt
# cat > tt/todo/archive/testing.tt <<EOF
# 1329951682
# EOF

# test_todo_session 'timetracker unarchive started +project' <<EOF
# >>> todo.sh timetracker unarchive +testing
# Project testing unarchived
# === 0
# EOF

# # Create a completedarchived project
# rm -rf tt/todo/*.tt tt/todo/archive/*.tt
# cat > tt/todo/archive/testing.tt <<EOF
# 1329951682:125321532
# EOF

# test_todo_session 'timetracker unarchive completed project' <<EOF
# >>> todo.sh timetracker unarchive testing
# Project testing unarchived
# === 0
# EOF

# # Create a completedarchived project
# rm -rf tt/todo/*.tt tt/todo/archive/*.tt
# cat > tt/todo/archive/testing.tt <<EOF
# 1329951682:125321532
# EOF

# test_todo_session 'timetracker unarchive completed +project' <<EOF
# >>> todo.sh timetracker unarchive +testing
# Project testing unarchived
# === 0
# EOF

# rm -rf tt/todo/*.tt tt/todo/archive/*.tt

# test_todo_session 'timetracker unarchive none timetracker project' <<EOF
# >>> todo.sh timetracker unarchive testing
# $localUsage
#       Project testing not archived
# === 1
# EOF

# #
# ## stats
# #

# export localUsage="    timetracker stats [PROJECT]
#       Show stats on PROJECT"

# test_todo_session 'timetracker stats usage' <<EOF
# >>> todo.sh timetracker stats usage
# $localUsage
# === 0
# EOF

# test_todo_session 'ttstats usage' <<EOF
# >>> todo.sh ttstats usage
# $localUsage
# === 0
# EOF

# test_todo_session 'timetracker stats no project' <<EOF
# >>> todo.sh timetracker stats
# $localUsage
#       No current timetracker projects
# === 1
# EOF

# # Create a completedarchived project
# rm -rf tt/todo/*.tt tt/todo/archive/*.tt
# cat > tt/todo/testing.tt <<EOF
# 1329951682:1349951682
# EOF

# test_todo_session 'timetracker stats current project' <<EOF
# >>> todo.sh timetracker stats testing
# Stats for Project: testing
# ==========================
# 231 days 11 hours 33 minutes 20 seconds 
# === 0
# EOF

# test_todo_session 'timetracker stats current +project' <<EOF
# >>> todo.sh timetracker stats +testing
# Stats for Project: testing
# ==========================
# 231 days 11 hours 33 minutes 20 seconds 
# === 0
# EOF

# rm -rf tt/todo/testing.tt

# test_todo_session 'timetracker stats no current project' <<EOF
# >>> todo.sh timetracker stats testing
# $localUsage
#       No current timetracker projects
# === 1
# EOF

# cat > tt/todo/archive/testing.tt <<EOF
# 1329951682:1329971682
# EOF

# test_todo_session 'timetracker stats only archived project' <<EOF
# >>> todo.sh timetracker stats testing
# $localUsage
#       No current timetracker projects
# === 1
# EOF

# test_todo_session 'timetracker stats only archived +project' <<EOF
# >>> todo.sh timetracker stats +testing
# $localUsage
#       No current timetracker projects
# === 1
# EOF

# mkdir -p tt/todo/archive
# rm -rf tt/todo/testing.tt
# cat > tt/todo/complete.tt <<EOF
# 1329951682
# EOF
# cat > tt/todo/testing.tt <<EOF
# 1329951682:1329971682
# EOF

# test_todo_session 'timetracker stats current and completed project' <<EOF
# >>> todo.sh timetracker stats | sed '/^$/d'
# Stats for Project: complete
# ===========================
# Timer still running for complete
# Stats for Project: testing
# ==========================
# 5 hours 33 minutes 20 seconds 
# === 0
# EOF

# #
# ## archivedstats
# #

# export localUsage="    timetracker archivedstats [PROJECT]
#       Show stats on archived PROJECT"

# test_todo_session 'timetracker archivedstats usage' <<EOF
# >>> todo.sh timetracker archivedstats usage
# $localUsage
# === 0
# EOF

# rm -rf tt/todo/archive/ tt/todo/archive
# mkdir -p tt/todo/archive

# test_todo_session 'timetracker archivedstats no project' <<EOF
# >>> todo.sh timetracker archivedstats
# $localUsage
#       No archived timetracker projects
# === 1
# EOF

# cat > tt/todo/archive/testing.tt <<EOF
# 1329951682:1329971682
# EOF

# test_todo_session 'timetracker archivedstats current project' <<EOF
# >>> todo.sh timetracker archivedstats testing
# Stats for archived Project: testing
# ===================================
# 5 hours 33 minutes 20 seconds 
# === 0
# EOF

# test_todo_session 'timetracker archivedstats current +project' <<EOF
# >>> todo.sh timetracker archivedstats +testing
# Stats for archived Project: testing
# ===================================
# 5 hours 33 minutes 20 seconds 
# === 0
# EOF

# rm -rf tt/todo/archive/testing.tt

# test_todo_session 'timetracker archivedstats no current project' <<EOF
# >>> todo.sh timetracker archivedstats testing
# $localUsage
#       No archived timetracker projects
# === 1
# EOF

# cat > tt/todo/testing.tt <<EOF
# 1329951682:1329971682
# EOF

# test_todo_session 'timetracker archivedstats only current project' <<EOF
# >>> todo.sh timetracker archivedstats testing
# $localUsage
#       No archived timetracker projects
# === 1
# EOF

# #
# ## statsall
# #

# export localUsage="    timetracker statsall
#       Show stats on all projects"

# rm -rf tt/todo/
# mkdir -p tt/todo/archive/

# test_todo_session 'timetracker statsall usage' <<EOF
# >>> todo.sh timetracker statsall usage
# $localUsage
# === 0
# EOF

# test_todo_session 'timetracker statsall no project' <<EOF
# >>> todo.sh timetracker statsall
# $localUsage
#       No timetracker projects exist
# === 1
# EOF

# cat > tt/todo/testing.tt <<EOF
# 1329951682:1329971682
# EOF

# test_todo_session 'timetracker statsall 1 current project' <<EOF
# >>> todo.sh timetracker statsall
# Stats for Project: testing
# ==========================
# 5 hours 33 minutes 20 seconds 
# === 0
# EOF

# rm -rf tt/todo/testing.tt
# cat > tt/todo/archive/around.tt <<EOF
# 1329951682:1329986682
# EOF

# test_todo_session 'timetracker statsall 1 archived project' <<EOF
# >>> todo.sh timetracker statsall
# Stats for archived Project: around
# ==================================
# 9 hours 43 minutes 20 seconds 
# === 0
# EOF

# cat > tt/todo/testing.tt <<EOF
# 1329951682:1329971682
# EOF

# test_todo_session 'timetracker statsall current and archived projects' <<EOF
# >>> todo.sh timetracker statsall
# Stats for Project: testing
# ==========================
# 5 hours 33 minutes 20 seconds 
# Stats for archived Project: around
# ==================================
# 9 hours 43 minutes 20 seconds 
# === 0
# EOF

# cat > tt/todo/archive/about.tt <<EOF
# 1329951682:1329985682
# EOF
# cat > tt/todo/standard.tt <<EOF
# 1329951682:1329971182
# EOF

# test_todo_session 'timetracker statsall multiple current and archived projects' <<EOF
# >>> todo.sh timetracker statsall
# Stats for Project: standard
# ===========================
# 5 hours 25 minutes 
# Stats for Project: testing
# ==========================
# 5 hours 33 minutes 20 seconds 
# Stats for archived Project: about
# =================================
# 9 hours 26 minutes 40 seconds 
# Stats for archived Project: around
# ==================================
# 9 hours 43 minutes 20 seconds 
# === 0
# EOF

#
## simplelist of started variety
#

cat > tt/todo/standard.tt <<EOF
1329951682
EOF
cat > tt/todo/archive/foobar.tt <<EOF
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

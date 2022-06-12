#!/bin/bash

# shellcheck disable=SC2034
test_description='notes actions functionality
'
# shellcheck disable=SC2034,SC1091
. ./test-lib.sh -i

export TODO_ACTIONS_DIR=$TEST_DIRECTORY/../actions/notes

# Make our notes and archive directories
mkdir -p notes/archive

# Set editor to cat so it tests nicely.
export EDITOR="cat"

USAGETEXT="    notes [add|archive|cat|edit|grep|list|listarchived|rename|unarchive]"

test_todo_session 'notes show usage' <<EOF
>>> todo.sh notes usage
${USAGETEXT}
=== 0
EOF

#
## add
#

# Create our todo.txt
cat > todo.txt <<EOF
Buy tools
Fix bicycle
Ride bike
EOF

test_todo_session 'notes add subaction help' <<EOF
>>> todo.sh notes add help
    notes add [ITEMS] [NOTESFILE]
      append NOTESFILE to ITEMS and edit NOTESFILE if new
=== 1
EOF

test_todo_session 'notes add note to task' <<EOF
>>> todo.sh notes add 1 test
1 Buy tools note:test
TODO: note:test added to item 1
=== 0
EOF

test_todo_session 'notes add note to task note:test style' <<EOF
>>> todo.sh notes add 1 note:test1
1 Buy tools note:test note:test1
TODO: note:test1 added to item 1
=== 0
EOF

test_todo_session 'notes add item only no note' <<EOF
>>> todo.sh notes add 1
      No notesfile given
    notes add [ITEMS] [NOTESFILE]
      append NOTESFILE to ITEMS and edit NOTESFILE if new
=== 1
EOF

test_todo_session 'notes add no item only note' <<EOF
>>> todo.sh notes add testing
      No item given
    notes add [ITEMS] [NOTESFILE]
      append NOTESFILE to ITEMS and edit NOTESFILE if new
=== 1
EOF

test_todo_session 'notes add item nonexistant' <<EOF
>>> todo.sh notes add 100 testing
      ITEM 100 not in todo file
    notes add [ITEMS] [NOTESFILE]
      append NOTESFILE to ITEMS and edit NOTESFILE if new
=== 1
EOF

test_todo_session 'notes add multiple items and note' <<EOF
>>> todo.sh notes add 2 3 testing
2 Fix bicycle note:testing
TODO: note:testing added to item 2
3 Ride bike note:testing
TODO: note:testing added to item 3
=== 0
EOF

#
## archive
#

# Create our notes and archive directories
rm -rf notes/archive
mkdir -p notes/archive

# Recreate our todo.txt file
cat > todo.txt <<EOF
Buy tools note:test
Fix bicycle note:testing
Ride bike note:testing
EOF
# Create our first notes file with some content
cat > notes/todo-test.txt << EOF                                                         
test note first line
test note second line
EOF
# Create our second notes file with some content
cat > ./notes/todo-testing.txt << EOF                                                         
test note first line
test note second line
EOF
# Create our first archived notes file
cat > ./notes/archive/todo-test-previous.10100000.txt << EOF                                                         
test note first line
test note second line
test note third line
EOF

# Create our note file not in todo.txt
cat > ./notes/todo-archive_file.txt << EOF                                                         
File to test archiving
EOF

test_todo_session 'notes archive subaction help' <<EOF
>>> todo.sh notes archive help
    notes archive
      Archive NOTESFILE not in todo.txt
=== 1
EOF

test_todo_session 'notes archive run' <<EOF
>>> todo.sh notes archive 
TODO: Archived note:archive_file
=== 0
EOF

# Create our note file again to see archiving of already archived notes works
cat > ./notes/todo-archive_file.txt << EOF                                                         
File to test archiving
EOF
mv ./notes/archive/todo-archive_file.1234500000.txt ./notes/archive/todo-archive_file.1234490000.txt

test_todo_session 'notes archive run with already archived notefile' <<EOF
>>> todo.sh notes archive; ls notes/archive/todo-archive*txt
TODO: Archived note:archive_file
notes/archive/todo-archive_file.1234490000.txt
notes/archive/todo-archive_file.1234500000.txt
=== 0
EOF

test_todo_session 'notes archive run, nothing to archive' <<EOF
>>> todo.sh notes archive
TODO: Nothing to archive
=== 1
EOF

#
## cat
#

# Create our notes and archive directories
rm -rf notes/archive
mkdir -p notes/archive

# Create our todo.txt file
cat > todo.txt <<EOF
Buy tools note:test
Fix bicycle note:testing
Ride bike note:testing
EOF

# Create our notes file with some content
cat > notes/todo-test.txt << EOF                                                         
test note first line
test note second line
EOF

test_todo_session 'notes cat subaction help' <<EOF
>>> todo.sh notes cat help
    notes cat [NOTESFILE]
      Show NOTESFILE
=== 1
EOF

test_todo_session 'notes cat no notes file' <<EOF
>>> todo.sh notes cat
      No notes file
    notes cat [NOTESFILE]
      Show NOTESFILE
=== 1
EOF

test_todo_session 'notes cat show notesfile' <<EOF
>>> todo.sh notes cat test
test note first line
test note second line
=== 0
EOF

test_todo_session 'notes cat show notesfile in note:test style' <<EOF
>>> todo.sh notes cat note:test
test note first line
test note second line
=== 0
EOF

test_todo_session 'notes cat show no such note' <<EOF
>>> todo.sh notes cat note:notafile
      Notes file notafile not in todo.txt file,
      use listnotes to find notes files
    notes cat [NOTESFILE]
      Show NOTESFILE
=== 1
EOF

#
## edit
#

# Create our notes and archive directories
rm -rf notes/archive
mkdir -p notes/archive

# Create our todo.txt file
cat > todo.txt <<EOF
Buy tools note:test
Fix bicycle note:testing
Ride bike note:testing
EOF
# Create our notes file with some content
cat > notes/todo-test.txt << EOF                                                         
test note first line
test note second line
EOF

test_todo_session 'notes edit subaction help' <<EOF
>>> todo.sh notes edit help
    notes edit [NOTESFILE]
      Edit notes file, in \$EDITOR.
      use listnotes to get list of notes files
=== 1
EOF

test_todo_session 'notes edit no notefile' <<EOF
>>> todo.sh notes edit
      No notes file
    notes edit [NOTESFILE]
      Edit notes file, in \$EDITOR.
      use listnotes to get list of notes files
=== 1
EOF

test_todo_session 'notes edit no such notefile' <<EOF
>>> todo.sh notes edit note:notafile
      No such notes file, use listnotes to find notes files
    notes edit [NOTESFILE]
      Edit notes file, in \$EDITOR.
      use listnotes to get list of notes files
=== 1
EOF

test_todo_session 'notes edit show a notefile' <<EOF
>>> todo.sh notes edit test
test note first line
test note second line
=== 0
EOF

test_todo_session 'notes edit show a notefile in note:test style' <<EOF
>>> todo.sh notes edit note:test
test note first line
test note second line
=== 0
EOF

#
## grep
#

# Make our notes and archive directories
rm -rf notes/archive
mkdir -p notes/archive
# Create our todo.txt file
cat > todo.txt <<EOF
Buy tools note:test
Fix bicycle note:testing
Ride bike note:testing
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

test_todo_session 'notes grep subaction help' <<EOF
>>> todo.sh notes grep help
    notes grep -a [TERM...]
      List notes that contain a TERM within them
      -a show archived notes
=== 1
EOF

test_todo_session 'notes grep no term' <<EOF
>>> todo.sh notes grep
    No TERM
    notes grep -a [TERM...]
      List notes that contain a TERM within them
      -a show archived notes
=== 1
EOF

test_todo_session 'notes grep term not found' <<EOF
>>> todo.sh notes grep foobar
No current Notes containing "foobar"
=== 1
EOF

test_todo_session 'notes grep term not found in current or archive' <<EOF
>>> todo.sh notes grep -a foobar
No current Notes containing "foobar"
No archived Notes containing "foobar"
=== 1
EOF

test_todo_session 'notes grep term found' <<EOF
>>> todo.sh notes grep second
Notes Files containing "second"
-----------
note:test
note:testing
=== 0
EOF

# Blank line becomes space for EOF usage
test_todo_session 'notes grep term found also in archive' <<EOF
>>> todo.sh notes grep -a second | sed '/^$/d'
Notes Files containing "second"
-----------
note:test
note:testing
Archived Notes Files containing "second"
--------------------
note:test-previous
=== 0
EOF

test_todo_session 'notes grep term found only in archive' <<EOF
>>> todo.sh notes grep -a third | sed '/^$/d'
No current Notes containing "third"
Archived Notes Files containing "third"
--------------------
note:test-previous
=== 0
EOF

#
## list
#

# Create our notes and archive directories
rm -rf notes/archive
mkdir -p notes/archive
# Create our todo.txt file
cat > todo.txt <<EOF
Buy tools note:test
Fix bicycle note:testing
Ride bike note:testing
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

test_todo_session 'notes list subaction help' <<EOF
>>> todo.sh notes list help
    notes list [TERM...]
      List notes
=== 1
EOF

test_todo_session 'notes list all' <<EOF
>>> todo.sh notes list
note:test
note:testing
=== 0
EOF

test_todo_session 'notes list containing term' <<EOF
>>> todo.sh notes list testing
note:testing
=== 0
EOF

test_todo_session 'notes list unable to find term' <<EOF
>>> todo.sh notes list foobar
      No notes with the term "foobar"
    notes list [TERM...]
      List notes
=== 1
EOF

#
## listarchived
#

# Create our notes and archive directories
rm -rf notes/archive
mkdir -p notes/archive
# Create our todo.txt file
cat > todo.txt <<EOF
Buy tools note:test
Fix bicycle note:testing
Ride bike note:testing
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

test_todo_session 'notes listarchived subaction help' <<EOF
>>> todo.sh notes listarchived help
    notes listarchived [TERM...]
      List archived notes
=== 1
EOF

test_todo_session 'notes listarchived all' <<EOF
>>> todo.sh notes listarchived
note:test-previous
=== 0
EOF

test_todo_session 'notes listarchived containing term' <<EOF
>>> todo.sh notes listarchived test
note:test-previous
=== 0
EOF

test_todo_session 'notes listarchived unable to find term' <<EOF
>>> todo.sh notes listarchived foobar
      No notes with the term "foobar"
    notes listarchived [TERM...]
      List archived notes
=== 1
EOF

#
## rename
#

# Create our notes and archive directories
rm -rf notes/archive
mkdir -p notes/archive
# Create our todo.txt file
cat > todo.txt <<EOF
Buy tools note:test
Fix bicycle note:testing
Ride bike note:testing
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

test_todo_session 'notes rename subaction help' <<EOF
>>> todo.sh notes rename help
    notes rename [ORIGINAL_NOTESFILE] [NEW_NOTESFILE]
      rename ORIGINAL_NOTESFILE to NEW_NOTESFILE
      renames in todo.txt and notefile
      the note: is not required, but added
=== 1
EOF

test_todo_session 'notes rename not enough options' <<EOF
>>> todo.sh notes rename foobar
    check number of options
    notes rename [ORIGINAL_NOTESFILE] [NEW_NOTESFILE]
      rename ORIGINAL_NOTESFILE to NEW_NOTESFILE
      renames in todo.txt and notefile
      the note: is not required, but added
=== 1
EOF

test_todo_session 'notes rename too many options' <<EOF
>>> todo.sh notes rename foo bar wibble
    check number of options
    notes rename [ORIGINAL_NOTESFILE] [NEW_NOTESFILE]
      rename ORIGINAL_NOTESFILE to NEW_NOTESFILE
      renames in todo.txt and notefile
      the note: is not required, but added
=== 1
EOF

test_todo_session 'notes rename original note not in todo.txt' <<EOF
>>> todo.sh notes rename foo bar
    foo is not a current note, use listnotes to find notes.
    notes rename [ORIGINAL_NOTESFILE] [NEW_NOTESFILE]
      rename ORIGINAL_NOTESFILE to NEW_NOTESFILE
      renames in todo.txt and notefile
      the note: is not required, but added
=== 1
EOF

test_todo_session 'notes rename original note to new note todo.txt only' <<EOF
>>> todo.sh notes rename testing test1; cat todo.txt
TODO: Changed note:testing to note:test1 in todo.txt
Buy tools note:test
Fix bicycle note:test1
Ride bike note:test1
=== 0
EOF

cat > done.txt << EOF                                                         
2021-01-01 test line 1 note:test2
2021-01-01 test line 2 note:test4
EOF

cat > todo.txt << EOF                                                         
test new line note:test2
EOF

test_todo_session 'notes rename original note to new note todo.txt and done.txt' <<EOF
>>> todo.sh notes rename test2 test3; cat todo.txt done.txt
TODO: Changed note:test2 to note:test3 in todo.txt
TODO: Changed note:test2 to note:test3 in done.txt
test new line note:test3
2021-01-01 test line 1 note:test3
2021-01-01 test line 2 note:test4
=== 0
EOF

test_todo_session 'notes rename original note to new note done.txt only' <<EOF
>>> todo.sh notes rename test4 test5; cat done.txt
TODO: Changed note:test4 to note:test5 in done.txt
2021-01-01 test line 1 note:test3
2021-01-01 test line 2 note:test5
=== 0
EOF

#
## unarchive
#

# Create our notes and archive directories
rm -rf notes/archive
mkdir -p notes/archive
# Create our todo.txt file
cat > todo.txt <<EOF
Buy tools note:test
Fix bicycle note:testing
Ride bike note:testing
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
cat > ./notes/archive/todo-test_previous.10100000.txt << EOF                                                         
test note first line
test note second line
test note third line
EOF
cat > ./notes/archive/todo-testing.1010000.txt << EOF                                                         
test note first line
test note second line
older
EOF
cat > ./notes/archive/todo-testing.1020000.txt << EOF                                                         
test note first line
test note second line
younger
EOF

test_todo_session 'notes unarchive usage' <<EOF
>>> todo.sh notes unarchive usage
    notes unarchive [NOTESFILE]
      unarchive notes files, this brings back the last
      version of the notefile
=== 1
EOF

test_todo_session 'notes unarchive for note never archived' <<EOF
>>> todo.sh notes unarchive foobar
      No archived notes file named foobar. Use notes listarchived to find them
    notes unarchive [NOTESFILE]
      unarchive notes files, this brings back the last
      version of the notefile
=== 1
EOF

test_todo_session 'notes unarchive file' <<EOF
>>> todo.sh notes unarchive testing; cat notes/todo-testing.txt
TODO: Notes file todo-testing.txt restored from newest archive
test note first line
test note second line
younger
=== 0
EOF

test_todo_session 'notes unarchive test restored file is younger file' <<EOF
>>> todo.sh notescat testing
test note first line
test note second line
younger
=== 0
EOF

test_todo_session 'notes unarchive notefile not in todo.txt' <<EOF
>>> todo.sh notes unarchive test_previous
      Note file test_previous not mentioned in todo
      use listnotes to find them
    notes unarchive [NOTESFILE]
      unarchive notes files, this brings back the last
      version of the notefile
=== 1
EOF

test_done

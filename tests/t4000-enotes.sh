#!/bin/bash

# shellcheck disable=SC2034
test_description='notes actions functionality
'
# shellcheck disable=SC2034,SC1091
. ./test-lib.sh -i

export TODO_ACTIONS_DIR=$TEST_DIRECTORY/../actions/enotes

# Make our notes and archive directories
mkdir -p notes/archive

# Set editor to cat so it tests nicely.
export EDITOR="cat"

USAGETEXT="    enotes [add|archive|cat|edit|list|listarchived|rename|unarchive]"

# shellcheck disable=SC2155
export GNUPGHOME="$(mktemp -d)" || {
	echo "Failed to create temp file"
	exit 1
}
export GPG_USER="user@tests.com"
# Setup gpg and a key for our enotes testing
gpg --list-keys --no-verbose -q 1>/dev/null
# shellcheck disable=SC2086
cat >${GNUPGHOME}/key <<EOF
    %echo Generating a basic OpenPGP key
    Key-Type: RSA
    Key-Length: 3072
    Subkey-Type: RSA
    Subkey-Length: 3072
    Name-Real: test key
    Name-Comment: test key
    Name-Email: user@tests.com
    Expire-Date: 0
    %no-ask-passphrase
    %no-protection
    %commit
    %echo done
EOF
# shellcheck disable=SC2086
gpg --batch --no-verbose -q --full-gen-key ${GNUPGHOME}/key

# Create our notes file with some content
echo -e "test note first line\ntest note second line" | gpg -q --no-verbose -e -r user@tests.com >notes/todo-test.enc

test_todo_session 'enotes show usage' <<EOF
>>> todo.sh enotes usage
${USAGETEXT}
=== 0
EOF

#
## add
#

# Create our todo.txt
cat >todo.txt <<EOF
Buy tools
Fix bicycle
Ride bike
EOF

test_todo_session 'enotes add subaction help' <<EOF
>>> todo.sh enotes add help
    enotes add [ITEMS] [ENOTESFILE]
      append ENOTESFILE to ITEMS and edit ENOTESFILE if new
=== 1
EOF

test_todo_session 'enotes add note to task' <<EOF
>>> todo.sh enotes add 1 test
1 Buy tools enote:test
TODO: enote:test added to item 1
=== 0
EOF

test_todo_session 'enotes add note to task note:test style' <<EOF
>>> todo.sh enotes add 1 enote:test1
1 Buy tools enote:test enote:test1
TODO: enote:test1 added to item 1
=== 0
EOF

test_todo_session 'enotes add item only no note' <<EOF
>>> todo.sh enotes add 1
      No enotesfile given
    enotes add [ITEMS] [ENOTESFILE]
      append ENOTESFILE to ITEMS and edit ENOTESFILE if new
=== 1
EOF

test_todo_session 'enotes add no item only note' <<EOF
>>> todo.sh enotes add testing
      No item given
    enotes add [ITEMS] [ENOTESFILE]
      append ENOTESFILE to ITEMS and edit ENOTESFILE if new
=== 1
EOF

test_todo_session 'enotes add item nonexistant' <<EOF
>>> todo.sh enotes add 100 testing
      ITEM 100 not in todo file
    enotes add [ITEMS] [ENOTESFILE]
      append ENOTESFILE to ITEMS and edit ENOTESFILE if new
=== 1
EOF

test_todo_session 'enotes add multiple items and note' <<EOF
>>> todo.sh enotes add 2 3 testing
2 Fix bicycle enote:testing
TODO: enote:testing added to item 2
3 Ride bike enote:testing
TODO: enote:testing added to item 3
=== 0
EOF

#
## archive
#

# Create our notes and archive directories
rm -rf notes/archive
mkdir -p notes/archive

# Recreate our todo.txt file
cat >todo.txt <<EOF
Buy tools enote:test
Fix bicycle enote:testing
Ride bike enote:testing
EOF
# Create our first notes file with some content
cat >notes/todo-test.enc <<EOF
test note first line
test note second line
EOF
# Create our second notes file with some content
cat >./notes/todo-testing.enc <<EOF
test note first line
test note second line
EOF
# Create our first archived notes file
cat >./notes/archive/todo-test-previous.10100000.enc <<EOF
test note first line
test note second line
test note third line
EOF

# Create our note file not in todo.txt
cat >./notes/todo-archive_file.enc <<EOF
File to test archiving
EOF

test_todo_session 'enotes archive subaction help' <<EOF
>>> todo.sh enotes archive help
    enotes archive
      Archive ENOTESFILE not in todo.txt
=== 1
EOF

test_todo_session 'enotes archive run' <<EOF
>>> todo.sh enotes archive 
TODO: Archived enote:archive_file
=== 0
EOF

# Create our note file again to see archiving of already archived notes works
cat >./notes/todo-archive_file.enc <<EOF
File to test archiving
EOF
mv ./notes/archive/todo-archive_file.1234500000.enc ./notes/archive/todo-archive_file.1234490000.enc

test_todo_session 'enotes archive run with already archived enotefile' <<EOF
>>> todo.sh enotes archive; ls notes/archive/todo-archive*enc
TODO: Archived enote:archive_file
notes/archive/todo-archive_file.1234490000.enc
notes/archive/todo-archive_file.1234500000.enc
=== 0
EOF

test_todo_session 'enotes archive run, nothing to archive' <<EOF
>>> todo.sh enotes archive
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
cat >todo.txt <<EOF
Buy tools enote:test
Fix bicycle enote:testing
Ride bike enote:testing
Tail a criminal enote:broken
EOF
# Create our notes file with some content
echo -e "test note first line\ntest note second line" | gpg -q --no-verbose -e -r user@tests.com >notes/todo-test.enc

test_todo_session 'enotes cat subaction help' <<EOF
>>> todo.sh enotes cat help
    enotes cat [ENOTESFILE]
      Show ENOTESFILE
=== 1
EOF

test_todo_session 'enotes cat no notes file' <<EOF
>>> todo.sh enotes cat
      No encrypted notes file
    enotes cat [ENOTESFILE]
      Show ENOTESFILE
=== 1
EOF

test_todo_session 'enotes cat show notesfile' <<EOF
>>> todo.sh enotes cat test
test note first line
test note second line
=== 0
EOF

test_todo_session 'enotes cat show enotesfile in enote:test style' <<EOF
>>> todo.sh enotes cat enote:test
test note first line
test note second line
=== 0
EOF

test_todo_session 'enotes cat show no such enote' <<EOF
>>> todo.sh enotes cat enote:notafile
      Encrypted notes file notafile not in todo.txt file,
      use listenotes to find encrypted notes files
    enotes cat [ENOTESFILE]
      Show ENOTESFILE
=== 1
EOF

# Create our second notes file with some content
cat >./notes/todo-broken.enc <<EOF
test note first line
test note second line
EOF

test_todo_session 'enotes cat show broken enote' <<EOF
>>> todo.sh enotes cat enote:broken
      Unable to decrypt todo-broken.enc
    enotes cat [ENOTESFILE]
      Show ENOTESFILE
=== 1
EOF

#
## edit
#

# Create our todo.txt file
cat >todo.txt <<EOF
Buy tools enote:test
Fix bicycle enote:testing
Ride bike enote:testing
EOF

test_todo_session 'enotes edit usage' <<EOF
>>> todo.sh enotes edit usage
    enotes edit [ENOTESFILE]
      Edit encrypted ENOTESFILE in \$EDITOR
      Use listenotes to show all encrypted notesfiles
=== 1
EOF

test_todo_session 'enotes edit no enotefile' <<EOF
>>> todo.sh enotes edit
      No encryted notes file
    enotes edit [ENOTESFILE]
      Edit encrypted ENOTESFILE in \$EDITOR
      Use listenotes to show all encrypted notesfiles
=== 1
EOF

test_todo_session 'enotes edit no such enotefile' <<EOF
>>> todo.sh enotes edit note:notafile
      Encrypted notes file  not in todo.txt file,
      use listenotes to find encrypted notes files
    enotes edit [ENOTESFILE]
      Edit encrypted ENOTESFILE in \$EDITOR
      Use listenotes to show all encrypted notesfiles
=== 1
EOF

# With editor set to cat it will just print
test_todo_session 'enotes edit a enotefile' <<EOF
>>> todo.sh enotes edit enote:test
test note first line
test note second line
=== 0
EOF

# Create a badfile (not encrypted) and put in todo.txt
cat >notes/todo-badfile.enc <<EOF
badfile contents
EOF
cat >>todo.txt <<EOF
badfile line enote:badfile
EOF

test_todo_session 'enotes edit fail to decrypt' <<EOF
>>> todo.sh enotes edit enote:badfile
      Unable to decrypt todo-badfile.enc
    enotes edit [ENOTESFILE]
      Edit encrypted ENOTESFILE in \$EDITOR
      Use listenotes to show all encrypted notesfiles
=== 1
EOF

# Test for GPG_USER not in todo.cfg
unset GPG_USER

test_todo_session 'enotes edit no GPG_USER' <<EOF
>>> todo.sh enotes edit enote:test
      Please set a variable GPG_USER in your todo.cfg
    enotes edit [ENOTESFILE]
      Edit encrypted ENOTESFILE in \$EDITOR
      Use listenotes to show all encrypted notesfiles
=== 1
EOF

export GPG_USER="user@tests.com"

#
## list
#

# Create our notes and archive directories
rm -rf notes/archive
mkdir -p notes/archive
# Create our todo.txt file
cat >todo.txt <<EOF
Buy tools enote:test
Fix bicycle enote:testing
Ride bike enote:testing
EOF

# Create our notes file with some content
cat >notes/todo-test.txt <<EOF
test note first line
test note second line
EOF
cat >./notes/todo-testing.txt <<EOF
test note first line
test note second line
EOF
cat >./notes/archive/todo-test-previous.10100000.txt <<EOF
test note first line
test note second line
test note third line
EOF

test_todo_session 'enotes list usage' <<EOF
>>> todo.sh enotes list usage
    enotes list [TERM...]
      List encrypted notes
=== 1
EOF

test_todo_session 'enotes list all' <<EOF
>>> todo.sh enotes list
enote:test
enote:testing
=== 0
EOF

test_todo_session 'enotes list containing term' <<EOF
>>> todo.sh enotes list testing
enote:testing
=== 0
EOF

test_todo_session 'enotes list unable to find term' <<EOF
>>> todo.sh enotes list foobar
      No encrypted notes with the term "foobar"
    enotes list [TERM...]
      List encrypted notes
=== 1
EOF

#
## listarchived
#

# Create our notes and archive directories
rm -rf notes/archive
mkdir -p notes/archive

# Create our todo.txt file
cat >todo.txt <<EOF
Buy tools enote:test
Fix bicycle enote:testing
Ride bike enote:testing
EOF
# Create our notes file with some content
cat >notes/todo-test.enc <<EOF
test note first line
test note second line
EOF
# Create our notes file with some content
cat >./notes/archive/todo-testing.enc <<EOF
test note first line
test note second line
EOF
cat >./notes/archive/todo-previous.10100000.enc <<EOF
test note first line
test note second line
test note third line
EOF

test_todo_session 'enotes listarchived usage' <<EOF
>>> todo.sh enotes listarchived usage
    enotes listarchived [TERM]
      List archived encrypted notes
=== 1
EOF

test_todo_session 'enotes listarchived all' <<EOF
>>> todo.sh enotes listarchived
enote:previous
enote:testing
=== 0
EOF

test_todo_session 'enotes listarchived containing term' <<EOF
>>> todo.sh enotes listarchived test
enote:testing
=== 0
EOF

test_todo_session 'enotes listarchived unable to find term' <<EOF
>>> todo.sh enotes listarchived foobar
      No encrypted notes with the term "foobar"
    enotes listarchived [TERM]
      List archived encrypted notes
=== 1
EOF

#
## rename
#

# Create our notes and archive directories
rm -rf notes/archive
mkdir -p notes/archive

# Create our todo.txt file
cat >todo.txt <<EOF
Buy tools enote:test
Fix bicycle enote:testing
Ride bike enote:testing
EOF
# Create our notes file with some content
cat >notes/todo-test.txt <<EOF
test note first line
test note second line
EOF
# Create our notes file with some content
cat >./notes/todo-testing.txt <<EOF
test note first line
test note second line
EOF
cat >./notes/archive/todo-test-previous.10100000.txt <<EOF
test note first line
test note second line
test note third line
EOF

test_todo_session 'enotes rename usage' <<EOF
>>> todo.sh enotes rename usage
    enotes rename [ORIGINAL_ENOTESFILE] [NEW_ENOTESFILE]
      rename ORIGINAL_ENOTESFILE to NEW_ENOTESFILE
      renames in todo.txt and enotefile
      the enote: is not required, but added
=== 1
EOF

test_todo_session 'enotes rename not enough options' <<EOF
>>> todo.sh enotes rename foobar
    check number of options
    enotes rename [ORIGINAL_ENOTESFILE] [NEW_ENOTESFILE]
      rename ORIGINAL_ENOTESFILE to NEW_ENOTESFILE
      renames in todo.txt and enotefile
      the enote: is not required, but added
=== 1
EOF

test_todo_session 'enotes rename too many options' <<EOF
>>> todo.sh enotes rename foo bar wibble
    check number of options
    enotes rename [ORIGINAL_ENOTESFILE] [NEW_ENOTESFILE]
      rename ORIGINAL_ENOTESFILE to NEW_ENOTESFILE
      renames in todo.txt and enotefile
      the enote: is not required, but added
=== 1
EOF

test_todo_session 'enotes rename original enote not in todo.txt' <<EOF
>>> todo.sh enotes rename foo bar
    foo is not a current enote, use listenotes to find enotes.
    enotes rename [ORIGINAL_ENOTESFILE] [NEW_ENOTESFILE]
      rename ORIGINAL_ENOTESFILE to NEW_ENOTESFILE
      renames in todo.txt and enotefile
      the enote: is not required, but added
=== 1
EOF

test_todo_session 'enotes rename original enote to new enote todo.txt only' <<EOF
>>> todo.sh enotes rename testing test1; cat todo.txt
TODO: Changed enote:testing to enote:test1 in todo.txt
Buy tools enote:test
Fix bicycle enote:test1
Ride bike enote:test1
=== 0
EOF

cat >done.txt <<EOF
2021-01-01 test line 1 enote:test2
2021-01-01 test line 2 enote:test4
EOF

cat >todo.txt <<EOF
test new line enote:test2
EOF

test_todo_session 'enotes rename original enote to new enote todo.txt and done.txt' <<EOF
>>> todo.sh enotes rename test2 test3; cat todo.txt done.txt
TODO: Changed enote:test2 to enote:test3 in todo.txt
TODO: Changed enote:test2 to enote:test3 in done.txt
test new line enote:test3
2021-01-01 test line 1 eenote:test3
2021-01-01 test line 2 enote:test4
=== 0
EOF

test_todo_session 'enotes rename original enote to new enote done.txt only' <<EOF
>>> todo.sh enotes rename test4 test5; cat done.txt
TODO: Changed enote:test4 to enote:test5 in done.txt
2021-01-01 test line 1 eenote:test3
2021-01-01 test line 2 eenote:test5
=== 0
EOF

#
## unarchive
#

# Create our notes and archive directories
rm -rf notes/archive
mkdir -p notes/archive

# Create our todo.txt file
cat >todo.txt <<EOF
Buy tools enote:test
Fix bicycle enote:testing
Ride bike enote:testing
EOF

# Create our notes file with some content
echo -e "test note first line\ntest note second line" | gpg -e -r user@tests.com >notes/todo-test.enc
# Create our todo.txt file
cat >todo.txt <<EOF
Buy tools enote:test
Fix bicycle enote:testing
Ride bike enote:testing
EOF
# Create our notes file with some content
cp ./notes/todo-test.enc ./notes/todo-testing.enc
echo -e "test note first line\ntest note second line\ntest note third line" |
	gpg -e -r user@tests.com >notes/archive/todo-test_previous.10100000.enc
echo -e "test note first line\ntest note second line\nolder" |
	gpg -e -r user@tests.com >notes/archive/todo-testing.1010000.enc
echo -e "test note first line\ntest note second line\nyounger" |
	gpg -e -r user@tests.com >notes/archive/todo-testing.1020000.enc

test_todo_session 'enotes unarchive usage' <<EOF
>>> todo.sh enotes unarchive usage
    enotes unarchive [ENOTESFILE]
      unarchive enotes files, this brings back the last
      version of the enotefile
=== 1
EOF

test_todo_session 'enotes unarchive for note never archived' <<EOF
>>> todo.sh enotes unarchive foobar
      No archived enotes file named foobar. Use enotes listarchived to find them
    enotes unarchive [ENOTESFILE]
      unarchive enotes files, this brings back the last
      version of the enotefile
=== 1
EOF

test_todo_session 'enotes unarchive file' <<EOF
>>> todo.sh enotes unarchive testing
TODO: Encrypted notes file todo-testing.enc restored from newest archive
=== 0
EOF

test_todo_session 'enotes unarchive test restored file is younger file' <<EOF
>>> todo.sh enotes cat testing
test note first line
test note second line
younger
=== 0
EOF

test_todo_session 'enotes unarchive notefile not in todo.txt' <<EOF
>>> todo.sh enotes unarchive test_previous
      Encrypted note file test_previous not mentioned in todo
      use enotes listarchived to find them
    enotes unarchive [ENOTESFILE]
      unarchive enotes files, this brings back the last
      version of the enotefile
=== 1
EOF

# Cleanup
rm -rf "${GNUPGHOME}"

test_done

#!/bin/bash

test_description='notes actions functionality
'
. ./test-lib.sh

# Set our current actions directory
export TODO_ACTIONS_DIR=$TEST_DIRECTORY/../actions/enotes
# Set editor to cat so it tests nicely.
export EDITOR="cat"
export GNUPGHOME="$(mktemp -d)"
export GPG_USER="user@tests.com"
# Setup gpg and a key for our enotes testing
gpg --list-keys
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
EOF
gpg --batch --no-verbose -q --full-gen-key ${GNUPGHOME}/key >/dev/null 2>&1

# Create our notes and archive directories
mkdir -p notes/archive

# Create our notes file with some content
echo -e "test note first line\ntest note second line" | gpg -q -e --batch -r user@tests.com -o notes/todo-test.enc -

# Create our todo.txt file
cat > todo.txt <<EOF
Buy tools enote:test
Fix bicycle enote:testing
Ride bike enote:testing
EOF

test_todo_session 'enotesedit usage' <<EOF
>>> todo.sh enotesedit usage
    enotesedit [ENOTESFILE]
      Edit encrypted ENOTESFILE in \$EDITOR.
      Use listenotes to show all encrypted notes files.
=== 0
EOF

test_todo_session 'ene usage' <<EOF
>>> todo.sh ene usage
    enotesedit [ENOTESFILE]
      Edit encrypted ENOTESFILE in \$EDITOR.
      Use listenotes to show all encrypted notes files.
=== 0
EOF

test_todo_session 'enotesedit no enotefile' <<EOF
>>> todo.sh enotesedit
      No encryted notes file
    enotesedit [ENOTESFILE]
      Edit encrypted ENOTESFILE in \$EDITOR.
      Use listenotes to show all encrypted notes files.
=== 1
EOF

test_todo_session 'enotesedit no such enotefile' <<EOF
>>> todo.sh enotesedit note:notafile
      Encrypted notes file  not in todo.txt file,
      use listenotes to find encrypted notes files
    enotesedit [ENOTESFILE]
      Edit encrypted ENOTESFILE in \$EDITOR.
      Use listenotes to show all encrypted notes files.
=== 1
EOF

# With editor set to cat it will just print
test_todo_session 'enotesedit a enotefile' <<EOF
>>> todo.sh enotesedit enote:test
test note first line
test note second line
=== 0
EOF

# Create a badfile (not encrypted) and put in todo.txt
cat > notes/todo-badfile.enc <<EOF
badfile contents
EOF
cat >> todo.txt <<EOF
badfile line enote:badfile
EOF

test_todo_session 'enotesedit fail to decrypt' <<EOF
>>> todo.sh enotesedit enote:badfile
      Unable to decrypt todo-badfile.enc
    enotesedit [ENOTESFILE]
      Edit encrypted ENOTESFILE in \$EDITOR.
      Use listenotes to show all encrypted notes files.
=== 1
EOF

# Test for GPG_USER not in todo.cfg
unset GPG_USER

test_todo_session 'enotesedit no GPG_USER' <<EOF
>>> todo.sh enotesedit enote:test
      Please set a variable GPG_USER in your todo.cfg
    enotesedit [ENOTESFILE]
      Edit encrypted ENOTESFILE in \$EDITOR.
      Use listenotes to show all encrypted notes files.
=== 1
EOF

# Cleanup
rm -rf "${GNUPGHOME}"

test_done

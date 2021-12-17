#!/bin/bash

test_description='enotes actions functionality
'
. ./test-lib.sh

# Set our current actions directory
export TODO_ACTIONS_DIR=$TEST_DIRECTORY/../actions/enotes
# Set editor to cat so it tests nicely.

export GNUPGHOME="$(mktemp -d)" || { echo "Failed to create temp file"; exit 1; }
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
# Create our todo.txt file
cat > todo.txt <<EOF
Buy tools enote:test
Fix bicycle enote:testing
Ride bike enote:testing
EOF

# Create our notes file with some content
echo -e "test note first line\ntest note second line" | gpg -e -r user@tests.com > notes/todo-test.enc
# Create our notes and archive directories
mkdir -p notes/archive
# Create our todo.txt file
cat > todo.txt <<EOF
Buy tools enote:test
Fix bicycle enote:testing
Ride bike enote:testing
EOF
# Create our notes file with some content
cp  ./notes/todo-test.enc ./notes/todo-testing.enc 
echo -e "test note first line\ntest note second line\ntest note third line" | \
gpg -e -r user@tests.com > notes/archive/todo-test_previous.10100000.enc
echo -e "test note first line\ntest note second line\nolder" | \
gpg -e -r user@tests.com > notes/archive/todo-testing.1010000.enc
echo -e "test note first line\ntest note second line\nyounger" | \
gpg -e -r user@tests.com > notes/archive/todo-testing.1020000.enc

test_todo_session 'enotesunarchive usage' <<EOF
>>> todo.sh enotesunarchive usage
    enotesunarchive [ENOTESFILE]
      unarchive enotes files, this brings back the last
      version of the enotefile
=== 0
EOF

test_todo_session 'enuar usage' <<EOF
>>> todo.sh enuar usage
    enotesunarchive [ENOTESFILE]
      unarchive enotes files, this brings back the last
      version of the enotefile
=== 0
EOF

test_todo_session 'enotesunarchive for note never archived' <<EOF
>>> todo.sh enotesunarchive foobar
      No archived enotes file named foobar. Use listarchivedenotes to find them
    enotesunarchive [ENOTESFILE]
      unarchive enotes files, this brings back the last
      version of the enotefile
=== 1
EOF

test_todo_session 'enotesarchive unarchive file' <<EOF
>>> todo.sh enotesunarchive testing
TODO: Encrypted notes file todo-testing.enc restored from newest archive
=== 0
EOF

test_todo_session 'enotesarchive test restored file is younger file' <<EOF
>>> todo.sh enotescat testing
test note first line
test note second line
younger
=== 0
EOF

test_todo_session 'enotesunarchive notefile not in todo.txt' <<EOF
>>> todo.sh enotesunarchive test_previous
      Encrypted note file test_previous not mentioned in todo. Use listenotes to find them
    enotesunarchive [ENOTESFILE]
      unarchive enotes files, this brings back the last
      version of the enotefile
=== 1
EOF

# Cleanup
rm -rf "${GNUPGHOME}"

test_done

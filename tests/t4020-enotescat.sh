#!/bin/bash

test_description='enotes actions functionality
'
. ./test-lib.sh -i

export TODO_ACTIONS_DIR=$TEST_DIRECTORY/../actions/enotes

# Create our notes and archive directories
mkdir -p notes/archive
# Create our todo.txt file
cat > todo.txt <<EOF
Buy tools note:test
Fix bicycle note:testing
Ride bike note:testing
EOF

export GNUPGHOME="$(mktemp -d)" || { echo "Failed to create temp file"; exit 1; }
export GPG_USER="user@tests.com"
# Setup gpg and a key for our enotes testing
gpg --list-keys --no-verbose -q 1>/dev/null
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
gpg --batch --no-verbose -q --full-gen-key ${GNUPGHOME}/key

# Create our notes file with some content
echo -e "test note first line\ntest note second line" | gpg -q --no-verbose -e -r user@tests.com > notes/todo-test.enc

test_todo_session 'enotescat usage' <<EOF
>>> todo.sh enotescat usage
    enotes cat [ENOTESFILE]
      Show ENOTESFILE
=== 1
EOF

test_todo_session 'enc usage' <<EOF
>>> todo.sh enotescat usage
    enotes cat [ENOTESFILE]
      Show ENOTESFILE
=== 1
EOF

test_todo_session 'enotescat no enotes file' <<EOF
>>> todo.sh enotescat
      No encrypted notes file
    enotes cat [ENOTESFILE]
      Show ENOTESFILE
=== 1
EOF

test_todo_session 'enotescat cat enotes file' <<EOF
>>> todo.sh enotescat enote:test
test note first line
test note second line
=== 0
EOF

test_todo_session 'enotescat show no such note' <<EOF
>>> todo.sh enotescat note:notafile
      Encrypted notes file note:notafile not in todo.txt file,
      use listenotes to find encrypted notes files
    enotes cat [ENOTESFILE]
      Show ENOTESFILE
=== 1
EOF

cat >> todo.txt <<EOF
line for bad file enote:badfile
EOF
cat > notes/todo-badfile.enc <<EOF
badfile line 1
EOF

test_todo_session 'enotescat unable to decrypt' <<EOF
>>> todo.sh enotescat enote:badfile
      Unable to decrypt todo-badfile.enc
    enotes cat [ENOTESFILE]
      Show ENOTESFILE
=== 1
EOF

unset GPG_USER
test_todo_session 'enotescat no GPG_USER variable' <<EOF
>>> todo.sh enotescat note:notafile
      Please set a variable GPG_USER in your todo.cfg
    enotes cat [ENOTESFILE]
      Show ENOTESFILE
=== 1
EOF

# Cleanup
rm -rf "${GNUPGHOME}"

test_done

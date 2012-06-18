#!/usr/bin/env bash

set -o errexit
set -o pipefail

export PATH=$(cd "$(dirname "$0")"; pwd):$PATH

LOG="LOG:"

ok() {
    FAILED=
    $@ || { FAILED=1 && true ;}
    if [ -n "$FAILED" ]; then
        TEST="FAIL: $@"
        LOG="$LOG\n$TEST"
        echo $TEST
        return 1
    else
        TEST="PASS: $@"
        LOG="$LOG\n$TEST"
        echo $TEST
        return 0
    fi
}

not_ok() {
    FAILED=
    $@ || { FAILED=1 && true ;}
    if [ -z "$FAILED" ]; then
        TEST="FAIL: $@ (expected non-zero exit)"
        LOG="$LOG\n$TEST"
        echo $TEST
        return 1
    else
        TEST="PASS: $@ (expected non-zero exit)"
        LOG="$LOG\n$TEST"
        echo $TEST
        return 0
    fi
}

setup_repo() {
    git init
    touch SOME_FILE
    git add SOME_FILE
    git commit SOME_FILE -m 'initial version of SOME_FILE'
}

CHANGE=0
change_and_commit() {
    date >> $1
    CHANGE=$(( $CHANGE + 1 ))
    git commit $1 -m "change #$CHANGE"
}

tests() {
    setup_repo || return $?
    not_ok git-branchdir-delete bar || return $?
    ok git-branchdir-new bar || return $?
    ok git-branchdir-delete bar || return $?
    ok git-branchdir-new foo || return $?
    ok cd $(git-branchdir-path foo) || return $?
    ok change_and_commit SOME_FILE || return $?
    not_ok git-branchdir-delete foo || return $?
    ok git-branchdir-publish foo master || return $?
    ok touch SOME_OTHER_FILE
    not_ok git-branchdir-delete foo || return $?
    ok rm -f SOME_OTHER_FILE
    ok git-branchdir-delete foo || return $?
    ok cd -
}

TMP_DIR=$(mktemp -d -t /tmp)
trap "rm -rf $TMP_DIR" EXIT
cd $TMP_DIR
tests
echo -e $LOG

#!/usr/bin/env bash

set -o errexit
set -o pipefail

export PATH=$(cd "$(dirname "$0")"; pwd):$PATH

ok() {
    FAILED=
    $@ || { FAILED=1 && true ;}
    if [ -n "$FAILED" ]; then
        TEST="FAIL: $@"
        echo $TEST
        return 1
    else
        TEST="PASS: $@"
        echo $TEST
        return 0
    fi
}

not_ok() {
    FAILED=
    $@ || { FAILED=1 && true ;}
    if [ -z "$FAILED" ]; then
        TEST="FAIL: $@ (expected non-zero exit)"
        echo $TEST
        return 1
    else
        TEST="PASS: $@ (expected non-zero exit)"
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

announce_test() {
    echo "/******************************************\\"
    echo "TEST: $@"
    echo "\\******************************************/"
}

tests() {
    BASE_DIR=$(pwd)
    setup_repo

    announce_test "Test publish (and merge)."
    ok git-branchdir-new some_feature
    ok cd $(git-branchdir-path some_feature)
    ok change_and_commit SOME_FILE
    git-branchdir-publish some_feature master || true # merge seems to exit 1 even on success? 

    announce_test "Test deletion."
    ok git-branchdir-new delete_me
    ok git-branchdir-delete delete_me

    announce_test "Test deletion of non-existant branchdir."
    not_ok git-branchdir-delete i-dont-exist

    announce_test "Test delete with unmerged changes."
    ok git-branchdir-new unmerged-changes master
    ok cd $(git-branchdir-path unmerged-changes)
    ok change_and_commit SOME_FILE
    not_ok git-branchdir-delete unmerged-changes
    ok git reset --hard HEAD^
    ok git-branchdir-delete unmerged-changes
    ok cd "$BASE_DIR"

    announce_test "Test delete with changes."
    ok git-branchdir-new changes master
    ok cd $(git-branchdir-path changes)
    echo $(date) >> SOME_FILE
    not_ok git-branchdir-delete changes
    ok git reset --hard HEAD^
    ok git-branchdir-delete changes
    ok cd "$BASE_DIR"

    announce_test "Test delete with untracked changes."
    ok git-branchdir-new untracked-changes master
    ok cd $(git-branchdir-path untracked-changes)
    ok touch SOME_OTHER_FILE
    not_ok git-branchdir-delete untracked-changes
    ok rm -f SOME_OTHER_FILE
    ok git-branchdir-delete untracked-changes
    ok cd "$BASE_DIR"

    announce_test "Test move."
    ok git-branchdir-new rename-me
    ok cd $(git-branchdir-path rename-me)
    ok git-branchdir-move rename-me awesome
    ok cd $(git-branchdir-path awesome)
    ok change_and_commit SOME_FILE # To make sure index is in good state.
    ok cd $BASE_DIR
}

TMP_DIR=$(mktemp -d -t /tmp)
trap "rm -rf $TMP_DIR" EXIT
cd $TMP_DIR
tests

gcd_complete() {
    COMPREPLY=()
    if [ ${#COMP_WORDS[@]} -eq 2 ]; then
        local cur=${COMP_WORDS[COMP_CWORD]}
        COMPREPLY=($(compgen -W "master $(git config --get-all branchdir.branch)" -- $cur))
    fi
}
complete -F gcd_complete gcd

branchdir_basedir() {
    git config branchdir.base
}

branchdir_path() {
    branchname="$1"
    if [ "$branchname" == "master" ]; then
        echo "$(branchdir_basedir)"
    else
        echo "$(branchdir_basedir)-${branchname//\//-}"
    fi
}

gcd() {
    if [ $# -eq 0 ]; then
        cd "$(branchdir_basedir)"
    else
        cd "$(branchdir_path $1)"
    fi
}

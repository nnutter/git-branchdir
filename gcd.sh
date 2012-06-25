gcd_complete() {
    COMPREPLY=()
    if [ ${#COMP_WORDS[@]} -eq 2 ]; then
        local cur=${COMP_WORDS[COMP_CWORD]}
        COMPREPLY=($(compgen -W "master $(git config --get-all branchdir.branch)" -- $cur))
    fi
}
complete -F gcd_complete gcd

gcd() {
    source "$(git --exec-path)/git-branchdir-common"
    if [ $# -eq 0 ]; then
        cd "$(branchdir_basedir)"
    else
        cd "$(branchdir_path $1)"
    fi
}

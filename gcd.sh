gcd_complete() {
    COMPREPLY=()
    local cur=${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=($(compgen -W "$(git config --get-all branchdir.branch)" -- $cur))
}
complete -F gcd_complete gcd

gcd_branchdir_path() {
    branchname="$1"
    echo "$(branchdir_basedir)-${branchname//\//-}"
}

gcd() {
    if [ $# -eq 0 ]; then
        cd $(git config branchdir.base)
    else
        cd "$(gcd_branchdir_path $1)"
    fi
}

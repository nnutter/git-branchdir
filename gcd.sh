gcd_complete() {
    COMPREPLY=()
    local cur=${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=($(compgen -W "$(git config --get-all branchdir.branch)" -- $cur))
}
complete -F gcd_complete gcd

gcd() {
    if [ $# -eq 0 ]; then
        cd $(git config branchdir.base)
    else
        cd "$(git config branchdir.base)-$1"
    fi
}

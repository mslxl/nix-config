
_sudo_path="$(which sudo)"
function _sudo(){
    if [[ "$#" -eq "0" ]] ; then
        return
    fi
    echo -n "Grant root permission for \"$*\"? [y/N]"
    if read -q ; then
        echo "\nPermitted!"
        $_sudo_path $*
    else
        echo "Deny"
    fi
}

alias sudo="_sudo"

function load-func(){
    readonly prefix="$HOME/mulscript"
    readonly filename="$1"
    if [[ ! -d "$prefix" ]]; then
        mkdir "$prefix"
    fi
    if [[ -f "$prefix/$filename" ]]; then
        echo "Create alias for $filename"
        alias "$filename"="\"$prefix/$filename\""
        chmod a+x "$prefix/$filename"
    elif [[ -f "$prefix/$filename.sh" ]]; then
        echo "Create alias for $filename.sh"
        alias "$filename"="\"$prefix/$filename.sh\""
        chmod a+x "$prefix/$filename.sh"
    elif [[ -f "$prefix/$filename.zsh" ]]; then
        echo "Create alias for $filename.zsh"
        alias "$filename"="\"$prefix/$filename.zsh\""
        chmod a+x "$prefix/$filename.zsh"
    elif [[ -f "$prefix/$filename.sc" ]]; then
        echo "Create alias for $filename.sc"
        alias "$filename"="amm \"$prefix/$filename.sc\""
    elif [[ -f "$prefix/$filename.scala" ]]; then
        echo "Create alias for $filename.scala"
        alias "$filename"="amm \"$prefix/$filename.scala\""
    elif [[ -f "$prefix/$filename.py" ]]; then
        echo "Create alias for $filename.py"
        alias "$filename"="amm \"$prefix/$filename.py\""
    fi

}

#!/bin/bash

echo "Check yadm remote url..."
github_ssh_url="git@github.com:mslxl/.dotfile.git"
yadm_url=$(yadm remote get-url origin 2>&1)
if [[ "$?" != "0" ]]; then
    echo "Add remote url to $github_ssh_url"
    yadm remote add origin $github_ssh_url
elif [[ "$yadm_url" != "$github_ssh_url" ]]; then
    echo "Set remote url to $github_ssh_url"
    yadm remote set-url origin $github_ssh_url
fi

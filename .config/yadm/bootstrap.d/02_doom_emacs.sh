#!/bin/bash

hash emacs 2>/dev/null && {
	if [[ -d "$HOME/.emacs.d" ]]; then
		echo "Directory .emacs.d already exists, skipped"
	else
    		git clone --depth 1 https://github.com/hlissner/doom-emacs ~/.emacs.d 
		$HOME/.emacs.d/bin/doom install
	fi
} || {
	echo "Emacs is not installed"

}


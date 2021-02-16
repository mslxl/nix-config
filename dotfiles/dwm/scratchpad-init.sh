#!/bin/zsh

name=scratchpad
tmux has-session -t "$name"
if (( $? == 0 )){
    tmux attach -t "$name"
} else {
    tmux new-session -s "$name"
}

#! /usr/bin/env bash

if [ -t 0 ]; then
    # stdin is a tty: process command line
    cat $1 | xclip -sel c
else
    # stdin is not a tty: process standard input
    cat "$@" | xclip -sel c
fi

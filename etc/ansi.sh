#!/usr/bin/env sh

TTY=`stty -g`    # save tty settings

uxnasm etc/ansi.tal etc/ansi.rom

stty raw -echo    # non canonical mode and no echo

uxncli etc/ansi.rom

stty $TTY    # restore tty settings

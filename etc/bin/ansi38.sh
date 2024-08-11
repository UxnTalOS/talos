#!/usr/bin/env sh

TTY=`stty -g`    # save tty settings

uxnasm etc/ansi.tal etc/ansi.rom

stty raw -echo    # non canonical mode and no echo

uxn38 -n etc/ansi.rom

stty $TTY    # restore tty settings

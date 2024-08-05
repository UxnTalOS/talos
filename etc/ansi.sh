#!/usr/bin/env sh

TTY=`stty -g`    # save tty settings

uxnasm etc/ansi.tal etc/ansi.rom

stty -ignbrk -brkint -ignpar -parmrk -inpck -istrip -inlcr -igncr -icrnl -ixon \
     -ixoff -icanon onlcr -echo -isig -iuclc -ixany -imaxbel -xcase min 1 time 0

echo "\x1b[?2004h" && uxncli etc/ansi.rom

stty $TTY    # restore tty settings

#!/usr/bin/env sh

STTY=`stty -g`    # save tty settings

uxnasm tac-toe-tic.tal tac-toe-tic.rom

stty -ignbrk -brkint -ignpar -parmrk -inpck -istrip -inlcr -igncr -icrnl -ixon \
     -ixoff -icanon onlcr -echo -isig -iuclc -ixany -imaxbel -xcase min 1 time 0

uxncli tac-toe-tic.rom

# Exit
EXIT=`echo $?`
stty $STTY
exit $EXIT



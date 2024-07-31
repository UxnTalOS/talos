#!/usr/bin/env sh

STTY=`stty -g`

# Build
cd src
../etc/uxnasm merlin/includes.tal ../rom/merlin.rom $@ || exit 127
cd ..

# Run
stty raw -echo
uxncli rom/merlin.rom || EXIT=`echo $?`

# Exit
stty $STTY
exit $EXIT

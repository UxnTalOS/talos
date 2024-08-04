#!/usr/bin/env sh

STTY=`stty -g`

# Build
cd src
../etc/uxnasm talos/includes.tal ../rom/talos.rom || exit 127
cd ..

# Run
stty raw -echo
uxncli rom/talos.rom || EXIT=`echo $?`

# Exit
stty $STTY
exit $EXIT

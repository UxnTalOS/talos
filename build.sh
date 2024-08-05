#!/usr/bin/env sh

# Start
STTY=`stty -g`


# Pre-process
if [ "$1" = "DEBUG" ]; then
	DEBUG="DBG"
else
	DEBUG="NO_DBG"
fi

cpp -P -D $DEBUG config/pre-options.tal -o config/options.tal
cpp -P -D $DEBUG src/debugger/routines/pre-after-eval.tal \
-o src/debugger/routines/after-eval.tal
cpp -P -D $DEBUG src/debugger/routines/pre-before-eval.tal \
-o src/debugger/routines/before-eval.tal


# Build
mkdir -p rom

cd src
../etc/uxnasm talos/includes.tal ../rom/talos.rom || exit 127
cd ..


# Run
stty raw -echo
uxncli rom/talos.rom
EXIT=`echo $?`


# Exit
stty $STTY
exit $EXIT

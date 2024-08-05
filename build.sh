#!/usr/bin/env sh

# Start
STTY=`stty -g`


# Pre-process
if [ "$1" = "--debug" ]; then
	DEBUG="DBG"
else
	DEBUG="NO_DBG"
fi

cpp -P -w -D $DEBUG config/pre-options.tal -o config/options.tal
cpp -P -w -D $DEBUG src/debugger/routines/pre-after-eval.tal \
-o src/debugger/routines/after-eval.tal
cpp -P -w -D $DEBUG src/debugger/routines/pre-before-eval.tal \
-o src/debugger/routines/before-eval.tal


# Build
mkdir -p rom

cd src
../etc/uxnasm talos/includes.tal ../rom/talos.rom || exit 127
cd ..

# Install
if [ "$1" = "--install" ]; then
	echo "Installing ./{bin,rom} at ~/{bin,roms}"
	cp bin/* ~/bin
	cp rom/talos.rom ~/roms
fi


# Run
stty -ignbrk -brkint -ignpar -parmrk -inpck -istrip -inlcr -igncr -icrnl -ixon \
     -ixoff -icanon onlcr -echo -isig -iuclc -ixany -imaxbel -xcase min 1 time 0
uxn38 -n rom/talos.rom
EXIT=`echo $?`


# Exit
stty $STTY
exit $EXIT

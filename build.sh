#!/usr/bin/env sh

# Start
STTY=`stty -g`

if [ "$1" = "--uxn38" ]; then
	EMU='uxn38 -n'
elif [ "$1" = "--uxn38-gui" ]; then
	EMU='uxn38 -I'
elif [ "$1" = "--uxn11" ]; then
	EMU=uxn11
elif [ "$1" = "--uxnemu" ]; then
	EMU=uxnemu
elif [ "$1" = "--raven" ]; then
	EMU=raven-cli
elif [ "$1" = "--raven-gui" ]; then
	EMU=raven-gui
else
	EMU=uxncli
fi


# Pre-process
if [ "$1" = "--debug" ]; then
	DEBUG="DBG"
else
	DEBUG="NO_DBG"
fi

# Sorry
cpp -P -w -D $DEBUG config/pre-options.tal -o config/options.tal
cpp -P -w -D $DEBUG src/debugger/routines/pre-after-eval.tal \
-o src/debugger/routines/after-eval.tal
cpp -P -w -D $DEBUG src/debugger/routines/pre-before-eval.tal \
-o src/debugger/routines/before-eval.tal


# Build
mkdir -p rom

cd src
uxnasm talos/includes.tal ../rom/talos.rom || exit 127
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
$EMU rom/talos.rom
EXIT=`echo $?`


# Exit
stty $STTY
exit $EXIT

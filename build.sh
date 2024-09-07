#!/usr/bin/env sh

OS_TYPE=$(uname)
ROM=rom/talos.rom

# Start
# Save TTY settings.
STTY=`stty -g`

# Select emulator.
if [ -z "$EMU" ]; then
	for arg in "$@"; do
    	case "$arg" in
			"--uxn38-cli")
				EMU="uxn38 -n"
				;;
			"--uxn38-gui")
				EMU="uxn38 -I"
				;;
			"--uxn11")
				EMU="uxn11"
				;;
			"--raven-cli")
				EMU="raven-cli"
				;;
			"--raven-gui")
				EMU="raven-gui"
				;;
			"--uxnemu")
				EMU="uxnemu"
				;;
			"--uxncli")
				EMU="uxncli"
				;;
			"--uxntui")
				EMU="uxntui"
				;;
		esac
	done
fi

if [ -z "$EMU" ]; then
	EMU="uxntui"
fi

EMU_PATH=$(which "$EMU" 2>/dev/null)

if [ -z "$EMU_PATH" ]; then
    echo "Error: '$EMU' not found in PATH."
    exit 1
fi

# Pre-process
if [ "$1" = "--debug" ]; then
	echo "Debugging Enabled."
	DEBUG="DBG"
else
	echo "Debugging Disabled."
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

# Select assembler.
if [ -z "$ASM" ]; then
	for arg in "$@"; do
    	case "$arg" in
    		"--drifblim")
    			ASM="uxncli ~/roms/drifblim.rom"
    			;;
    		"--uxnasm")
    			ASM="uxnasm"
    			;;
    	esac
    done
fi

if [ -z "$ASM" ]; then
	ASM="uxnasm"
fi

ASM_PATH=$(which "$ASM" 2>/dev/null)

if [ -z "$ASM_PATH" ]; then
    echo "Error: '$ASM' not found in PATH."
    exit 1
fi

echo "Using assembler: $ASM_PATH"

cd src
$ASM talos/includes.tal ../rom/talos.rom || exit 127
cd ..

# Install
if [ "$1" = "--install" ]; then
	echo "Installing ./{bin,rom} at ~/{bin,roms}"
	cp bin/* ~/bin
	cp rom/talos.rom ~/roms
fi

# Run
	HOST=`uname -a`
	echo "Host: $HOST"
if echo "$OS_TYPE" | grep -qi "mingw"; then
	# Does not support -xcase
	stty -ignbrk -brkint -ignpar -parmrk -inpck -istrip -inlcr -igncr -icrnl \
	-ixon -ixoff -icanon onlcr -echo -isig -iuclc -ixany -imaxbel min 1 time 0
else
	stty -ignbrk -brkint -ignpar -parmrk -inpck -istrip -inlcr -igncr -icrnl   \
	-ixon -ixoff -icanon onlcr -echo -isig -iuclc -ixany -imaxbel -xcase min 1 \
	time 0
fi

echo "Using emulator: $EMU_PATH"
$EMU $ROM
EXIT=`echo $?`
echo "Exit Code: $EXIT"


# Exit
# Restore TTY settings.
stty $STTY
exit $EXIT

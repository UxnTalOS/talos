#!/usr/bin/env sh

OS_TYPE=$(uname)
ROM=rom/talos.rom
echo "Host: $OS_TYPE"

# Portable find-in-PATH function (replaces 'which')
find_in_path() {
    cmd="$1"
    old_ifs="$IFS"
    IFS=:
    for dir in $PATH; do
        if [ -x "$dir/$cmd" ]; then
            printf '%s\n' "$dir/$cmd"
            break
        fi
    done
    IFS="$old_ifs"
}

# Start
# Save TTY settings.
STTY=$(stty -g)

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
	EMU="uxncli"
fi

EMU_PATH=$(find_in_path "$EMU")

if [ -z "$EMU_PATH" ]; then
    echo "Error: '$EMU' not found in PATH."
    exit 1
fi

# Pre-process
for arg in "$@"; do
   	case "$arg" in
		"--debug")
			echo "Debugging enabled."
			DEBUG="DBG"
			;;
	esac
done

if [ -z "$DEBUG" ]; then
	DEBUG="NO_DBG"
fi

jinja2 --format yaml config/options.tal.tpl \
	-o config/options.tal config.yaml
jinja2 --format yaml src/repl/routines.tal.tpl \
	-o src/repl/routines.tal config.yaml
jinja2 --format yaml src/debugger/routines/after-eval.tal.tpl \
	-o src/debugger/routines/after-eval.tal config.yaml
jinja2 --format yaml src/debugger/routines/before-eval.tal.tpl \
	-o src/debugger/routines/before-eval.tal config.yaml
jinja2 --format yaml src/repl/data.tal.tpl \
	-o src/repl/data.tal config.yaml
jinja2 --format yaml src/talos/main.tal.tpl \
	-o src/talos/main.tal config.yaml
jinja2 --format yaml src/talos/macros.tal.tpl \
	-o src/talos/macros.tal config.yaml

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

ASM_PATH=$(find_in_path "$ASM")

if [ -z "$ASM_PATH" ]; then
    echo "Error: '$ASM' not found in PATH."
    exit 1
fi

echo "Using assembler: $ASM_PATH"

cd src
$ASM talos/includes.tal ../rom/talos.rom || exit 127
cd ..

# Install
for arg in "$@"; do
   	case "$arg" in
		"--install")
			echo "Installing ./{bin,rom} at ~/{.local/bin,roms}"
			mkdir -p ~/roms
			cp bin/* ~/.local/bin
			cp rom/talos.rom ~/roms
			;;
	esac
done

# Run
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
EXIT=$?
echo "Exit code: $EXIT"

# Exit
# Restore TTY settings.
stty "$STTY"
exit "$EXIT"

ID=talos
ENTRY=includes
ASM=uxnasm
EMU=uxncli

BAK_DIR=bak
ETC_DIR=etc
SRC_DIR=src
BIN_DIR=bin
ROM_DIR=rom
ROMS_DIR=roms

TAL=${ID}/${ENTRY}.tal
ROM=${ROM_DIR}/${ID}.rom
SYM=${ROM}.sym

DIS=${ETC_DIR}/uxndis.rom
SYMS=${ETC_DIR}/sym.rom
DUMP=${ETC_DIR}/hx.rom

TTY := $(shell stty -g)

run: install
	@ stty raw -echo
	@ echo "Running: ~/${BIN_DIR}/${ID}"
	@ ${ID}; \
	EXIT_CODE=$$? ; \
	stty ${TTY}; \
	exit $$EXIT_CODE

setup:
	@ echo "Setting up: ~/{${BIN_DIR},${ROMS_DIR}}"
	@ mkdir -p ~/${BIN_DIR} ~/${ROMS_DIR}

build: ${ROM}
	@ echo "Building: ./${ROM}*"
	@ cd ${SRC_DIR} && ${ASM} ${TAL} ../${ROM}

dump: build
	@ echo "Dumping: ./${ROM}.dmp"
	@ ${EMU} ${DUMP} ${ROM} 2> /dev/null > ${ROM}.dmp

symbols: build
	@ echo "Reading symbols: ./${SYM}.txt"
	@ ${EMU} ${SYMS} ${SYM} > ${SYM}.txt 2>&1

disassemble: build
	@ echo "Disassembling: ./${ROM}.dis"
	@ ${EMU} ${DIS} ${ROM} > ${ROM}.dis

install: setup build dump symbols disassemble
	@ echo "Installing: ./{${BIN_DIR},${ROM_DIR}}/* at ~/{${BIN_DIR},${ROMS_DIR}}"
	@ cp ${BIN_DIR}/* ~/${BIN_DIR}
	@ cp ${ROM} ~/${ROMS_DIR}

test: install
	@ echo "Testing: ~/${ROM_DIR}/${ID}.rom"
	@ echo "~test/routines.tal\nsierpinski\nbye" | ${EMU} ${ROM_DIR}/${ID}.rom

cli: install
	@ echo "Running: ~/${BIN_DIR}/${ID}-cli"
	@ stty raw -echo
	@ ${ID}-cli; \
	EXIT_CODE=$$? ; \
	stty ${TTY}; \
	exit $$EXIT_CODE

gui: install
	@ echo "Running: ~/${BIN_DIR}/${ID}-gui"
	@ stty raw -echo
	@ ${ID}-gui; \
	EXIT_CODE=$$? ; \
	stty ${TTY}; \
	exit $$EXIT_CODE

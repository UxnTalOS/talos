ID=merlin
ENTRY=includes
ASM=uxnasm
EMU=uxncli

BAK_DIR=bak
SRC_DIR=src
BIN_DIR=bin
ROM_DIR=rom
ROMS_DIR=roms

TAL=${ID}/${ENTRY}.tal
ROM=${ROM_DIR}/${ID}.rom
SYM=${ROM}.sym

DIS=etc/uxndis.rom
SYMS=etc/sym.rom
DUMP=etc/hx.rom

run: install
	@ echo "Running: ~/${BIN_DIR}/${ID}"
	@ ${ID}

backup:
	@ echo "Backing: ./{${BIN_DIR},${ROM_DIR}}/* to ./${BAK_DIR}"
	@ cp ${BIN_DIR}/* ${BAK_DIR}
	@ cp ${ROM_DIR}/* ${BAK_DIR}

build: backup ${ROM}
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

install: backup build dump symbols disassemble
	@ echo "Installing: ./{${BIN_DIR},${ROM_DIR}}/* at ~/{${BIN_DIR},${ROMS_DIR}}"
	@ cp ${BIN_DIR}/* ~/${BIN_DIR}
	@ cp ${ROM_DIR}/* ~/${ROMS_DIR}

cli: install
	@ echo "Running: ~/${BIN_DIR}/${ID}-cli"
	@ ${ID}-cli

gui: install
	@ echo "Running: ~/${BIN_DIR}/${ID}-gui"
	@ ${ID}-gui

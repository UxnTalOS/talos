#!/usr/bin/env sh

set -o nounset # Fails when accessing an unset variable.
set -o errexit # Exits if a command exits with a non-zero status.

TTY=`stty -g`

cd src && \
../etc/uxnasm merlin/includes.tal ../rom/merlin.rom $@ && \
cd .. && \

stty raw -echo
etc/uxncli rom/merlin.rom
stty $TTY

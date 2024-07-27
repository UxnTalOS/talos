#!/usr/bin/env sh

set -o nounset # Fails when accessing an unset variable.
set -o errexit # Exits if a command exits with a non-zero status.

STTY=`stty -g`

cd src && \
../etc/uxnasm merlin/includes.tal ../rom/merlin.rom $@ && \
cd .. && \

stty raw -echo
uxncli rom/merlin.rom
stty $STTY

#!/usr/bin/env bash

DATA_DIR="$HOME/docker-data/pi-hole"

mkdir -p "${DATA_DIR}"
mkdir -p "${DATA_DIR}/etc-pihole"
mkdir -p "${DATA_DIR}/etc-dnsmasqd"

if [ ! -f "${DATA_DIR}/pihole.log" ]; then
  touch "${DATA_DIR}/pihole.log"
fi

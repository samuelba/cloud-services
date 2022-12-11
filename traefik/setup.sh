#!/usr/bin/env bash

CONF_DIR="$HOME/docker-data/traefik/conf"
TMP_DIR="$HOME/docker-data/traefik/data/tmp"

mkdir -p "${CONF_DIR}"
mkdir -p "${TMP_DIR}"

ACME_FILE="${CONF_DIR}/acme.json"
if [[ ! -f "${ACME_FILE}" ]]; then
  touch "${ACME_FILE}" && chmod 600 "${ACME_FILE}"
fi

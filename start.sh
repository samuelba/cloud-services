#!/usr/bin/env bash

declare -a SERVICES=(
  "watchtower"
  "traefik"
  "portainer"
  "nextcloud"
  "bitwarden"
)

for service in "${SERVICES[@]}"; do
  (
  echo -e "Start ${service}"
  cd "${service}" || exit
  ./start.sh
  )
done

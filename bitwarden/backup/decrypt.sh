#!/usr/bin/env bash

ARCHIVE=$1

openssl enc -d -aes256 -salt -pbkdf2 -in "${ARCHIVE}" | tar xz -C .

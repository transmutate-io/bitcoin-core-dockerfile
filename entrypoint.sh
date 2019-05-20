#!/bin/sh
set -e

# default is to call bitcoind withoud args or with the provided args
if [ "$1" = "" ] || [ "$(echo $1|cut -b 1)" = "-" ]; then
  set -- bitcoind "$@"
fi

if [ "$1" = "bitcoind" ] || [ "$1" = "bitcoin-cli" ] || [ "$1" = "bitcoin-tx" ]; then
  # run bitcoind, bitcoin-cli and bitcoin-tx as user bitcoin
  exec gosu bitcoin "$@"
else
  # run all other commands as root
  exec "$@"
fi

#!/bin/sh
set -e

qb-tracker-updater -v

exec "$@"

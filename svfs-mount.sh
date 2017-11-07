#!/usr/bin/env sh

# sync and unmount on shutdown
trap cleanup SIGHUP SIGINT SIGQUIT SIGABRT SIGTERM
cleanup()
{
  echo "Caught signal... cleaning up."
  sync
  umount -v -l /ovh
  echo "Done cleanup... quitting."
  exit 0
}

# & wait "$!" is mandatory for this script to receive SIGTERM and other signals
svfs mount --default-uid ${UID:-1000} --default-gid ${GID:-1000} --default-mode ${MODE:-0755} ${ARGS} --device ovh --mountpoint /ovh & PID="$!"
echo "Device mounted..."
wait "$PID"

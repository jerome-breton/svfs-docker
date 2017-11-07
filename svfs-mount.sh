#!/bin/sh

svfs mount --debug --default-uid ${UID:-1000} --default-gid ${GID:-1000}  --default-mode ${MODE:-0755} --os-connect-timeout=${CONNECT_TIMEOUT:-15s} --os-segment-size=${SEGMENT_SIZE:-256} --allow-other --device hubic --mountpoint /ovh

#!/bin/sh

svfs mount --debug --default-uid ${UID:-1000} --default-gid ${GID:-1000}  --default-mode ${MODE:-0755} --allow-other --device hubic --mountpoint /ovh

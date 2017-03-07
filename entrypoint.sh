#!/bin/bash

if [ -z "$1" ]; then
    /bin/start-web.sh
else
    exec "$@"
fi

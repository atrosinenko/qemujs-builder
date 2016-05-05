#!/bin/bash

. "$STUBDIR/opts.sh"

export CFLAGS="-Wno-format-nonliteral -Wno-format-security $OPTS"
echo "CFLAGS = $CFLAGS"
exec $*

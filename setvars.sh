#!/bin/bash

. "$STUBDIR/opts.sh"

export CFLAGS="-Wno-format-nonliteral -Wno-format-security $OPTS"
export CXXFLAGS=$CFLAGS
echo "CFLAGS = $CFLAGS"
exec $*

#!/bin/bash

export CFLAGS="-m32 -Wno-format-nonliteral -Wno-format-security"
exec $*

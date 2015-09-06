#!/bin/bash -e

setvars='./eval_and_run "export CFLAGS=-m32"'

emmake make

pushd ../build/
git clone git@bitbucket.org:atrosinenko/libffi.git
cd libffi
emconfigure $setvars ./configure --host=emscripten-unknown-linux
emmake make
popd



pushd ../build/
test -d zlib-1.2.8 || wget http://zlib.net/zlib-1.2.8.tar.gz
test -d zlib-1.2.8 || tar -axf zlib-1.2.8.tar.gz
cd zlib-1.2.8
emconfigure $setvars ./configure
emmake make
popd



pushd ../build/
test -d gettext-0.19.5.1 || wget http://ftp.gnu.org/pub/gnu/gettext/gettext-0.19.tar.gz
test -d gettext-0.19.5.1 || tar -axf gettext-0.19.tar.gz
cd gettext/gettext-runtime-0.19.5.1
emconfigure $setvars ./configure  --disable-java --disable-native-java --disable-threads --disable-acl --disable-openmp --disable-curses
emmake make
popd



pushd ../build/
git clone git@bitbucket.org:atrosinenko/glib.git
cd glib
curdir=$(pwd)

export ZLIB_CFLAGS=-I${curdir}/../../zlib-1.2.8
export ZLIB_LIBS=-lz

export LIBFFI_CFLAGS=-I${curdir}/../../libffi/emscripten-unknown-linux-gnu/include
export LIBFFI_LIBS=-lffi

#export CFLAGS="-I../nongit/gettext-0.19.5.1/gettext-runtime/intl/ -v"
export LIBS="-L${curdir}/../../gettext-0.19.5.1/gettext-runtime/intl/.libs/ -L${curdir}/../../stub/"
emconfigure $setvars ./configure
emmake make
popd



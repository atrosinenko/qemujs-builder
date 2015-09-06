#!/bin/bash -e

setvars=../../stub/setvars.sh

emmake make

pushd ../build/
test -d libffi || git clone git@bitbucket.org:atrosinenko/libffi.git
cd libffi
git checkout emscripten
test -f configure || ./autogen.sh
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
test -d gettext-0.19 || wget http://ftp.gnu.org/pub/gnu/gettext/gettext-0.19.tar.gz
test -d gettext-0.19 || tar -axf gettext-0.19.tar.gz
cd gettext-0.19/gettext-runtime
emconfigure ../$setvars ./configure  --disable-java --disable-native-java --disable-threads --disable-acl --disable-openmp --disable-curses
emmake make
popd



pushd ../build/
test -d glib || git clone git@bitbucket.org:atrosinenko/glib.git
cd glib

curdir=$(pwd)
export ZLIB_CFLAGS=-I${curdir}/../zlib-1.2.8
export ZLIB_LIBS=-lz
export LIBFFI_CFLAGS=-I${curdir}/../libffi/emscripten-unknown-linux-gnu/include
export LIBFFI_LIBS=-lffi
#export CFLAGS="-I../nongit/gettext-0.19.5.1/gettext-runtime/intl/ -v"
export LIBS="-L${curdir}/../gettext-0.19/gettext-runtime/intl/.libs/ -L${curdir}/../../stub/"

test -f ./configure || emconfigure $setvars ./autogen.sh
emconfigure $setvars ./configure
emmake make
popd



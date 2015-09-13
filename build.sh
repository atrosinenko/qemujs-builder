#!/bin/bash -e

setvars=../../stub/setvars.sh

function build_libffi()
{
    test -f libffi.built && return
    test -d libffi || git clone git@bitbucket.org:atrosinenko/libffi.git
    pushd libffi
    git checkout emscripten
    test -f configure || ./autogen.sh
    emconfigure $setvars ./configure --host=emscripten-unknown-linux
    emmake make
    popd
    touch libffi.built
}

function build_zlib()
{
    test -f zlib.built && return
    test -d zlib-1.2.8 || wget http://zlib.net/zlib-1.2.8.tar.gz
    test -d zlib-1.2.8 || tar -axf zlib-1.2.8.tar.gz
    pushd zlib-1.2.8
    emconfigure $setvars ./configure
    emmake make
    popd
    touch zlib.built
}

function build_gettext()
{
    test -f gettext.built && return
    test -d gettext-0.19 || wget http://ftp.gnu.org/pub/gnu/gettext/gettext-0.19.tar.gz
    test -d gettext-0.19 || tar -axf gettext-0.19.tar.gz
    pushd gettext-0.19/gettext-runtime
    emconfigure ../$setvars ./configure  --disable-java --disable-native-java --disable-threads --disable-acl --disable-openmp --disable-curses
    emmake make
    popd
    touch gettext.built
}

function build_glib()
{
    test -f glib.built && return
    test -d glib || git clone git@bitbucket.org:atrosinenko/glib.git
    pushd glib

    curdir=$(pwd)
    export ZLIB_CFLAGS=-I${curdir}/../zlib-1.2.8
    export ZLIB_LIBS=-lz
    export LIBFFI_CFLAGS=-I${curdir}/../libffi/emscripten-unknown-linux-gnu/include
    export LIBFFI_LIBS=-lffi
    #export CFLAGS="-I../nongit/gettext-0.19.5.1/gettext-runtime/intl/ -v"
    export LIBS="-L${curdir}/../gettext-0.19/gettext-runtime/intl/.libs/ -L${curdir}/../../stub/"
    
    test -f ./configure || NOCONFIGURE=1 $setvars ./autogen.sh
    emconfigure $setvars ./configure --disable-always-build-tests
    emmake make || true # Work around for trying to run tests that are non-executable
    popd
    touch glib.built
}




emmake make

mkdir -p ../build
cd ../build
build_libffi
build_zlib
build_gettext
build_glib

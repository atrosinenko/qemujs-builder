#!/bin/bash

GUEST_ARCH="i386 mips arm"

function target_list() {
  for target in $GUEST_ARCH
  do
    echo -ne "${target}-softmmu "
  done
}

function prepare_helpers() {
  make config-host.h
  for target in $GUEST_ARCH
  do
    echo "#include \"../include/exec/helper-head.h\"" > hlp.h
    echo "#include \"../target-$target/helper.h\"" >> hlp.h
    echo "#include \"../tcg/tcg-runtime.h\"" >> hlp.h
    cat hlp.h | cpp -I ../include/ -I . | sed -r 's/(DEF_HELPER)/\n\1/g' | ../../stub/gen_helper_wrappers.py > ../target-$target/wrappers.h
  done
}

pushd ..

export STUBDIR=$(pwd)/../stub/
. ../stub/opts.sh

if [ $BUILDTYPE != "native" ]
then
    echo Using SDL
    SDL_OPTS="-s USE_SDL=2"
fi

EXTRA_CFLAGS="$SDL_OPTS -D__thread= -U__linux__ -U__i386__ -U__x86_64__ -include $(pwd)/../$DIRNAME/stub/macros.h -DNOTHREAD -I$(pwd)/../$DIRNAME/libffi/emscripten-unknown-linux-gnu/include/ -I$(pwd)/../$DIRNAME/zlib-1.2.8/ -I$(pwd)/../$DIRNAME/glib/glib/ -I$(pwd)/../$DIRNAME/glib/ -I$(pwd)/../$DIRNAME/pixman-0.32.6/pixman/ -Wno-warn-absolute-paths $OPTS"
EXTRA_LDFLAGS="$SDL_OPTS -DNOTHREAD -L$(pwd)/../$DIRNAME/libffi/emscripten-unknown-linux-gnu/.libs/ -L$(pwd)/../$DIRNAME/zlib-1.2.8/ -L$(pwd)/../$DIRNAME/glib/glib/.libs/ -L$(pwd)/../$DIRNAME/glib/gthread/.libs/ -L$(pwd)/../$DIRNAME/pixman-0.32.6/pixman/.libs/ -L$(pwd)/../$DIRNAME/stub $OPTS"

export PKG_CONFIG_PATH="$(pwd)/../$DIRNAME/glib:$(pwd)/../$DIRNAME/pixman-0.32.6/"

popd



../configure \
  --target-list="$(target_list)" --disable-werror --enable-tcg-interpreter \
  --extra-cflags="$EXTRA_CFLAGS" \
  --extra-ldflags="$EXTRA_LDFLAGS" \
  --enable-sdl \
  --with-sdlabi=2.0 \
  --audio-drv-list=sdl \
  --disable-slirp \
  --disable-user \
  --disable-docs \
  --disable-guest-agent \
  --disable-vhost-net \
  --disable-vnc \
  --disable-kvm \
  --disable-tpm \
  $*

if [ $BUILDTYPE != "native" ]
then
    sed --in-place -r -e '/^CONFIG_LINUX=y$/ d
        /^CONFIG_VHOST_SCSI=y$/ d
        /^(libs_softmmu|TOOLS|ROMS)=/ s/^([^=]*=)(.*)$/\1/
        /NM=nm/ s/nm/llvm-nm/
        /CONFIG_UUID=y/ d
        /CONFIG_PREADV=y/ d
        /CONFIG_COROUTINE_BACKEND=/ s/=.*$/=emscripten/
        /CONFIG_COROUTINE_POOL/ s/0/1/
        s/-m64//g
        /^ARCH=/ s/x86_64/i386/
        /CONFIG_VHDX=y/ d
        s|/tcg/i386|/tcg/asmjs|g' config-host.mak
else
    sed --in-place -r -e '/^CONFIG_LINUX=y$/ d
        /^CONFIG_VHOST_SCSI=y$/ d
        /^CONFIG_COROUTINE_POOL/ s/0/1/
        /^(TOOLS|ROMS)=/ s/^([^=]*=)(.*)$/\1/
        /CONFIG_UUID=y/ d
        /CONFIG_PREADV=y/ d
        s/-m64//g
        /^ARCH=/ s/x86_64/i386/
        /CONFIG_VHDX=y/ d' config-host.mak
fi
echo "CONFIG_DUMMY=y" >> config-host.mak

prepare_helpers

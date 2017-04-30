#!/bin/bash

export STUBDIR=$(pwd)/../../stub/
. ../../stub/opts.sh

ARGS=$*

function link_bin() {
  echo "Linking $1..."
  base=$(basename $1)
  ln -sf $1 $base.bc
  time emcc $base.bc $OPTS \
    dtc/libfdt/libfdt.a \
    ../../$DIRNAME/glib/glib/.libs/libglib-2.0.so \
    ../../$DIRNAME/pixman-0.32.6/pixman/.libs/libpixman-1.so \
    ../../$DIRNAME/stub/*.so \
    -o $base.html \
    -s USE_SDL=2 \
    -s EXPORTED_FUNCTIONS="['_main','_mul_unsigned_long_long','_helper_ret_ldub_mmu','_helper_le_lduw_mmu','_helper_le_ldul_mmu','_helper_be_lduw_mmu','_helper_be_ldul_mmu','_helper_ret_stb_mmu','_helper_le_stw_mmu','_helper_le_stl_mmu','_helper_be_stw_mmu','_helper_be_stl_mmu','_helper_be_ldq_mmu','_helper_le_ldq_mmu','_helper_le_stq_mmu','_helper_be_stq_mmu']" \
    -s ASYNCIFY_WHITELIST="[$(cat ../../stub/${base}.whitelist)]" \
    -s RESERVED_FUNCTION_POINTERS=1 \
    -s INVOKE_RUN=0 \
    -s ASYNCIFY=1 \
    --shell-file ../shell.html \
    --preload-file pc-bios \
    --memory-init-file 1 \
    --emrun \
    $ARGS
}

for bin in *-softmmu/qemu-system-*
do
  if echo $bin | grep -vqF "."
  then
    link_bin $bin
  fi
done

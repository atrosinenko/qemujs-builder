**This repo is not required anymore for the new version of QEMU.js (which is still even more work-in-progress, though).**

This repository contains scripts for building Qemu.js (please see [description](https://github.com/atrosinenko/qemujs/blob/emscripten/README.md) for details). To build Qemu.js, clone this repository, navigate to its directory and run

    git submodule update --init
    cd qemu
    mkdir build-emscripten
    git submodule update --init dtc

Now you can start building:

1. Install the `incoming` version of Emscripten through the Emscripten SDK.
2. Until Emterpreter can run coroutines, one have to use the deprecated Asyncify. To use it with Qemu.js you need too apply two patches:
   * set new remote `https://github.com/atrosinenko/emscripten.git` up for the `./emscripten/incoming` repository inside the SDK directory and merge the `asyncify-qemu` from there into `incoming`
   * in the `./clang/fastcomp/src/` repository merge the commit 19435d6 into `incoming`, then rebuild (`cd ../build_incoming_64 && make`) -- see [this bug report](https://github.com/kripken/emscripten-fastcomp/issues/167) for details
3. Navigate to `stub`, adjust `opts.sh` and run `./build-deps.sh` inside it. **Warning: it will download and build some libraries via plain http**
4. Adjust guest architecture list in `configure-cmd.sh`
5. Navigate to `qemu/build-emscripten` and run

        emconfigure ../../configure-cmd.sh
        emmake make && ../../qemu-link.sh

6. Now you have files `qemu-system-*.{js,html.mem,data}` in your build directory -- it is Qemu.js. You also need the `shell.html` file from parent directory to run it. Running directly from the file system may not work, so use some HTTP server (the `emrun` tool from SDK is even capable of showing the console output of Emscripten-compiled code).

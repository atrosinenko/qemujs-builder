This repository contains scripts for building Qemu.js. To build Qemu.js, clone this repository, navigate to its directory and run

    git submodule init
    git submodule update
    mkdir qemu/build-emscripten
    cd qemu
    git submodule update --init dtc

Now you can start building:

1. Setup Emscripten 1.36.0 through SDK, set new remote `https://github.com/atrosinenko/emscripten.git` for emscripten repository inside the SDK directory and pull `qemu` branch
2. Navigate to `stub`, adjust `opts.sh` and run `./build-deps.sh` inside it. **Warning: it will download and build some libraries via plain http**
3. Adjust guest architecture list in `configure-cmd.sh`
4. Navigate to `qemu/build-emscripten` and run

        emconfigure ../../configure-cmd.sh
        emmake make && ../../qemu-link.sh

5. Now you have files `qemu-system-*.{js,html.mem,data}` in your build directory --- it is Qemu.js. You also need the `shell.html` file from parent directory to run it. Running directly from the file system may not work, so use some HTTP server.

This repository contains scripts for building Qemu.js. To build Qemu, create a directory such as `qemujs-build` with the following structure

    qemujs-build \
           | configure-cmd.sh (from this repo)
           | qemu-link.sh (from this repo too)
           | qemujs-builder (this repo itself)
           | qemujs \
                     | build-emscripten

Clone [qemujs](https://github.com/atrosinenko/qemujs) to `qemujs-build` directory and create a build directory inside it (for example `build-emscripten`).

Now you can start building:

1. Setup Emscripten 1.36.0 through SDK, set new remote `https://github.com/atrosinenko/emscripten.git` for emscripten repository inside the SDK directory and pull `qemu` branch
2. Navigate to `qemujs-builder`, adjust `opts.sh` and run `./build.sh` inside it. **Warning: it will download and build some libraries via plain http**
3. Adjust guest architecture list in `configure-cmd.sh`
4. Navigate to `build-emscripten` and run

        emconfigure ../../configure-cmd.sh
        emmake make && ../../qemu-link.sh

5. Now you have files `qemu-system-*.{js,html.mem,data}` in your build directory --- it is Qemu.js. You also need the `shell.html` file from parent directory to run it. Running directly from the file system may not work, so use some HTTP server.

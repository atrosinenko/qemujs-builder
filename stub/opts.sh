if true
then
	#OPTS="-m32 -O3 -s ALLOW_MEMORY_GROWTH=1"
	OPTS="-m32 -O3"
	#OPTS="-m32 -Os -g2"
	#OPTS="-m32 -O2 -g3 -s ASSERTIONS=1 -s SAFE_HEAP=1 -s ALLOW_MEMORY_GROWTH=1 -s INLINING_LIMIT=1"
	BUILDTYPE=emscripten
	CONFRUNNER=emconfigure
	MAKERUNNER=emmake
	FFIOPT="--host=emscripten-unknown-linux"
	export PATH="/home/trosinenko/soft/emsdk_portable/emscripten/master/system/bin:$PATH"
else
	OPTS="-m32 -g"
	BUILDTYPE=native
	CONFRUNNER=$(pwd)/clangconfigure
	MAKERUNNER=$(pwd)/clangconfigure
	FFIOPT=
fi

DIRNAME="build_${BUILDTYPE}_$(echo $OPTS | sed 's/[ =]/_/g')"

echo "OPTS = $OPTS"
echo "DIRNAME = $DIRNAME"

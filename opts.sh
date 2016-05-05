if false
then
	OPTS="-m32 -g3 -s ASSERTIONS=1 -s SAFE_HEAP=1"
	BUILDTYPE=emscripten
	CONFRUNNER=emconfigure
	MAKERUNNER=emmake
	FFIOPT="--host=emscripten-unknown-linux"
	export PATH="/home/trosinenko/soft/emsdk_portable/emscripten/incoming/system/bin:$PATH"
else
	OPTS="-m32 -g"
	BUILDTYPE=native
	CONFRUNNER=
	MAKERUNNER=
	FFIOPT=
fi

DIRNAME="build_${BUILDTYPE}_$(echo $OPTS | sed 's/[ =]/_/g')"

echo "OPTS = $OPTS"
echo "DIRNAME = $DIRNAME"

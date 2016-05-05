OPTS="-m32 -g3 -s ASSERTIONS=1 -s SAFE_HEAP=1"
DIRNAME="build_$(echo $OPTS | sed 's/ /_/g')"

echo "OPTS = $OPTS"
echo "DIRNAME = $DIRNAME"

all: libresolv.so libthread.so libother.so include/wrappers.h

libresolv.so: res_query.c
	$(CC) $(CFLAGS) --shared res_query.c -fPIC -o libresolv.so

libthread.so: thread.c
	$(CC) $(CFLAGS) --shared thread.c -fPIC -o libthread.so

libother.so: other.c
	$(CC) $(CFLAGS) --shared other.c -fPIC -o libother.so

include/wrappers.h:
	mkdir -p include
	gcc -E hlp.h -I ../qemu/include/ -I ../qemu/build-emscripten/ | sed -r 's/(DEF_HELPER)/\n\1/g' | ./gen_helper_wrappers.py > include/wrappers.h

clean:
	rm -f *.so include/wrappers.h

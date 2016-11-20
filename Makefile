all: libresolv.so libthread.so libother.so include/wrappers.h

SHELL = /bin/bash -o pipefail

libresolv.so: res_query.c
	$(CC) $(CFLAGS) --shared res_query.c -fPIC -o libresolv.so

libthread.so: thread.c
	$(CC) $(CFLAGS) --shared thread.c -fPIC -o libthread.so

libother.so: other.c
	$(CC) $(CFLAGS) --shared other.c -fPIC -o libother.so

clean:
	rm -f *.so

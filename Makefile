all: libresolv.so libthread.so libother.so

libresolv.so: res_query.c
	$(CC) -m32 --shared res_query.c -fPIC -o libresolv.so

libthread.so: thread.c
	$(CC) -m32 --shared thread.c -o libthread.so

libother.so: other.c
	$(CC) -m32 --shared other.c -o libother.so

clean:
	rm -f *.so

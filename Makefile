all: libresolv.so libthread.so

libresolv.so: res_query.c
	$(CC) -m32 --shared res_query.c -fPIC -o libresolv.so

libthread.so: thread.c
	$(CC) -m32 --shared thread.c -o libthread.so

clean:
	rm -f *.so

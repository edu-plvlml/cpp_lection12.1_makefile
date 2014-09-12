all: main.exe

main.o: main.cpp
	g++ -o main.o -c main.cpp

static.o: static.cpp
	g++ -o static.o -c static.cpp

shared.o: shared.cpp
# Position Independent Code
	g++ -fPIC -o shared.o -c shared.cpp

libstatic.a: static.o
# r - replace or insert
# c - do not warn
	ar rc libstatic.a static.o

libshared.so: shared.o
	g++ -shared -o libshared.so shared.o 

main.exe: main.o libstatic.a libshared.so
	g++ -o main.exe main.o -L./ -lstatic -lshared

.PHONY: all install clean dist-clean check-syntax

install:
	cp libshared.so /usr/local/lib/ && ldconfig

clean:
	-rm ./*.o
	-rm ./lib*.a
	-rm ./lib*.so
	-rm ./main.exe

dist-clean: clean
	-rm /usr/local/lib/libshared.so && ldconfig

check-syntax:
	$(COMPILE.cc) -fsyntax-only $(CHK_SOURCES)

all: main.exe

main.o: main.cpp
	g++ -o main.o -c main.cpp

static.o: static.cpp
	g++ -o static.o -c static.cpp

shared.o: shared.cpp
# PIC - Position Independent Code
	g++ -fPIC -o shared.o -c shared.cpp

libstatic.a: static.o
# r - insert with replacement
# c - create without a warning
	ar rc libstatic.a static.o

libshared.so: shared.o
	g++ -shared -o libshared.so shared.o 

main.exe: main.o libstatic.a libshared.so
	g++ -o main.exe main.o -L./ -lstatic -lshared

main.i: main.cpp
# Output preprocessed source code without compilation
	g++ -o main.i -E main.cpp

main.d: main.cpp
# Output Makefile rules describing the dependencies
	g++ -o main.d -E -MM -MP main.cpp

.PHONY: all install clean dist-clean

install:
	cp libshared.so /usr/local/lib/ && ldconfig

clean:
	-rm ./*.o
	-rm ./lib*.a
	-rm ./lib*.so
	-rm ./main.exe

dist-clean: clean
	-rm /usr/local/lib/libshared.so && ldconfig

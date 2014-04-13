all: main.exe

static.o: static.cpp
	g++ -o static.o -c static.cpp

shared.o: shared.cpp
# Position Independent Code
	g++ -fPIC -o shared.o -c shared.cpp

static.lib: static.o
# r - replace or insert
# c - do not warn
	ar rc static.lib static.o

shared.dll: shared.o
	g++ -shared -o shared.dll shared.o 

main.o: main.cpp
	g++ -o main.o -c main.cpp

main.exe: main.o static.lib shared.dll
	g++ -o main.exe main.o static.lib shared.dll

.PHONY: all check-syntax install clean dist-clean

install:
	cp shared.dll /usr/local/lib/

clean:
	-rm ./*.o
	-rm ./*.lib
	-rm ./*.dll
	-rm ./main.exe

dist-clean: clean
	-rm /usr/local/lib/shared.dll

check-syntax:
	$(COMPILE.cc) -S $(CHK_SOURCES) -o /dev/null

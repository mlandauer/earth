# $Id$

CC = g++
OPTION = -g
INCLUDE = -I/usr/lib/qt/include

OBJECTS = SpMisc.o SpFile.o SpPathString.o SpTime.o

all: testCode
	./testCode
	
clean:
	rm -fr ii_files *.o testCode

testCode: testCode.o $(OBJECTS) SpMisc.h SpFile.h
	$(CC) $(OPTION) -o testCode testCode.o $(OBJECTS) -lqt

testCode.o: testCode.C SpMisc.h SpFile.h
	$(CC) $(OPTION) -c testCode.C $(INCLUDE)

SpMisc.o: SpMisc.C SpMisc.h
	$(CC) $(OPTION) -c SpMisc.C $(INCLUDE)

SpFile.o: SpFile.C SpFile.h SpPathString.h
	$(CC) $(OPTION) -c SpFile.C $(INCLUDE)

SpPathString.o: SpPathString.C SpPathString.h SpMisc.h
	$(CC) $(OPTION) -c SpPathString.C $(INCLUDE)

SpTime.o: SpTime.C SpTime.h SpMisc.h
	$(CC) $(OPTION) -c SpTime.C $(INCLUDE)


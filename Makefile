# $Id$

CC = g++
OPTION = -g
INCLUDE = -I/usr/lib/qt/include

OBJECTS = SpSize.o SpFile.o SpPathString.o SpTime.o

all: testCode
	./testCode
	
clean:
	rm -fr ii_files *.o testCode

testCode: testCode.o $(OBJECTS) SpFile.h
	$(CC) $(OPTION) -o testCode testCode.o $(OBJECTS) -lqt

testCode.o: testCode.C SpFile.h
	$(CC) $(OPTION) -c testCode.C $(INCLUDE)

SpSize.o: SpSize.C SpSize.h
	$(CC) $(OPTION) -c SpSize.C $(INCLUDE)

SpFile.o: SpFile.C SpFile.h SpPathString.h SpTime.h SpSize.h
	$(CC) $(OPTION) -c SpFile.C $(INCLUDE)

SpPathString.o: SpPathString.C SpPathString.h SpString.h
	$(CC) $(OPTION) -c SpPathString.C $(INCLUDE)

SpTime.o: SpTime.C SpTime.h SpString.h
	$(CC) $(OPTION) -c SpTime.C $(INCLUDE)


# $Id$

CC = g++
OPTION = -g
INCLUDE = -I/usr/lib/qt/include

all: testCode
	./testCode

testCode: testCode.o SpMisc.o SpFile.o SpPathString.o
	$(CC) $(OPTION) -o testCode testCode.o SpMisc.o SpFile.o SpPathString.o -lqt

testCode.o: testCode.C SpMisc.h SpFile.h
	$(CC) $(OPTION) -c testCode.C $(INCLUDE)

SpMisc.o: SpMisc.C SpMisc.h
	$(CC) $(OPTION) -c SpMisc.C $(INCLUDE)

SpFile.o: SpFile.C SpFile.h SpPathString.h
	$(CC) $(OPTION) -c SpFile.C $(INCLUDE)

SpPathString.o: SpPathString.C SpPathString.h SpMisc.h
	$(CC) $(OPTION) -c SpPathString.C $(INCLUDE)


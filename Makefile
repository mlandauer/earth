# $Id$

CC = g++
OPTION = -g
INCLUDE = -I/usr/lib/qt/include

all: testCode
	./testCode

testCode: testCode.o SpMisc.o SpFile.o
	$(CC) $(OPTION) -o testCode testCode.o SpMisc.o SpFile.o -lqt

testCode.o: testCode.C SpMisc.h SpFile.h
	$(CC) $(OPTION) -c testCode.C $(INCLUDE)

SpMisc.o: SpMisc.C SpMisc.h
	$(CC) $(OPTION) -c SpMisc.C $(INCLUDE)

SpFile.o: SpFile.C SpFile.h
	$(CC) $(OPTION) -c SpFile.C $(INCLUDE)


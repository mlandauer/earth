# $Id$

CC = g++
OPTION = -g
INCLUDE = 

OBJECTS = SpSize.o SpFile.o SpPathString.o SpTime.o \
          SpUid.o SpGid.o SpImage.o SpSGIImage.o

all: testCode
	./testCode
	
clean:
	rm -fr ii_files *.o testCode

testCode: testCode.o $(OBJECTS) SpFile.h SpUid.h SpGid.h SpImage.h
	$(CC) $(OPTION) -o testCode testCode.o $(OBJECTS) -lqt

testCode.o: testCode.C SpFile.h
	$(CC) $(OPTION) -c testCode.C $(INCLUDE)

SpSize.o: SpSize.C SpSize.h
	$(CC) $(OPTION) -c SpSize.C $(INCLUDE)

SpFile.o: SpFile.C SpFile.h SpPathString.h SpTime.h SpSize.h SpUid.h SpGid.h
	$(CC) $(OPTION) -c SpFile.C $(INCLUDE)

SpPathString.o: SpPathString.C SpPathString.h
	$(CC) $(OPTION) -c SpPathString.C $(INCLUDE)

SpTime.o: SpTime.C SpTime.h
	$(CC) $(OPTION) -c SpTime.C $(INCLUDE)

SpUid.o: SpUid.C SpUid.h
	$(CC) $(OPTION) -c SpUid.C $(INCLUDE)

SpGid.o: SpGid.C SpGid.h
	$(CC) $(OPTION) -c SpGid.C $(INCLUDE)

SpImage.o: SpImage.C SpImage.h SpFile.h
	$(CC) $(OPTION) -c SpImage.C $(INCLUDE)

SpSGIImage.o: SpSGIImage.C SpSGIImage.h SpImage.h
	$(CC) $(OPTION) -c SpSGIImage.C $(INCLUDE)


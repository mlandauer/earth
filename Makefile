# $Id$

CC = g++
OPTION = -g
INCLUDE = 

SRCS = SpDir.C SpFsObject.C SpImageFormat.C SpSize.C testCode.C \
       SpDirMon.C SpGid.C SpImageSeq.C SpTester.C \
       SpDirMonFam.C SpImage.C SpLibLoader.C SpTime.C \
       SpFile.C SpImageDim.C SpPath.C SpUid.C \
       testSpDir.C testSpDirMon.C testSpFile.C testSpFsObject.C \
       testSpImage.C testSpImageSeq.C testSpPath.C testSpSize.C \
       testSpTime.C testSpFsObjectHandle.C

OBJECTS = SpSize.o SpFile.o SpPath.o SpTime.o SpTester.o SpLibLoader.o \
          SpUid.o SpGid.o SpImage.o SpImageFormat.o SpImageDim.o \
          SpFsObject.o SpDir.o SpDirMon.o SpDirMonFam.o \
		  SpImageSeq.o \
          testSpDir.o testSpDirMon.o testSpFile.o testSpFsObject.o \
          testSpImage.o testSpImageSeq.o testSpPath.o testSpSize.o \
          testSpTime.o testSpFsObjectHandle.o

all: testCode
	cd imageFormats; make all
	LD_LIBRARY_PATH=/usr/local/lib:imageFormats ./testCode
	
clean:
	cd imageFormats; make clean
	rm -fr *.o *.so testCode

testCode: testCode.o $(OBJECTS)
	$(CC) $(OPTION) -rdynamic -o testCode testCode.o $(OBJECTS) -ldl -lfam
	
depend:
	cd imageFormats; make depend
	makedepend -I/usr/include/g++ -I/usr/local/include -- $(OPTION) -- $(SRCS)

%.o : %.C
	$(CC) $(OPTION) $(INCLUDE) -c $< -o $@

# $Id$

CC = g++
OPTION = -g
INCLUDE = 

SRCS = SpDir.cpp SpFsObject.cpp SpImageFormat.cpp SpSize.cpp testCode.cpp \
       SpGid.cpp SpImageSeq.cpp SpTester.cpp \
       SpImage.cpp SpLibLoader.cpp SpTime.cpp \
       SpFile.cpp SpImageDim.cpp SpPath.cpp SpUid.cpp \
       testDir.cpp testFile.cpp testFsObject.cpp \
       testImage.cpp testImageSeq.cpp testPath.cpp testSize.cpp \
       testTime.cpp testFsObjectHandle.cpp

OBJECTS = SpSize.o SpFile.o SpPath.o SpTime.o SpTester.o SpLibLoader.o \
          SpUid.o SpGid.o SpImage.o SpImageFormat.o SpImageDim.o \
          SpFsObject.o SpDir.o \
		  SpImageSeq.o \
          testDir.o testFile.o testFsObject.o \
          testImage.o testImageSeq.o testPath.o testSize.o \
          testTime.o testFsObjectHandle.o

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

%.o : %.cpp
	$(CC) $(OPTION) $(INCLUDE) -c $< -o $@

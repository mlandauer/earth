# $Id$

CC = g++
OPTION = -g
INCLUDE = 

SRCS = SpDir.cpp SpFsObject.cpp SpImageFormat.cpp SpSize.cpp testCode.cpp \
       SpGid.cpp SpImageSeq.cpp SpTester.cpp \
       SpImage.cpp SpLibLoader.cpp SpTime.cpp \
       SpFile.cpp SpImageDim.cpp SpPath.cpp SpUid.cpp \
       testSpDir.cpp testSpFile.cpp testSpFsObject.cpp \
       testSpImage.cpp testSpImageSeq.cpp testSpPath.cpp testSpSize.cpp \
       testSpTime.cpp testSpFsObjectHandle.cpp

OBJECTS = SpSize.o SpFile.o SpPath.o SpTime.o SpTester.o SpLibLoader.o \
          SpUid.o SpGid.o SpImage.o SpImageFormat.o SpImageDim.o \
          SpFsObject.o SpDir.o \
		  SpImageSeq.o \
          testSpDir.o testSpFile.o testSpFsObject.o \
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

%.o : %.cpp
	$(CC) $(OPTION) $(INCLUDE) -c $< -o $@

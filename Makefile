# $Id$

CC = g++
OPTION = -g
INCLUDE = 

SRCS = Dir.cpp FsObject.cpp ImageFormat.cpp Size.cpp testCode.cpp \
       UserGroup.cpp ImageSeq.cpp Tester.cpp \
       Image.cpp LibLoader.cpp DateTime.cpp \
       File.cpp ImageDim.cpp Path.cpp User.cpp \
       testDir.cpp testFile.cpp testFsObject.cpp \
       testImage.cpp testImageSeq.cpp testPath.cpp testSize.cpp \
       testDateTime.cpp testFsObjectHandle.cpp

OBJECTS = Size.o File.o Path.o DateTime.o Tester.o LibLoader.o \
          User.o UserGroup.o Image.o ImageFormat.o ImageDim.o \
          FsObject.o Dir.o \
		  ImageSeq.o \
          testDir.o testFile.o testFsObject.o \
          testImage.o testImageSeq.o testPath.o testSize.o \
          testDateTime.o testFsObjectHandle.o

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

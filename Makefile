# $Id$

CC = g++
OPTION = -g
INCLUDE = 

SRCS = Dir.cpp FsObject.cpp ImageFormat.cpp Size.cpp testCode.cpp \
       UserGroup.cpp ImageSeq.cpp Tester.cpp \
       Image.cpp LibLoader.cpp DateTime.cpp \
       File.cpp ImageDim.cpp Path.cpp User.cpp

OBJECTS = Size.o File.o Path.o DateTime.o Tester.o LibLoader.o \
          User.o UserGroup.o Image.o ImageFormat.o ImageDim.o \
          FsObject.o Dir.o \
		  ImageSeq.o \

all: $(OBJECTS)
	cd imageFormats; make all
	cd test; make all
	LD_LIBRARY_PATH=/usr/local/lib:imageFormats ./test/testCode
	
	
clean:
	cd imageFormats; make clean
	cd test; make clean
	rm -fr *.o *.so testCode

depend:
	cd imageFormats; make depend
	makedepend -I/usr/include/g++ -I/usr/local/include -- $(OPTION) -- $(SRCS)

%.o : %.cpp
	$(CC) $(OPTION) $(INCLUDE) -c $< -o $@

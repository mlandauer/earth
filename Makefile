# $Id$

CC = g++
OPTION = -g
INCLUDE = 

SRCS = testCode.cpp \
       Dir.cpp FsObject.cpp ImageFormat.cpp Size.cpp UserGroup.cpp \
			 ImageSeq.cpp Tester.cpp  Image.cpp LibLoader.cpp DateTime.cpp \
			 File.cpp ImageDim.cpp Path.cpp User.cpp Frames.cpp

OBJECTS = Dir.o FsObject.o ImageFormat.o Size.o UserGroup.o \
          ImageSeq.o Tester.o Image.o LibLoader.o DateTime.o \
					File.o ImageDim.o Path.o User.o Frames.o		 

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

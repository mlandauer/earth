# $Id$

CC = g++
OPTION = -g
INCLUDE = `xml++-config --cflags` `xml-config --cflags` 
LIBS = -ldl `xml++-config --libs` -lfam

SRCS = Dir.cpp FsObject.cpp ImageFormat.cpp Size.cpp UserGroup.cpp \
			 ImageSeq.cpp Image.cpp LibLoader.cpp DateTime.cpp \
			 File.cpp ImageDim.cpp Path.cpp User.cpp Frames.cpp \
			 IndexDirectory.cpp DirMon.cpp \
			 earth.cpp

OBJECTS = Dir.o FsObject.o ImageFormat.o Size.o UserGroup.o \
					ImageSeq.o Image.o LibLoader.o DateTime.o \
					File.o ImageDim.o Path.o User.o Frames.o \
					IndexDirectory.o DirMon.o \
					earth.o

all: $(OBJECTS)
	cd imageFormats; make all
	cd test; make all
	$(CC) $(OPTION) -rdynamic -o earth $(OBJECTS) $(LIBS)
	
clean:
	cd imageFormats; make clean
	cd test; make clean
	rm -fr *.o *.so testCode

depend:
	cd imageFormats; make depend
	makedepend -I/usr/include/g++ -I/usr/local/include -- $(OPTION) -- $(SRCS)

%.o : %.cpp
	$(CC) $(OPTION) $(INCLUDE) -c $< -o $@

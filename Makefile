# $Id$

CC = g++
OPTION = -g
INCLUDE = `xml++-config --cflags` `xml-config --cflags`
LIBS = -ldl `xml++-config --libs` -lfam

SRCS = src/Dir.cpp src/FsObject.cpp src/ImageFormat.cpp src/Size.cpp src/UserGroup.cpp \
			 src/ImageSeq.cpp src/Image.cpp src/LibLoader.cpp src/DateTime.cpp \
			 src/File.cpp src/ImageDim.cpp src/Path.cpp src/User.cpp src/Frames.cpp \
			 src/IndexDirectory.cpp src/ImageMon.cpp src/CachedDir.cpp src/ImageEventLogger.cpp \
			 src/ImageSeqMon.cpp \
			 src/earth.cpp

OBJECTS = src/Dir.o src/FsObject.o src/ImageFormat.o src/Size.o src/UserGroup.o \
					src/ImageSeq.o src/Image.o src/LibLoader.o src/DateTime.o \
					src/File.o src/ImageDim.o src/Path.o src/User.o src/Frames.o \
					src/IndexDirectory.o src/ImageMon.o src/CachedDir.o src/ImageEventLogger.o \
					src/ImageSeqMon.o \
					src/earth.o
					
EARTH_OBJECTS = src/Dir.o src/FsObject.o src/ImageFormat.o src/Size.o src/UserGroup.o \
					src/ImageSeq.o src/Image.o src/LibLoader.o src/DateTime.o \
					src/File.o src/ImageDim.o src/Path.o src/User.o src/Frames.o \
					src/IndexDirectory.o \
					src/earth.o

all: $(OBJECTS)
	cd imageFormats; make all
	cd test; make all
	$(CC) $(OPTION) -rdynamic -o earth $(EARTH_OBJECTS) $(LIBS)
	
clean:
	cd imageFormats; make clean
	cd test; make clean
	rm -fr *.o *.so testCode

depend:
	cd imageFormats; make depend
	makedepend -I/usr/include/g++ -I/usr/local/include -- $(OPTION) -- $(SRCS)

%.o : %.cpp
	$(CC) $(OPTION) $(INCLUDE) -c $< -o $@

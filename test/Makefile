# $Id$

CC = g++
OPTION = -g
INCLUDE = -I..

SRCS = ../Dir.cpp ../FsObject.cpp ../ImageFormat.cpp ../Size.cpp ../UserGroup.cpp \
			 ../ImageSeq.cpp ../Image.cpp ../LibLoader.cpp ../DateTime.cpp \
			 ../File.cpp ../ImageDim.cpp ../Path.cpp ../User.cpp ../Frames.cpp \
			 ../IndexDirectory.cpp ../ImageMon.cpp ../CachedDir.cpp ../ImageEventLogger.cpp \
       testCode.cpp \
			 testImageMon.cpp \
       testDir.cpp testFile.cpp testImage.cpp testImageSeq.cpp \
			 testPath.cpp testSize.cpp testDateTime.cpp testIndexDirectory.cpp

OBJECTS = ../Dir.o ../FsObject.o ../ImageFormat.o ../Size.o ../UserGroup.o \
          ../ImageSeq.o ../Image.o ../LibLoader.o ../DateTime.o \
          ../File.o ../ImageDim.o ../Path.o ../User.o ../Frames.o \
					../IndexDirectory.o ../ImageMon.o ../CachedDir.o ../ImageEventLogger.o \
					testCode.o \
					testImageMon.o \
					testDir.o testFile.o testImage.o testImageSeq.o \
					testPath.o testSize.o testDateTime.o testIndexDirectory.o

all: testCode
	
clean:
	rm -fr *.o *.so testCode

testCode: $(OBJECTS)
	$(CC) $(OPTION) -rdynamic -o testCode $(OBJECTS) -ldl -lcppunit -lfam
	
depend:
	cd imageFormats; make depend
	makedepend -I/usr/include/g++ -I/usr/local/include -- $(OPTION) -- $(SRCS)

%.o : %.cpp
	$(CC) $(OPTION) $(INCLUDE) -c $< -o $@

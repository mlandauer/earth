# $Id$

CC = g++
OPTION = -g
INCLUDE = -I..

SRCS = ../Dir.cpp ../FsObject.cpp ../ImageFormat.cpp ../Size.cpp \
       ../testCode.cpp ../UserGroup.cpp ../ImageSeq.cpp ../Tester.cpp \
       ../Image.cpp ../LibLoader.cpp ../DateTime.cpp \
       ../File.cpp ../ImageDim.cpp ../Path.cpp ../User.cpp ../Frames.cpp\
       testDir.cpp testFile.cpp \
       testImage.cpp testImageSeq.cpp testPath.cpp testSize.cpp \
       testDateTime.cpp

OBJECTS = ../Size.o ../File.o ../Path.o ../DateTime.o ../Tester.o \
          ../LibLoader.o ../User.o ../UserGroup.o ../Image.o ../ImageFormat.o \
	  ../ImageDim.o ../FsObject.o ../Dir.o ../ImageSeq.o ../Frames.o\
          testDir.o testFile.o \
          testImage.o testImageSeq.o testPath.o testSize.o \
          testDateTime.o

all: testCode
	
clean:
	rm -fr *.o *.so testCode

testCode: testCode.o $(OBJECTS)
	$(CC) $(OPTION) -rdynamic -o testCode testCode.o $(OBJECTS) -ldl
	
depend:
	cd imageFormats; make depend
	makedepend -I/usr/include/g++ -I/usr/local/include -- $(OPTION) -- $(SRCS)

%.o : %.cpp
	$(CC) $(OPTION) $(INCLUDE) -c $< -o $@

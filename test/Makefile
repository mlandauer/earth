# $Id$

CC = g++
OPTION = -g
INCLUDE = -I../src -I/usr/local/include -I/usr/include/mysql

SRCS = ../src/Dir.cpp ../src/FsObject.cpp ../src/ImageFormat.cpp ../src/Size.cpp ../src/UserGroup.cpp \
			 ../src/ImageSeq.cpp ../src/Image.cpp ../src/LibLoader.cpp ../src/DateTime.cpp \
			 ../src/File.cpp ../src/ImageDim.cpp ../src/Path.cpp ../src/User.cpp ../src/Frames.cpp \
			 ../src/IndexDirectory.cpp ../src/ImageMon.cpp ../src/ImageSeqMon.cpp ../src/CachedDir.cpp \
			 ../src/ImageEventLogger.cpp ../src/Sequences.cpp \
       testCode.cpp \
			 testImageMon.cpp testImageSeqMon.cpp \
       testDir.cpp testFile.cpp testImage.cpp testImageSeq.cpp \
			 testPath.cpp testSize.cpp testDateTime.cpp testIndexDirectory.cpp \
			 testDatabase.cpp

OBJECTS = ../src/Dir.o ../src/FsObject.o ../src/ImageFormat.o ../src/Size.o ../src/UserGroup.o \
          ../src/ImageSeq.o ../src/Image.o ../src/LibLoader.o ../src/DateTime.o \
          ../src/File.o ../src/ImageDim.o ../src/Path.o ../src/User.o ../src/Frames.o \
					../src/IndexDirectory.o ../src/ImageMon.o ../src/ImageSeqMon.o ../src/CachedDir.o \
					../src/ImageEventLogger.o ../src/Sequences.o \
					testCode.o \
					testImageMon.o testImageSeqMon.o \
					testDir.o testFile.o testImage.o testImageSeq.o \
					testPath.o testSize.o testDateTime.o testIndexDirectory.o \
					testDatabase.o

all: testCode
	
clean:
	rm -fr *.o *.so testCode

testCode: $(OBJECTS)
	$(CC) $(OPTION) -rdynamic -o testCode $(OBJECTS) -ldl -lcppunit -lfam -lsqlplus
	
depend:
	cd imageFormats; make depend
	makedepend -I/usr/include/g++ -I/usr/local/include -- $(OPTION) -- $(SRCS)

%.o : %.cpp
	$(CC) $(OPTION) $(INCLUDE) -c $< -o $@

# $Id$

CC = g++
OPTION = -g
INCLUDE = -I..

SRCS = SpCINEONImage.cpp SpGIFImage.cpp SpPRMANZImage.cpp SpSGIImage.cpp \
       SpFITImage.cpp SpIFFImage.cpp SpPRTEXImage.cpp SpTIFFImage.cpp 

SO_OBJECTS = SpTIFFImage.so SpFITImage.so SpPRMANZImage.so SpSGIImage.so\
		  SpGIFImage.so SpCINEONImage.so SpIFFImage.so SpPRTEXImage.so
		  
all: $(SO_OBJECTS)
	
clean:
	rm -fr *.o *.so
	
depend:
	makedepend -I/usr/include/g++ -I.. -- $(OPTION) -- $(SRCS)

%.o : %.cpp
	$(CC) -fPIC $(OPTION) -c $< $(INCLUDE) -o $@

# Make the shared objects
%.so : %.o
	$(CC) -shared -o $@ $<

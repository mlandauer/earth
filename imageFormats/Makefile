# $Id$

CC = g++
OPTION = -g
INCLUDE = -I..

SRCS = SpCINEONImage.C SpGIFImage.C SpPRMANZImage.C SpSGIImage.C \
       SpFITImage.C SpIFFImage.C SpPRTEXImage.C SpTIFFImage.C 

SO_OBJECTS = SpTIFFImage.so SpFITImage.so SpPRMANZImage.so SpSGIImage.so\
		  SpGIFImage.so SpCINEONImage.so SpIFFImage.so SpPRTEXImage.so
		  
all: $(SO_OBJECTS)
	
clean:
	rm -fr *.o *.so
	
depend:
	makedepend -I/usr/include/g++ -I.. -- $(OPTION) -- $(SRCS)

%.o : %.C
	$(CC) -fPIC $(OPTION) -c $< $(INCLUDE) -o $@

# Make the shared objects
%.so : %.o
	$(CC) -shared -o $@ $<

# $Id$

CC = g++
OPTION = -g
INCLUDE = -I../src

SRCS = CINEONImage.cpp GIFImage.cpp PRMANZImage.cpp SGIImage.cpp \
       FITImage.cpp IFFImage.cpp PRTEXImage.cpp TIFFImage.cpp 

SO_OBJECTS = TIFFImage.so FITImage.so PRMANZImage.so SGIImage.so\
		  GIFImage.so CINEONImage.so IFFImage.so PRTEXImage.so
		  
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

# $Id$

CC = g++
OPTION = -g
INCLUDE = -I..

SO_OBJECTS = SpTIFFImage.so SpFITImage.so SpPRMANZImage.so SpSGIImage.so\
		  SpGIFImage.so SpCINEONImage.so SpIFFImage.so SpPRTEXImage.so
		  
all: $(SO_OBJECTS)
	
clean:
	rm -fr *.o *.so

SpSGIImage.o: SpSGIImage.C SpSGIImage.h
	$(CC) -fPIC $(OPTION) -c SpSGIImage.C $(INCLUDE)
	
SpTIFFImage.o: SpTIFFImage.C SpTIFFImage.h
	$(CC) -fPIC $(OPTION) -c SpTIFFImage.C $(INCLUDE)

SpIFFImage.o: SpIFFImage.C SpIFFImage.h
	$(CC) -fPIC $(OPTION) -c SpIFFImage.C $(INCLUDE)

SpFITImage.o: SpFITImage.C SpFITImage.h
	$(CC) -fPIC $(OPTION) -c SpFITImage.C $(INCLUDE)

SpPRMANZImage.o: SpPRMANZImage.C SpPRMANZImage.h
	$(CC) -fPIC $(OPTION) -c SpPRMANZImage.C $(INCLUDE)

SpPRTEXImage.o: SpPRTEXImage.C SpPRTEXImage.h
	$(CC) -fPIC $(OPTION) -c SpPRTEXImage.C $(INCLUDE)

SpGIFImage.o: SpGIFImage.C SpGIFImage.h
	$(CC) -fPIC $(OPTION) -c SpGIFImage.C $(INCLUDE)

SpCINEONImage.o: SpCINEONImage.C SpCINEONImage.h
	$(CC) -fPIC $(OPTION) -c SpCINEONImage.C $(INCLUDE)

# Make the shared objects

SpSGIImage.so: SpSGIImage.o
	$(CC) -shared -o SpSGIImage.so SpSGIImage.o
SpTIFFImage.so: SpTIFFImage.o
	$(CC) -shared -o SpTIFFImage.so SpTIFFImage.o
SpIFFImage.so: SpIFFImage.o
	$(CC) -shared -o SpIFFImage.so SpIFFImage.o
SpFITImage.so: SpFITImage.o
	$(CC) -shared -o SpFITImage.so SpFITImage.o
SpPRMANZImage.so: SpPRMANZImage.o
	$(CC) -shared -o SpPRMANZImage.so SpPRMANZImage.o
SpPRTEXImage.so: SpPRTEXImage.o
	$(CC) -shared -o SpPRTEXImage.so SpPRTEXImage.o
SpGIFImage.so: SpGIFImage.o
	$(CC) -shared -o SpGIFImage.so SpGIFImage.o
SpCINEONImage.so: SpCINEONImage.o
	$(CC) -shared -o SpCINEONImage.so SpCINEONImage.o

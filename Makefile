# $Id$

CC = g++
OPTION = -g
INCLUDE = 

OBJECTS = SpSize.o SpFile.o SpPathString.o SpTime.o \
          SpUid.o SpGid.o SpImage.o SpImageDim.o SpFsObject.o SpDir.o \
		  SpSGIImage.o SpTIFFImage.o SpFITImage.o SpPRMANZImage.o \
		  SpGIFImage.o SpCINEONImage.o SpIFFImage.o SpPRTEXImage.o

all: testCode
	./testCode
	
clean:
	rm -fr ii_files *.o testCode

testCode: testCode.o $(OBJECTS)
	$(CC) $(OPTION) -o testCode testCode.o $(OBJECTS) -lqt

testCode.o: testCode.C SpFile.h SpUid.h SpGid.h SpTime.h SpSize.h SpFsObject.h
	$(CC) $(OPTION) -c testCode.C $(INCLUDE)

SpSize.o: SpSize.C SpSize.h
	$(CC) $(OPTION) -c SpSize.C $(INCLUDE)

SpFile.o: SpFile.C SpFile.h SpPathString.h SpTime.h SpSize.h SpUid.h SpGid.h
	$(CC) $(OPTION) -c SpFile.C $(INCLUDE)

SpPathString.o: SpPathString.C SpPathString.h
	$(CC) $(OPTION) -c SpPathString.C $(INCLUDE)

SpTime.o: SpTime.C SpTime.h
	$(CC) $(OPTION) -c SpTime.C $(INCLUDE)

SpUid.o: SpUid.C SpUid.h
	$(CC) $(OPTION) -c SpUid.C $(INCLUDE)

SpGid.o: SpGid.C SpGid.h
	$(CC) $(OPTION) -c SpGid.C $(INCLUDE)

SpImage.o: SpImage.C SpImage.h SpFile.h
	$(CC) $(OPTION) -c SpImage.C $(INCLUDE)

SpSGIImage.o: SpSGIImage.C SpSGIImage.h SpImage.h
	$(CC) $(OPTION) -c SpSGIImage.C $(INCLUDE)

SpTIFFImage.o: SpTIFFImage.C SpTIFFImage.h SpImage.h
	$(CC) $(OPTION) -c SpTIFFImage.C $(INCLUDE)

SpIFFImage.o: SpIFFImage.C SpIFFImage.h SpImage.h
	$(CC) $(OPTION) -c SpIFFImage.C $(INCLUDE)

SpFITImage.o: SpFITImage.C SpFITImage.h SpImage.h
	$(CC) $(OPTION) -c SpFITImage.C $(INCLUDE)

SpPRMANZImage.o: SpPRMANZImage.C SpPRMANZImage.h SpImage.h
	$(CC) $(OPTION) -c SpPRMANZImage.C $(INCLUDE)

SpPRTEXImage.o: SpPRTEXImage.C SpPRTEXImage.h SpImage.h
	$(CC) $(OPTION) -c SpPRTEXImage.C $(INCLUDE)

SpGIFImage.o: SpGIFImage.C SpGIFImage.h SpImage.h
	$(CC) $(OPTION) -c SpGIFImage.C $(INCLUDE)

SpCINEONImage.o: SpCINEONImage.C SpCINEONImage.h SpImage.h
	$(CC) $(OPTION) -c SpCINEONImage.C $(INCLUDE)

SpImageDim.o: SpImageDim.C SpImageDim.h
	$(CC) $(OPTION) -c SpImageDim.C $(INCLUDE)

SpFsObject.o: SpFsObject.C SpFsObject.h SpTime.h SpPathString.h SpUid.h SpGid.h
	$(CC) $(OPTION) -c SpFsObject.C $(INCLUDE)

SpDir.o: SpDir.C SpDir.h SpFsObject.h
	$(CC) $(OPTION) -c SpDir.C $(INCLUDE)


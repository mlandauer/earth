// $Id$

#include "SpIFFImage.h"

SpIFFImage::SpIFFImage()
{
	// Assume the worst case to start with
	headerRead = false;
	validHeader = false;
}

SpIFFImage::~SpIFFImage()
{
}

SpImageDim SpIFFImage::dim()
{
	readHeader();
	return (SpImageDim(w, h));
}

string SpIFFImage::formatString()
{
	return ("IFF");
}

bool SpIFFImage::valid()
{
	readHeader();
	return (validHeader);
}

void SpIFFImage::readHeader()
{
	if (!headerRead) {
		char chunkTag[4];
		unsigned long chunkSize;
		// Find the chunk with the tag "TBHD"
		// Skip over first chunk that we have checked with the magic cookie
		open();
		seek(12);
		// HACK HACK - Needs proper error checking or it could
		// get stuck in a very nasty loop
		while (!headerRead) {
			read(chunkTag, 4);
			chunkSize = readLong(1);
			if ((chunkTag[0] == 'T') && (chunkTag[1] == 'B') &&
				(chunkTag[2] == 'H') && (chunkTag[3] == 'D')) {
				w = readLong(1);
				h = readLong(1);
				headerRead = true;
			}
			else
				seekForward(chunkSize);
		}
		validHeader = headerRead;
		close();
		
		if (!validHeader) {
			w = 0;
			h = 0;
		}
	}
}

int SpIFFImage::sizeToRecognise()
{
	return (12);
}

bool SpIFFImage::recognise(unsigned char *buf)
{
	if ((buf[0]  == 'F') && (buf[1]  == 'O') &&
		(buf[2]  == 'R') && (buf[3]  == '4') &&
		(buf[8]  == 'C') && (buf[9]  == 'I') &&
		(buf[10] == 'M') && (buf[11] == 'G'))
		return (true);
	else
		return (false);
}

SpImage* SpIFFImage::clone()
{
	return (new SpIFFImage);
}

// $Id$

#include "SpCINEONImage.h"

SpCINEONImage::SpCINEONImage()
{
}

SpCINEONImage::~SpCINEONImage()
{
}

SpImageDim SpCINEONImage::dim()
{
	open();
	seek(192);
	unsigned char orientation = readChar();
	seek(200);
	unsigned long width = readLong(1);
	unsigned long height = readLong(1);
	if (orientation > 3) {
		// Swap width and height
		unsigned long temp = width;
		width = height;
		height = temp;
	}
	close();
	return (SpImageDim(width, height));
}

string SpCINEONImage::formatString()
{
	return (string("Cineon"));
}

bool SpCINEONImage::valid()
{
	return (true);
}

int SpCINEONImage::sizeToRecognise()
{
	return (4);
}

bool SpCINEONImage::recognise(unsigned char *buf)
{
	if ((buf[0] == 0x80) && (buf[1] == 0x2a) &&
		(buf[2] == 0x5f) && (buf[3] == 0xd7))
		return (true);
	else
		return (false);
}

SpImage* SpCINEONImage::clone()
{
	return (new SpCINEONImage);
}

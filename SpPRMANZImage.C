// $Id$

#include "SpPRMANZImage.h"

SpPRMANZImage::SpPRMANZImage()
{
}

SpPRMANZImage::~SpPRMANZImage()
{
}

SpImageDim SpPRMANZImage::dim()
{
	open();
	seek(4);
	unsigned int width = readShort(1);
	unsigned int height = readShort(1);
	close();
	return (SpImageDim(width, height));
}

string SpPRMANZImage::formatString()
{
	return (string("PRMANZ"));
}

bool SpPRMANZImage::valid()
{
	return (true);
}

int SpPRMANZImage::sizeToRecognise()
{
	return (4);
}

bool SpPRMANZImage::recognise(unsigned char *buf)
{
	if ((buf[0] == 0x2f) && (buf[1] == 0x08) &&
		(buf[2] == 0x67) && (buf[3] == 0xab))
		return (true);
	else
		return (false);
}

// $Id$

#include "SpPRMANZImage.h"

SpImageDim SpPRMANZImage::dim()
{
	open();
	seek(4);
	unsigned int width = readShort(1);
	unsigned int height = readShort(1);
	close();
	return (SpImageDim(width, height));
}

bool SpPRMANZImageFormat::recognise(unsigned char *buf)
{
	if ((buf[0] == 0x2f) && (buf[1] == 0x08) &&
		(buf[2] == 0x67) && (buf[3] == 0xab))
		return (true);
	else
		return (false);
}

SpImage* SpPRMANZImageFormat::constructImage()
{
	return (new SpPRMANZImage);
}

// $Id$

#include "SpSGIImage.h"

SpImageDim SpSGIImage::dim()
{
	open();
	seek(6);
	unsigned int width = readShort(1);
	unsigned int height = readShort(1);
	close();
	return (SpImageDim(width, height));
}

bool SpSGIImageFormat::recognise(unsigned char *buf)
{
	if ((buf[0] == 0x01) && (buf[1] == 0xda))
		return (true);
	else
		return (false);
}

SpImage* SpSGIImageFormat::constructImage()
{
	return (new SpSGIImage);
}

static SpSGIImageFormat thisSGIImageFormat;

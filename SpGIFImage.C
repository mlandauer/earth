// $Id$

#include "SpGIFImage.h"

SpImageDim SpGIFImage::dim()
{
	open();
	seek(6);
	unsigned int width = readShort(0);
	unsigned int height = readShort(0);
	close();
	return (SpImageDim(width, height));
}

bool SpGIFImageFormat::recognise(unsigned char *buf)
{
	if ((buf[0] == 'G') && (buf[1] == 'I') &&
		(buf[2] == 'F') && (buf[3] == '8'))
		return (true);
	else
		return (false);
}

SpImage* SpGIFImageFormat::constructImage()
{
	return (new SpGIFImage);
}

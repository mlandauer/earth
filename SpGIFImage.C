// $Id$

#include "SpGIFImage.h"

SpGIFImage::SpGIFImage()
{
}

SpGIFImage::~SpGIFImage()
{
}

SpImageDim SpGIFImage::dim()
{
	open();
	seek(6);
	unsigned int width = readShort(0);
	unsigned int height = readShort(0);
	close();
	return (SpImageDim(width, height));
}

string SpGIFImage::formatString()
{
	return (string("GIF"));
}

bool SpGIFImage::valid()
{
	return (true);
}

int SpGIFImage::sizeToRecognise()
{
	return (4);
}

bool SpGIFImage::recognise(unsigned char *buf)
{
	if ((buf[0] == 'G') && (buf[1] == 'I') &&
		(buf[2] == 'F') && (buf[3] == '8'))
		return (true);
	else
		return (false);
}

SpImage* SpGIFImage::clone()
{
	return (new SpGIFImage);
}

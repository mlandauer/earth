// $Id$

#include "SpSGIImage.h"

SpSGIImage::SpSGIImage()
{
}

SpSGIImage::~SpSGIImage()
{
}

SpImageDim SpSGIImage::dim()
{
	open();
	seek(6);
	unsigned int width = readShort(1);
	unsigned int height = readShort(1);
	close();
	return (SpImageDim(width, height));
}

string SpSGIImage::formatString()
{
	return (string("SGI"));
}

bool SpSGIImage::valid()
{
	return (true);
}

int SpSGIImage::sizeToRecognise()
{
	return (2);
}
	
bool SpSGIImage::recognise(unsigned char *buf)
{
	if ((buf[0] == 0x01) && (buf[1] == 0xda))
		return (true);
	else
		return (false);
}

SpImage* SpSGIImage::clone()
{
	return (new SpSGIImage);
}


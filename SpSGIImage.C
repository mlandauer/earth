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

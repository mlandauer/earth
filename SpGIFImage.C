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

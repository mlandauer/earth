// $Id$

#include "SpGIFImage.h"
#include <stream.h>

SpGIFImage::SpGIFImage()
{
}

SpGIFImage::~SpGIFImage()
{
}

SpImageDim SpGIFImage::dim()
{
	file.seek(6);
	unsigned int width = readShort(0);
	unsigned int height = readShort(0);
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

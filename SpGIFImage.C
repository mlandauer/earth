// $Id$

#include "SpGIFImage.h"
#include <stream.h>

SpGIFImage::SpGIFImage()
{
}

SpGIFImage::~SpGIFImage()
{
}

unsigned int SpGIFImage::width()
{
	file.seek(6);
	return (readShort(0));
}

unsigned int SpGIFImage::height()
{
	file.seek(8);
	return (readShort(0));
}

string SpGIFImage::formatString()
{
	return (string("GIF"));
}

bool SpGIFImage::valid()
{
	return (true);
}

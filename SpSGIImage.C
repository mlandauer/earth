// $Id$

#include "SpSGIImage.h"
#include <stream.h>

SpSGIImage::SpSGIImage()
{
}

SpSGIImage::~SpSGIImage()
{
}

unsigned int SpSGIImage::width() const
{
	file.seek(6);
	return (readShort(1));
}

unsigned int SpSGIImage::height() const
{
	file.seek(8);
	return (readShort(1));
}

string SpSGIImage::formatString() const
{
	return (string("SGI"));
}

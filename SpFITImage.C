// $Id$

#include "SpFITImage.h"
#include <stream.h>

SpFITImage::SpFITImage()
{
}

SpFITImage::~SpFITImage()
{
}

SpImageDim SpFITImage::dim()
{
	open();
	seek(4);
	unsigned int width = readLong(1);
	unsigned int height = readLong(1);
	close();
	return (SpImageDim(width, height));
}

string SpFITImage::formatString()
{
	return (string("FIT"));
}

bool SpFITImage::valid()
{
	return (true);
}

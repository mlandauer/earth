// $Id$

#include "SpFITImage.h"
#include <stream.h>

SpFITImage::SpFITImage()
{
}

SpFITImage::~SpFITImage()
{
}

unsigned int SpFITImage::width()
{
	file.seek(4);
	return (readLong(1));
}

unsigned int SpFITImage::height()
{
	file.seek(8);
	return (readLong(1));
}

string SpFITImage::formatString()
{
	return (string("FIT"));
}

bool SpFITImage::valid()
{
	return (true);
}

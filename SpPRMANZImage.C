// $Id$

#include "SpPRMANZImage.h"

SpPRMANZImage::SpPRMANZImage()
{
}

SpPRMANZImage::~SpPRMANZImage()
{
}

SpImageDim SpPRMANZImage::dim()
{
	file.seek(4);
	unsigned int width = readShort(1);
	unsigned int height = readShort(1);
}

string SpPRMANZImage::formatString()
{
	return (string("PRMANZ"));
}

bool SpPRMANZImage::valid()
{
	return (true);
}

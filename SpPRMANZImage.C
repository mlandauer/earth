// $Id$

#include "SpPRMANZImage.h"
#include <stream.h>

SpPRMANZImage::SpPRMANZImage()
{
}

SpPRMANZImage::~SpPRMANZImage()
{
}

unsigned int SpPRMANZImage::width()
{
	file.seek(4);
	return (readShort(1));
}

unsigned int SpPRMANZImage::height()
{
	file.seek(6);
	return (readShort(1));
}

string SpPRMANZImage::formatString()
{
	return (string("PRMANZ"));
}

bool SpPRMANZImage::valid()
{
	return (true);
}

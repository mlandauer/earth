// $Id$

#include <math.h>

#include "SpPRTEXImage.h"

SpPRTEXImage::SpPRTEXImage()
{
}

SpPRTEXImage::~SpPRTEXImage()
{
}

SpImageDim SpPRTEXImage::dim()
{
	open();
	seek(13);
	unsigned int width = (unsigned int) pow(2, readChar());
	seekForward(1);
	unsigned int height = (unsigned int) pow(2, readChar());
	close();
	return (SpImageDim(width, height));
}

string SpPRTEXImage::formatString()
{
	return (string("PRTEX"));
}

bool SpPRTEXImage::valid()
{
	return (true);
}

int SpPRTEXImage::sizeToRecognise()
{
	return (4);
}

bool SpPRTEXImage::recognise(unsigned char *buf)
{
	if ((buf[0] == 0xce) && (buf[1] == 0xfa) &&
		(buf[2] == 0x03) && (buf[3] == 0x00))
		return (true);		
	else if ((buf[0] == 0xfa) && (buf[1] == 0xce) &&
		(buf[2] == 0x00) && (buf[3] == 0x03))
		return (true);
	else
		return (false);
}

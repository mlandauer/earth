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

int SpFITImage::sizeToRecognise()
{
	return (4);
}

bool SpFITImage::recognise(unsigned char *buf)
{
	if ((buf[0] == 'I') && (buf[1] == 'T') &&
		(buf[2] == '0') && (buf[3] == '1'))
		return (true);		
	else if ((buf[0] == 'I') && (buf[1] == 'T') &&
		(buf[2] == '0') && (buf[3] == '2'))
		return (true);
	else
		return (false);
}

SpImage* SpFITImage::clone()
{
	return (new SpFITImage);
}

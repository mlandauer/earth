// $Id$

#include "SpGIFImage.h"

SpGIFImage::SpGIFImage()
{
	cout << "SpGIFImage constructor" << endl;
}

SpGIFImage::~SpGIFImage()
{
	cout << "SpGIFImage destructor" << endl;
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

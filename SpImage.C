// $Id$

#include "SpImage.h"

SpImage* SpImage::construct(const SpPath &path)
{
	SpImageFormat *format = SpImageFormat::recogniseByMagic(path);
	if (format) {
		SpImage* image = format->constructImage();
		image->format = format;
		image->setPath(path);
		return (image);
	}
	else
		return (NULL);
}




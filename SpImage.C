// $Id$

#include <stream.h>

#include "SpImage.h"
#include "SpSGIImage.h"
#include "SpTIFFImage.h"
#include "SpIFFImage.h"
#include "SpFITImage.h"
#include "SpPRMANZImage.h"
#include "SpGIFImage.h"
#include "SpCINEONImage.h"
#include "SpPRTEXImage.h"

list<SpImageFormat *> SpImage::plugins;

// Register all the supported image types
void SpImage::registerPlugins()
{
	// Construct one of every image type. This is all leading up
	// to some kind of nice plugin architecture
	plugins.push_back(new SpTIFFImageFormat);
	plugins.push_back(new SpIFFImageFormat);
	plugins.push_back(new SpSGIImageFormat);
	plugins.push_back(new SpFITImageFormat);
	plugins.push_back(new SpGIFImageFormat);
	plugins.push_back(new SpPRMANZImageFormat);
	plugins.push_back(new SpCINEONImageFormat);
	plugins.push_back(new SpPRTEXImageFormat);
}

void SpImage::deRegisterPlugins()
{
	// Iterate through all the objects and destroy
	for (list<SpImageFormat *>::iterator a = plugins.begin();
		a != plugins.end(); ++a)
		delete (*a);
}

SpImage* SpImage::construct(const SpPath &path)
{
	// Figure out what the greatest amount of the header that needs
	// to be read so that all the plugins can recognise themselves.
	int largestSizeToRecognise = 0;
	for (list<SpImageFormat *>::iterator a = plugins.begin();
		a != plugins.end(); ++a)
		if ((*a)->sizeToRecognise() > largestSizeToRecognise)
			largestSizeToRecognise = (*a)->sizeToRecognise();
			
	// Create a temporary file object
	unsigned char *buf = new unsigned char[largestSizeToRecognise];
	SpFile f(path);
	f.open();
	f.read(buf, largestSizeToRecognise);
	f.close();
	
	// See if any of the plugins recognise themselves.
	for (list<SpImageFormat *>::iterator a = plugins.begin();
		a != plugins.end(); ++a)
		if ((*a)->recognise(buf)) {
			SpImage* image = (*a)->constructImage();
			image->format = *a;
			image->setPath(path);
			delete buf;
			return (image);
		}
	// This signals an error or an unrecognised image type
	delete buf;
	return (NULL);
}




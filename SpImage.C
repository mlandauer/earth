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

list<SpImageFormat *> SpImageFormat::plugins;

SpImageFormat::SpImageFormat()
{
	addPlugin(this);
}

SpImageFormat::~SpImageFormat()
{
	removePlugin(this);
}

// Register all the supported image types
void SpImageFormat::registerPlugins()
{
	// Construct one of every image type. This is all leading up
	// to some kind of nice plugin architecture
	new SpTIFFImageFormat;
	new SpIFFImageFormat;
	new SpSGIImageFormat;
	new SpFITImageFormat;
	new SpGIFImageFormat;
	new SpPRMANZImageFormat;
	new SpCINEONImageFormat;
	new SpPRTEXImageFormat;
}

void SpImageFormat::addPlugin(SpImageFormat *plugin)
{
	plugins.push_back(plugin);
}

void SpImageFormat::removePlugin(SpImageFormat *plugin)
{
	plugins.remove(plugin);
}

void SpImageFormat::deRegisterPlugins()
{
}

SpImage* SpImage::construct(const SpPath &path)
{
	list<SpImageFormat *> plugins = SpImageFormat::getPlugins();
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




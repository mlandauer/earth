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

list<SpImage *> SpImage::plugins;

// Register all the supported image types
void SpImage::registerPlugins()
{
	// Construct one of every image type. This is all leading up
	// to some kind of nice plugin architecture
	plugins.push_back(new SpTIFFImage);
	plugins.push_back(new SpIFFImage);
	plugins.push_back(new SpSGIImage);
	plugins.push_back(new SpFITImage);
	plugins.push_back(new SpGIFImage);
	plugins.push_back(new SpPRMANZImage);
	plugins.push_back(new SpCINEONImage);
	plugins.push_back(new SpPRTEXImage);
}

void SpImage::deRegisterPlugins()
{
	// Iterate through all the objects and destroy
	for (list<SpImage *>::iterator a = plugins.begin();
		a != plugins.end(); ++a)
		delete (*a);
}

SpImage* SpImage::construct(const string &path)
{
	// Figure out what the greatest amount of the header that needs
	// to be read so that all the plugins can recognise themselves.
	int largestSizeToRecognise = 0;
	for (list<SpImage *>::iterator a = plugins.begin();
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
	for (list<SpImage *>::iterator a = plugins.begin();
		a != plugins.end(); ++a)
		if ((*a)->recognise(buf)) {
			SpImage* image = (*a)->clone();
			image->setPath(path);
			delete buf;
			return (image);
		}
	// This signals an error or an unrecognised image type
	delete buf;
	return (NULL);
}

unsigned char SpImage::readChar() const
{
	unsigned char value;
	read(&value, 1);
	return (value);
}

unsigned short SpImage::readShort(const int &endian) const
{
	unsigned short value;
	unsigned char temp[2];
	read(temp, 2);

	// If small endian
	if (endian == 0)
		value = (temp[0]<<0) + (temp[1]<<8);
	else
		value = (temp[0]<<8) + (temp[1]<<0);
	return (value);
}

unsigned long SpImage::readLong(const int &endian) const
{
	unsigned char temp[4];
	read(temp, 4);

	unsigned long value;
	if (endian == 0)
		value = (temp[0]<<0) + (temp[1]<<8) + (temp[2]<<16) + (temp[3]<<24);
	else
		value = (temp[0]<<24) + (temp[1]<<16) + (temp[2]<<8) + (temp[3]<<0);
	return (value);
}
  




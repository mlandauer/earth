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

SpImage* SpImage::construct(const string &path)
{
	
	// Figure out what the image type is by reading the first twelve bytes
	// of the file.
	unsigned char buf[12];
	
	// Create a temporary file object
	SpFile f(path);
	f.open();
	f.read(buf, 12);
	f.close();
	
	SpImage* image;
	
	// Construct one of every image type. This is all leading up
	// to some kind of nice plugin architecture
	SpTIFFImage tiffImage;
	SpIFFImage iffImage;
	SpSGIImage sgiImage;
	SpFITImage fitImage;
	SpGIFImage gifImage;
	SpPRMANZImage prmanzImage;
	SpCINEONImage cineonImage;
	SpPRTEXImage prtexImage;
	
	if (cineonImage.recognise(buf))
		image = cineonImage.clone();
		
	else if (tiffImage.recognise(buf))
		image = tiffImage.clone();
		
	else if (sgiImage.recognise(buf))
		image = sgiImage.clone();
		
	else if (iffImage.recognise(buf))
		image = iffImage.clone();
		
	else if (fitImage.recognise(buf))
		image = fitImage.clone();
		
	else if (gifImage.recognise(buf))
		image = gifImage.clone();

	else if (prmanzImage.recognise(buf))
		image = prmanzImage.clone();

	else if (prtexImage.recognise(buf))
		image = prtexImage.clone();
	else
		// This signals an error or an unrecognised image type
		return (NULL);

	image->setPath(path);
	return (image);
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
  




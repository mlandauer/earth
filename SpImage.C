// $Id$

#include <stream.h>

#include "SpImage.h"
#include "SpSGIImage.h"
#include "SpTIFFImage.h"
#include "SpFITImage.h"
#include "SpPRMANZImage.h"
#include "SpGIFImage.h"

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
	SpSGIImage sgiImage;
	SpFITImage fitImage;
	SpGIFImage gifImage;
	SpPRMANZImage prmanzImage;
	
	if ((buf[0] == 0x80) && (buf[1] == 0x2a) &&
		(buf[2] == 0x5f) && (buf[3] == 0xd7))
		cout << "Cineon" << endl;
		
	else if (tiffImage.recognise(buf))
		image = new SpTIFFImage;
		
	else if (sgiImage.recognise(buf))
		image = new SpSGIImage;
		
	else if ((buf[0]  == 'F') && (buf[1]  == 'O') &&
		(buf[2]  == 'R') && (buf[3]  == '4') &&
		(buf[8]  == 'C') && (buf[9]  == 'I') &&
		(buf[10] == 'M') && (buf[11] == 'G'))
		cout << "IFF" << endl;
		
	else if (fitImage.recognise(buf))
		image = new SpFITImage;
		
	else if (gifImage.recognise(buf))
		image = new SpGIFImage;

	else if (prmanzImage.recognise(buf))
		image = new SpPRMANZImage;

	else if ((buf[0] == 0xce) && (buf[1] == 0xfa) &&
		(buf[2] == 0x03) && (buf[3] == 0x00))
		cout << "PRTEX" << endl;
		
	else if ((buf[0] == 0xfa) && (buf[1] == 0xce) &&
		(buf[2] == 0x00) && (buf[3] == 0x03))
		cout << "PRTEX" << endl;
	else
		cout << "I don't know what's going on here!" << endl;

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
  




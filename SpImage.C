// $Id$

#include <stream.h>

#include "SpImage.h"
#include "SpSGIImage.h"
#include "SpTIFFImage.h"
#include "SpFITImage.h"

SpImage::SpImage()
{
}

SpImage::~SpImage()
{
}

SpImage* SpImage::open(SpFile f)
{
	f.open();
	
	// Figure out what the image type is
	unsigned char buf[12];
	// Read first twelve bytes of the file
	f.read(buf, 12);
	
	SpImage* image;
	
	if ((buf[0] == 0x80) && (buf[1] == 0x2a) &&
		(buf[2] == 0x5f) && (buf[3] == 0xd7))
		cout << "Cineon" << endl;
	else if ((buf[0] == 'I') && (buf[1] == 'I') &&
		(buf[2] == 0x2a) && (buf[3] == 0x00)) {
		image = new SpTIFFImage;
		image->file = f;
		return (image);
	}
	else if ((buf[0] == 'M') && (buf[1] == 'M') &&
		(buf[2] == 0x00) && (buf[3] == 0x2a)) {
		image = new SpTIFFImage;
		image->file = f;
		return (image);
	}
	else if ((buf[0] == 0x01) && (buf[1] == 0xda)) {
		image = new SpSGIImage;
		image->file = f;
		return (image);
	}
	else if ((buf[0]  == 'F') && (buf[1]  == 'O') &&
		(buf[2]  == 'R') && (buf[3]  == '4') &&
		(buf[8]  == 'C') && (buf[9]  == 'I') &&
		(buf[10] == 'M') && (buf[11] == 'G'))
		cout << "IFF" << endl;
	else if ((buf[0] == 'I') && (buf[1] == 'T') &&
		(buf[2] == '0') && (buf[3] == '1')) {
		image = new SpFITImage;
		image->file = f;
		return (image);
	}
	else if ((buf[0] == 'I') && (buf[1] == 'T') &&
		(buf[2] == '0') && (buf[3] == '2')) {
		image = new SpFITImage;
		image->file = f;
		return (image);
	}
	else if ((buf[0] == 'G') && (buf[1] == 'I') &&
		(buf[2] == 'F') && (buf[3] == '8'))
		cout << "GIF" << endl;
	else if ((buf[0] == 0x2f) && (buf[1] == 0x08) &&
		(buf[2] == 0x67) && (buf[3] == 0xab))
		cout << "PRMANZ" << endl;
	else if ((buf[0] == 0xce) && (buf[1] == 0xfa) &&
		(buf[2] == 0x03) && (buf[3] == 0x00))
		cout << "PRTEX" << endl;
	else if ((buf[0] == 0xfa) && (buf[1] == 0xce) &&
		(buf[2] == 0x00) && (buf[3] == 0x03))
		cout << "PRTEX" << endl;
}

unsigned char SpImage::readChar() const
{
	unsigned char value;
	file.read(&value, 1);
	return (value);
}

unsigned short SpImage::readShort(const int &endian) const
{
	unsigned short value;
	unsigned char temp[2];
	file.read(temp, 2);

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
	file.read(temp, 4);

	unsigned long value;
	if (endian == 0)
		value = (temp[0]<<0) + (temp[1]<<8) + (temp[2]<<16) + (temp[3]<<24);
	else
		value = (temp[0]<<24) + (temp[1]<<16) + (temp[2]<<8) + (temp[3]<<0);
	return (value);
}
  




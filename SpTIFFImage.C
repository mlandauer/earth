// $Id$

#include "SpTIFFImage.h"
#include <stream.h>

SpTIFFImage::SpTIFFImage()
{
	// Assume the worst case to start with
	headerRead = false;
	validHeader = false;
}

SpTIFFImage::~SpTIFFImage()
{
}

unsigned int SpTIFFImage::width()
{
	readHeader();
	if (validHeader)
		return (w);
	else
		return (0);
}

unsigned int SpTIFFImage::height()
{
	readHeader();
	if (validHeader)
		return (h);
	else
		return (0);
}

string SpTIFFImage::formatString()
{
	readHeader();
	if (validHeader)
		return ("TIFF");
	else
		return ("Unknown");
}

bool SpTIFFImage::valid()
{
	readHeader();
	return (validHeader);
}

void SpTIFFImage::readHeader()
{
	if (!headerRead) {
		headerRead = true;
		unsigned char endian;
		file.seek(0);
		endian = readChar();
		// 'I' means that everything is stored little endian
		// otherwise it's big endian
		if (endian == 'I')
			endian = 0;
		else
			endian = 1;

		file.seek(4);
		unsigned long offset = readLong(endian);

		// If the offset is too small there's a problem and this
		// tiff is invalid
		if (offset < 4) {
			validHeader = false;
			return;
		}

		// This is a hack to deal with certain TIFFs that have
		// been incorrectly written

		if (offset != 0)
			file.seek(offset);

		unsigned short noEntries = readShort(endian);

		bool foundWidth = false;
		bool foundHeight = false;          
	
		int count = 0;

		do {
			unsigned short fieldType = readShort(endian);
			unsigned short fieldPrecision = readShort(endian);
			file.seekForward(4);
			if (fieldType == 0x0100) {
				// Field is Image Width
				foundWidth = true;
				if (fieldPrecision == 0x0003) {
					w = readShort(endian);
					file.seekForward(2);
				}
				else if (fieldPrecision == 0x0004)
					w = readLong(endian);
				else
					file.seekForward(4);
			}
			else if (fieldType == 0x0101) {
				// Field is Image Height
				foundHeight = true;
				if (fieldPrecision == 0x0003) {
					h = readShort(endian);
					file.seekForward(2);
				}
				else if (fieldPrecision == 0x0004)
					h = readLong(endian);
				else
					file.seekForward(4);
			}
			// skip the rest of the field (it should be 12 bytes long)
			else
				file.seekForward(4);
			count++;
		} while ((!(foundWidth && foundHeight)) && (count < noEntries));
	
		if (foundWidth && foundHeight)
			// Mark the header as successfully read
			validHeader = true;
		else
			validHeader = false;
	}
}


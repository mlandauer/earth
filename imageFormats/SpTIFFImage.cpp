//  Copyright (C) 2001 Matthew Landauer. All Rights Reserved.
//  
//  This program is free software; you can redistribute it and/or modify it
//  under the terms of version 2 of the GNU General Public License as
//  published by the Free Software Foundation.
//
//  This program is distributed in the hope that it would be useful, but
//  WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  Further, any
//  license provided herein, whether implied or otherwise, is limited to
//  this program in accordance with the express provisions of the GNU
//  General Public License.  Patent licenses, if any, provided herein do not
//  apply to combinations of this program with other product or programs, or
//  any other product whatsoever.  This program is distributed without any
//  warranty that the program is delivered free of the rightful claim of any
//  third person by way of infringement or the like.  See the GNU General
//  Public License for more details.
//
//  You should have received a copy of the GNU General Public License along
//  with this program; if not, write the Free Software Foundation, Inc., 59
//  Temple Place - Suite 330, Boston MA 02111-1307, USA.
//
// $Id$

#include "SpTIFFImage.h"
#include <stream.h>

SpImageDim SpTIFFImage::dim()
{
	readHeader();
	if (validHeader)
		return (SpImageDim(w, h));
	else
		return (SpImageDim(0, 0));
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
		open();
		seek(0);
		unsigned char endian = readChar();
		// 'I' means that everything is stored little endian
		// otherwise it's big endian
		if (endian == 'I')
			endian = 0;
		else
			endian = 1;

		seek(4);
		unsigned long offset = readLong(endian);

		// If the offset is too small there's a problem and this
		// tiff is invalid
		if (offset < 4) {
			validHeader = false;
			close();
			return;
		}

		// This is a hack to deal with certain TIFFs that have
		// been incorrectly written

		if (offset != 0)
			seek(offset);

		unsigned short noEntries = readShort(endian);

		bool foundWidth = false;
		bool foundHeight = false;          
	
		int count = 0;

		do {
			unsigned short fieldType = readShort(endian);
			unsigned short fieldPrecision = readShort(endian);
			seekForward(4);
			if (fieldType == 0x0100) {
				// Field is Image Width
				foundWidth = true;
				if (fieldPrecision == 0x0003) {
					w = readShort(endian);
					seekForward(2);
				}
				else if (fieldPrecision == 0x0004)
					w = readLong(endian);
				else
					seekForward(4);
			}
			else if (fieldType == 0x0101) {
				// Field is Image Height
				foundHeight = true;
				if (fieldPrecision == 0x0003) {
					h = readShort(endian);
					seekForward(2);
				}
				else if (fieldPrecision == 0x0004)
					h = readLong(endian);
				else
					seekForward(4);
			}
			// skip the rest of the field (it should be 12 bytes long)
			else
				seekForward(4);
			count++;
		} while ((!(foundWidth && foundHeight)) && (count < noEntries));
	
		if (foundWidth && foundHeight)
			// Mark the header as successfully read
			validHeader = true;
		else
			validHeader = false;
		close();
	}
}

bool SpTIFFImageFormat::recognise(unsigned char *buf)
{
	if ((buf[0] == 'I') && (buf[1] == 'I') &&
		(buf[2] == 0x2a) && (buf[3] == 0x00))
		return (true);
	else if ((buf[0] == 'M') && (buf[1] == 'M') &&
		(buf[2] == 0x00) && (buf[3] == 0x2a))
		return (true);
	else
		return (false);
}

SpImage* SpTIFFImageFormat::constructImage()
{
	return (new SpTIFFImage);
}

static SpTIFFImageFormat thisTIFFImageFormat;


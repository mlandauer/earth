//  Copyright (C) 2001-2003 Matthew Landauer. All Rights Reserved.
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

#include "IFFImage.h"

namespace Sp {

ImageDim IFFImage::getDim() const
{
	readHeader();
	return (ImageDim(w, h));
}

bool IFFImage::valid() const
{
	readHeader();
	return (validHeader);
}

void IFFImage::readHeader() const
{
	if (!headerRead) {
		char chunkTag[4];
		unsigned long chunkSize;
		// Find the chunk with the tag "TBHD"
		// Skip over first chunk that we have checked with the magic cookie
		open();
		seek(12);
		// HACK HACK - Needs proper error checking or it could
		// get stuck in a very nasty loop
		while (!headerRead) {
			read(chunkTag, 4);
			chunkSize = readLong(1);
			if ((chunkTag[0] == 'T') && (chunkTag[1] == 'B') &&
				(chunkTag[2] == 'H') && (chunkTag[3] == 'D')) {
				w = readLong(1);
				h = readLong(1);
				headerRead = true;
			}
			else
				seekForward(chunkSize);
		}
		validHeader = headerRead;
		close();
		
		if (!validHeader) {
			w = 0;
			h = 0;
		}
	}
}

bool IFFImageFormat::recognise(unsigned char *buf)
{
	if ((buf[0]  == 'F') && (buf[1]  == 'O') &&
		(buf[2]  == 'R') && (buf[3]  == '4') &&
		(buf[8]  == 'C') && (buf[9]  == 'I') &&
		(buf[10] == 'M') && (buf[11] == 'G'))
		return (true);
	else
		return (false);
}

Image* IFFImageFormat::constructImage()
{
	return (new IFFImage);
}

static IFFImageFormat thisIFFImageFormat;

}

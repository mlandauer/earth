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

#include "SpCINEONImage.h"

SpImageDim SpCINEONImage::dim()
{
	open();
	seek(192);
	unsigned char orientation = readChar();
	seek(200);
	unsigned long width = readLong(1);
	unsigned long height = readLong(1);
	if (orientation > 3) {
		// Swap width and height
		unsigned long temp = width;
		width = height;
		height = temp;
	}
	close();
	return (SpImageDim(width, height));
}

bool SpCINEONImageFormat::recognise(unsigned char *buf)
{
	if ((buf[0] == 0x80) && (buf[1] == 0x2a) &&
		(buf[2] == 0x5f) && (buf[3] == 0xd7))
		return (true);
	else
		return (false);
}

SpImage* SpCINEONImageFormat::constructImage()
{
	return (new SpCINEONImage);
};

static SpCINEONImageFormat thisCINEONImageFormat;


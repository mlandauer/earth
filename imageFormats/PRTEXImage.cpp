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

#include <math.h>

#include "PRTEXImage.h"

namespace Sp {

bool PRTEXImage::valid()
{
	return (sizeBytes() >= 15);
};

ImageDim PRTEXImage::dim()
{
	open();
	seek(13);
	unsigned int width = (unsigned int) pow(2, readChar());
	seekForward(1);
	unsigned int height = (unsigned int) pow(2, readChar());
	close();
	return (ImageDim(width, height));
}

bool PRTEXImageFormat::recognise(unsigned char *buf)
{
	if ((buf[0] == 0xce) && (buf[1] == 0xfa) &&
		(buf[2] == 0x03) && (buf[3] == 0x00))
		return (true);		
	else if ((buf[0] == 0xfa) && (buf[1] == 0xce) &&
		(buf[2] == 0x00) && (buf[3] == 0x03))
		return (true);
	else
		return (false);
}

Image* PRTEXImageFormat::constructImage()
{
	return (new PRTEXImage);
}

PRTEXImageFormat thisPRTEXImageFormat;

}

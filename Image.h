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

#ifndef _image_h_
#define _image_h_

#include <list>

#include "File.h"
#include "ImageDim.h"
#include "ImageFormat.h"

namespace Sp {

//! Support simple operations on an image
class Image : public File
{
public:
	//! Construct an image object from a path to a file
	/*!
		This recognises the image format of the file and returns a pointer to a new instance
		of the relevant subclassed image class. This should always be used to construct an
		image object rather than calling the constructor directly on the subclassed image class.
	*/
	static Image* construct(const Path &path);
	//! Load all the image format plugins
	static void registerPlugins();
	//! Unload all the image format plugins
	static void deRegisterPlugins();
	//! Return the dimensions (width and height) of the image
	virtual ImageDim dim() = 0;
	//! Is this a valid file in this format?
	/*!
		As the image constructing in construct() is done by recognising the image format from a
		magic number, there is a possibility that the magic number corresponds to a particular image
		format but that the image is incorrectly written. This method checks whether the whole image
		header is valid.
	*/
	virtual bool valid() = 0;
	std::string formatString() { return getFormat()->formatString(); };
	ImageFormat* getFormat() { return format; };
	
private:
	ImageFormat *format;
};

}

#endif

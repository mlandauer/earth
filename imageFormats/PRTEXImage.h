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

#ifndef _prteximage_h_
#define _prteximage_h_

#include "Image.h"
#include "ImageFormat.h"
#include "ImageDim.h"

namespace Sp {

//! Properties of the PRTEX image format
/*!
  This is the image format used by Pixar's Photorealistic Renderman (PRMAN) for storing
  texture maps.
*/
class PRTEXImageFormat: public ImageFormat
{
	public:
		virtual Image* constructImage();
		virtual bool recognise(unsigned char *buf);
		virtual int getSizeToRecognise() { return 4; };
		virtual std::string getFormatString() { return "PRTEX"; }
};

//! Support operations on a PRTEX format image
/*!
  For a description of the PRTEX format see PRTEXImageFormat
*/
class PRTEXImage : public Image
{
	public:
		PRTEXImage() { };
		~PRTEXImage() { };
		ImageDim getDim();
		bool valid();
	private:
};

}

#endif

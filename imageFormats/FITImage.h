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

#ifndef _fitimage_h_
#define _fitimage_h_

#include "Image.h"
#include "ImageFormat.h"
#include "ImageDim.h"

namespace Sp {

//! Properties of the FIT image format
/*!
  To quote from the Silicon Graphics website: "The FIT format was created by the IL group
  as a programming example for adding your own format. Unfortunately it has taken on a life
  of its own and some people want to know how to write software for other packages to read it.
  This is not encouraged and thus we aren't very forthcoming on the details..."
*/
class FITImageFormat: public ImageFormat
{
	public:
		virtual Image* constructImage();
		virtual bool recognise(unsigned char *buf);
		virtual int getSizeToRecognise() { return 4; };
		virtual std::string getFormatString() { return "FIT"; }
};

//! Support operations on a FIT format image
/*!
  For a description of the FIT format see FITImageFormat
*/
class FITImage : public Image
{
	public:
		FITImage() { };
		~FITImage() { };
		ImageDim getDim() const;
		bool valid() const;
	private:
};

}

#endif

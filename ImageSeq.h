//  Copyright (C) 2001, 2002 Matthew Landauer. All Rights Reserved.
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

#ifndef _imageseq_h_
#define _imageseq_h_

#include <set>
#include "Image.h"

namespace Sp {

class ImageSeq
{
	public:
		ImageSeq(Image *i);
		void addImage(Image *i);
		void removeImage(Image *i);
		void removeImage(const Path &p);
		Path path() const;
		std::string framesString() const;
		ImageDim dim() const { return dimensions; };
		ImageFormat* format() const { return imageFormat; };
	private:
		std::set<int> f;
		Path p;
		Path pattern(const Path &a) const;
		int frameNumber(const Path &a) const;
		std::string hash(int size) const;
		bool couldBePartOfSequence(Image *i) const;
		bool partOfSequence(Image *i) const;
		bool partOfSequence(const Path &p) const;
		// Image/Sequence attributes
		ImageFormat *imageFormat;
		ImageDim dimensions;
};

}

#endif

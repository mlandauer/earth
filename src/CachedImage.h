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
// $Id: CachedImage.h,v 1.2 2003/02/03 05:01:58 mlandauer Exp $

#ifndef _SP_CACHED_IMAGE_H_
#define _SP_CACHED_IMAGE_H_

#include "CachedFile.h"
#include "ImageDim.h"
#include <string>
#include "ImageFormat.h"
#include "Image.h"

namespace Sp {

class CachedImage : public CachedFile
{
public:
	CachedImage(const Image *image) : CachedFile(*image) {
		m_dim = image->getDim();
		m_valid = image->valid();
		m_format = image->getFormat();
	}
	//! Constructor useful for testing purposes
	CachedImage(const ImageDim &dim, bool valid, ImageFormat* format, long int sizeBytes,
		const DateTime &lastChange, const User &user, const UserGroup &userGroup,
		const Path &path)
		: CachedFile(sizeBytes, lastChange, user, userGroup, path),
			m_dim(dim), m_valid(valid), m_format(format) { }
	
	ImageDim getDim() const { return m_dim; }
	bool valid() const { return m_valid; }
	std::string getFormatString() const { return m_format->getFormatString(); }
	ImageFormat* getFormat() const { return m_format; }
	
private:
	ImageDim m_dim;
	bool m_valid;
	ImageFormat *m_format;
};

}

#endif

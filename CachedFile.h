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
//

#ifndef _SP_CACHED_FILE_H_
#define _SP_CACHED_FILE_H_

#include "CachedFsObject.h"
#include "Size.h"
#include "File.h"

namespace Sp {

class CachedFile : public CachedFsObject
{
public:
	CachedFile(const File &file) : CachedFsObject(file) {
		m_size = file.getSize();
		m_sizeBytes = file.getSizeBytes();
	}
	//! Constructor useful for testing purposes
	CachedFile(long int sizeBytes, const DateTime &lastChange, const User &user, const UserGroup &userGroup,
		const Path &path)
		: CachedFsObject(lastChange, user, userGroup, path),
			m_size(Size::Bytes((float) sizeBytes)), m_sizeBytes(sizeBytes) { }

	//! Returns the file size
	Size getSize() const { return m_size; }

	//! Returns the file size in bytes
	long int getSizeBytes() const { return m_sizeBytes; }
	
private:
	Size m_size;
	long int m_sizeBytes;
};

}

#endif

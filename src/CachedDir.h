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
// $Id: CachedDir.h,v 1.5 2003/01/29 00:37:50 mlandauer Exp $

#ifndef _CACHEDDIR_H_
#define _CACHEDDIR_H_

#include "Dir.h"
#include "File.h"
#include "CachedFsObject.h"

namespace Sp {
	
class CachedDir : public CachedFsObject
{
public:
	CachedDir(const Dir &dir);
	
	//! Returns all the files in this directory
	std::vector<File> listFiles(bool sortByPath = false) const;
	//! Returns all the directories immediately under this directory
	std::vector<Dir> listDirs(bool sortByPath = false) const;
	
private:
	mutable std::vector<File> files;
	mutable std::vector<Dir> dirs;
	mutable bool filesSorted, dirsSorted;
};

}

#endif

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

#include <algorithm>
#include "CachedDir.h"

namespace Sp {
	
CachedDir::CachedDir(const Dir &d) : dir(d), filesSorted(false), dirsSorted(false)
{
	// Really the following should be an automatic operation
	// By default making the lists sorted
	files = dir.listFiles(false);
	dirs = dir.listDirs(false);
	change = dir.lastChange();
}

std::vector<File> CachedDir::listFiles(bool sortByPath) const
{
	if (sortByPath && !filesSorted) {
		std::sort(files.begin(), files.end());
		filesSorted = true;
	}
	return files;
}

std::vector<Dir> CachedDir::listDirs(bool sortByPath) const
{
	if (sortByPath && !dirsSorted) {
		std::sort(dirs.begin(), dirs.end());
		dirsSorted = true;
	}
	return dirs;
}

DateTime CachedDir::lastChange() const
{
	return change;
}

Dir CachedDir::getDir() const
{
	return dir;
}

}


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

#include "SpDir.h"
#include "SpFile.h"

#include <list>
#include <algorithm>
#include <sys/types.h>
#include <dirent.h>
#include <sys/stat.h>
#include <unistd.h>

#include "SpFsObject.h"

bool Dir::sortByPath = false;

bool Dir::valid() const
{
	struct stat fileStat;
	int ret = lstat(path().fullName().c_str(), &fileStat);
	if (ret == 0)
		return(S_ISDIR(fileStat.st_mode));
	else
		return false;
}

class CompareFsObjectPaths
{
	public:
		bool operator()(FsObjectHandle s1, FsObjectHandle s2) const
			{ return s1->path() < s2->path(); }
};

std::vector<FsObjectHandle> Dir::ls() const
{
	std::vector<FsObjectHandle> l;
	if (!valid())
		return l;
	// First open a directory stream
	DIR *d = opendir(path().fullName().c_str());
	struct dirent *entry;
	while ((entry = readdir(d)) != NULL) {
		std::string pathString = entry->d_name;
		if ((pathString != ".") && (pathString != "..")) {
			Path p = path();
			p.add(pathString);
			l.push_back(FsObject::construct(p));
		}
	}
	closedir(d);
	if (sortByPath)
		sort(l.begin(), l.end(), CompareFsObjectPaths());
	return (l);
}

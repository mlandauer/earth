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

#include <sys/types.h>
#include <dirent.h>
#include <sys/stat.h>
#include <unistd.h>

#include <list>
#include <algorithm>

#include "Dir.h"
#include "File.h"
#include "FsObject.h"

namespace Sp {

Dir::Dir(const Path &path) : FsObject(path)
{
}

bool Dir::valid() const
{
	struct stat fileStat;
	int ret = lstat(getPath().getFullName().c_str(), &fileStat);
	if (ret == 0)
		return(S_ISDIR(fileStat.st_mode));
	else
		return false;
}

std::vector<File> Dir::listFiles(bool sortByPath) const
{
	std::vector<File> l;
  std::vector<Path> paths = listPaths(sortByPath);

  for (std::vector<Path>::iterator i = paths.begin(); i != paths.end(); ++i) {
    File f(*i);
    if (f.valid())
      l.push_back(f);
  }
  return l;
}

std::vector<File> Dir::listFilesRecursive(bool sortByPath) const
{
	std::vector<File> l = listFiles(sortByPath);
	std::vector<Dir> d = listDirs(sortByPath);
	// My use of STL will improve!
	for (std::vector<Dir>::iterator i = d.begin(); i != d.end(); ++i) {
		std::vector<File> l2 = i->listFilesRecursive(sortByPath);
		for (std::vector<File>::iterator j = l2.begin(); j != l2.end(); ++j) {
			l.push_back(*j);
		}
	}
	return l;
}

std::vector<Dir> Dir::listDirs(bool sortByPath) const
{
	std::vector<Dir> l;
  std::vector<Path> paths = listPaths(sortByPath);

  for (std::vector<Path>::iterator i = paths.begin(); i != paths.end(); ++i) {
    Dir f(*i);
    if (f.valid())
      l.push_back(f);
  }
  return l;
}

std::vector<Path> Dir::listPaths(bool sortByPath) const
{
	std::vector<Path> l;
	if (!valid())
		return l;
	// First open a directory stream
	DIR *d = opendir(getPath().getFullName().c_str());
	struct dirent *entry;
	while ((entry = readdir(d)) != NULL) {
		std::string pathString = entry->d_name;
		if ((pathString != ".") && (pathString != "..")) {
			Path p = getPath();
			p.add(pathString);
      l.push_back(p);
		}
	}
	closedir(d);
	if (sortByPath)
		sort(l.begin(), l.end());
	return (l);
}

bool Dir::operator==(const Dir &d) const
{
	return (d.getPath() == getPath());
}

}



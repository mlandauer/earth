//  Copyright (C) 2001 Matthew Landauer. All Rights Reserved.
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

#include <unistd.h>
#include <iostream>

#include "SpPath.h"

SpPath::SpPath(const std::string &a)
{
	set(a);
}

SpPath::SpPath(const char *s)
{
	 set(s);
}

SpPath::~SpPath()
{
}

bool SpPath::operator<(const SpPath &p) const
{
	return (pathString < p.pathString);
}

bool SpPath::operator==(const SpPath &p) const
{
	return (pathString == p.pathString);
}

void SpPath::set(const std::string a)
{
	pathString = a;
	// Remove trailing "/" characters
	int length = pathString.length();
	while ((length > 0) && (pathString[length-1] == '/')) {
		pathString.resize(length - 1);
		length--;
	}
}

std::string SpPath::root() const
{
	std::string a = pathString;
	unsigned int f = pathString.rfind('/');
	if (f < pathString.length()) {
		a.resize(f);
		a += "/";
	}
	else
		a = "";
	return (a);
}

std::string SpPath::relative() const
{
	std::string a = pathString;
	unsigned int f = pathString.rfind('/');
	if (f < pathString.length()) {
		a = a.substr(f+1);
	}
	return (a);
}

// Returns an absolute version of the path
// i.e. foo/blah.tif -> /home/fiddle/foo/blah.tif
std::string SpPath::absolute() const
{
	if (pathString[0] == '/')
		return pathString;
	char workingDirectory[512];
	if (getcwd(workingDirectory, 512) == NULL) {
		std::cerr << "SpPath::absolute() getcwd buffer overflow!" << std::endl;
		exit(1);
	}
	return (std::string(workingDirectory) + "/" + pathString);
}

std::string SpPath::fullName() const
{
	return (pathString);
}

void SpPath::add(const std::string &a)
{
	pathString += "/" + a;
}




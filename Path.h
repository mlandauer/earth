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

#ifndef _path_h_
#define _path_h_

#include <string>

namespace Sp {

//! Store and manipulates paths to files
class Path
{
public:
	Path(const std::string &a = "");
	Path(const char *s);
	//! Set the path
	void set(const std::string a);
	//! Return the full path as a string
	std::string getFullName() const;
	//! Returns the path root as a string
	/*!
		For example, for a path "/home/foo/bar", returns "/home/foo/"
	*/
	std::string getRoot() const;
	//! Returns the relative part of the path as a string
	/*!
		For example, for a path "/home/foo/bar", returns "bar"
	*/
	std::string getRelative() const;
	//! Returns an absolute version of the path as a string
	/*!
		for example, for a path "foo/bar" and a current working directory of "/home/fiddle", returns "/home/fiddle/foo/bar"
	*/
	std::string getAbsolute() const;
	//! Add a string relative to a current path
	void add(const std::string &a);
	bool operator<(const Path &p) const;
	bool operator==(const Path &p) const;
	
private:
	std::string pathString;
};

}

#endif

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

#ifndef _file_h
#define _file_h

#include "Path.h"
#include "DateTime.h"
#include "Size.h"
#include "User.h"
#include "UserGroup.h"
#include "FsObject.h"

class File : public FsObject
{
	public:
		File(const Path &path);
		virtual ~File() { };
		void open();
		void close();
		unsigned long int read(void *buf, unsigned long int count) const;
		unsigned char  readChar() const;
		unsigned short readShort(const int &endian) const;
		unsigned long  readLong(const int &endian) const;
		void seek(unsigned long int pos) const;
		void seekForward(unsigned long int pos) const;
		Size size() const;
		bool valid() const;
	protected:
		File() { };
	private:
		int fd;
		bool fileOpen;
};

// Stores a file with its time stamps
class FileDateTime : public File
{
	public:
		FileDateTime(const File &file) : File(file) { }
		bool changed() {
			if (cachedChange < lastChange()) {
				cachedChange = lastChange();
				return true;
			}
			else
				return false;
		}
	protected:
		DateTime cachedChange;
};

#endif

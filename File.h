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

#ifndef _file_h
#define _file_h

#include "Path.h"
#include "DateTime.h"
#include "Size.h"
#include "User.h"
#include "UserGroup.h"
#include "FsObject.h"

namespace Sp {

//! Get information and contents of a file
class File : public FsObject
{
public:
	File(const Path &path);
	virtual ~File() { };

	//! Open file
	void open();

	//! Close file
	void close();

	//! Read from file
	/*!
		Note that the buffer needs to be allocated before this call is made.
		\param buf Buffer to read into
		\param count Number of bytes to read
	*/
	unsigned long int read(void *buf, unsigned long int count) const;

	//! Read a single byte from file
	unsigned char  readChar() const;

	//! Read a two byte short integer from file
	/*!
		By specifying the byte ordering of the file this method automatically does the necessary byte swapping
		if the byte ordering (endianness) of the file and machine differ.
		\param endian The byte ordering of the file
	*/
	unsigned short readShort(const int &endian) const;

	//! Read a four byte long integer from file
	/*!
		By specifying the byte ordering of the file this method automatically does the necessary byte swapping
		if the byte ordering (endianness) of the file and machine differ.
		\param endian The byte ordering of the file
	*/
	unsigned long  readLong(const int &endian) const;

	//! Seek to an absolute place in the file
	/*!
		This affects subsequent file access which will start at the position set here.
	*/
	void seek(unsigned long int pos) const;

	//! Seek relative to the current spot in the file
	/*!
		This affects subsequent file access which will start at the position set here.
	*/
	void seekForward(unsigned long int pos) const;

	//! Returns the file size
	Size size() const;

	//! Returns the file size in bytes
	long int sizeBytes() const;
	
	//! Is this a valid file?
	bool valid() const;
	
	File() { };
	
private:
	int fd;
	bool fileOpen;
};

}

#endif

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

#include <unistd.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <unistd.h>
#include <iostream>

#include "SpFile.h"

File::File(const Path &path) : FsObject(path), fileOpen(false)
{
}

bool File::valid() const
{
	struct stat fileStat;
	lstat(path().fullName().c_str(), &fileStat);
	return(S_ISREG(fileStat.st_mode));
}

// Opens for read only at the moment
void File::open()
{
	fd = ::open(path().fullName().c_str(), O_RDONLY);
	// TEMPORARY HACK
	if (fd == -1)
		std::cerr << "Error opening file " << path().fullName().c_str() << std::endl;
	else
		fileOpen = true;
}

Size File::size() const
{
	struct stat fileStat;
	Size s;
	lstat(path().fullName().c_str(), &fileStat);
	s.setBytes(fileStat.st_size);
	return (s);
}

void File::close()
{
	::close(fd);
	fileOpen = false;
}

unsigned long int File::read(void *buf, unsigned long int count) const
{
	return (::read(fd, buf, count));
}

void File::seek(unsigned long int pos) const
{
	lseek(fd, pos, SEEK_SET);
}

void File::seekForward(unsigned long int pos) const
{
	lseek(fd, pos, SEEK_CUR);
}

unsigned char File::readChar() const
{
	unsigned char value;
	read(&value, 1);
	return (value);
}

unsigned short File::readShort(const int &endian) const
{
	unsigned short value;
	unsigned char temp[2];
	read(temp, 2);

	// If small endian
	if (endian == 0)
		value = (temp[0]<<0) + (temp[1]<<8);
	else
		value = (temp[0]<<8) + (temp[1]<<0);
	return (value);
}

unsigned long File::readLong(const int &endian) const
{
	unsigned char temp[4];
	read(temp, 4);

	unsigned long value;
	if (endian == 0)
		value = (temp[0]<<0) + (temp[1]<<8) + (temp[2]<<16) + (temp[3]<<24);
	else
		value = (temp[0]<<24) + (temp[1]<<16) + (temp[2]<<8) + (temp[3]<<0);
	return (value);
}

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

#include <sys/stat.h>
#include <unistd.h>
#include <iostream>

#include "SpFsObject.h"
#include "SpDir.h"
#include "SpImage.h"

FsObjectHandle FsObject::construct(const Path &path)
{
	FsObject *o;
	o = new Dir(path);
	if (o->valid())
		return FsObjectHandle(o);
	else
		delete o;
		
	o = new File(path);
	if (o->valid()) {
		Image *i = Image::construct(path);
		if (i == NULL)
			return FsObjectHandle(o);
		else {
			delete o;
			return FsObjectHandle(i);
		}
	}
	else
		delete o;
	return FsObjectHandle(NULL);
}

struct stat FsObject::unixStat() const
{
	struct stat s;
	lstat(path().fullName().c_str(), &s);
	return (s);
}

Time FsObject::lastModification() const
{
	return Time::unixTime(unixStat().st_mtime);
}

Time FsObject::lastAccess() const
{
	return Time::unixTime(unixStat().st_atime);
}

Time FsObject::lastChange() const
{
	return Time::unixTime(unixStat().st_ctime);
}

Uid FsObject::uid() const
{
	return Uid::unixUid(unixStat().st_uid);
}

Gid FsObject::gid() const
{
	return Gid::unixGid(unixStat().st_gid);
}

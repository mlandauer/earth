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

#include "SpFsObject.h"
#include "SpDir.h"
#include "SpImage.h"

SpFsObjectHandle SpFsObject::construct(const SpPath &path)
{
	SpFsObject *o;
	o = new SpDir(path);
	if (o->valid())
		return SpFsObjectHandle(o);
	else
		delete o;
		
	o = new SpFile(path);
	if (o->valid()) {
		SpImage *i = SpImage::construct(path);
		if (i == NULL)
			return SpFsObjectHandle(o);
		else {
			delete o;
			return SpFsObjectHandle(i);
		}
	}
	else
		delete o;
	return SpFsObjectHandle(NULL);
}

struct stat SpFsObject::unixStat() const
{
	struct stat s;
	lstat(path().fullName().c_str(), &s);
	return (s);
}

SpTime SpFsObject::lastModification() const
{
	return SpTime::unix(unixStat().st_mtime);
}

SpTime SpFsObject::lastAccess() const
{
	return SpTime::unix(unixStat().st_atime);
}

SpTime SpFsObject::lastChange() const
{
	return SpTime::unix(unixStat().st_ctime);
}

SpUid SpFsObject::uid() const
{
	SpUid u;
	u.setUnixUid(unixStat().st_uid);
	return (u);
}

SpGid SpFsObject::gid() const
{
	SpGid g;
	g.setUnixGid(unixStat().st_gid);
	return (g);
}

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

#include <sys/stat.h>
#include <unistd.h>

#include "SpFsObject.h"
#include "SpDir.h"
#include "SpImage.h"

SpFsObject *SpFsObject::construct(const SpPath &path)
{
	SpFsObject *o;
	o = new SpDir(path);
	if (o->valid())
		return (o);
	else
		delete o;
		
	o = new SpFile(path);
	if (o->valid()) {
		SpImage *i = SpImage::construct(path);
		if (i == NULL)
			return (o);
		else {
			delete o;
			return (i);
		}
	}
	else
		delete o;
	return (NULL);
}

struct stat SpFsObject::unixStat() const
{
	struct stat s;
	lstat(path().fullName().c_str(), &s);
	return (s);
}

SpTime SpFsObject::lastModification() const
{
	SpTime t;
	t.setUnixTime(unixStat().st_mtime);
	return (t);
}

SpTime SpFsObject::lastAccess() const
{
	SpTime t;
	t.setUnixTime(unixStat().st_atime);
	return (t);
}

SpTime SpFsObject::lastChange() const
{
	SpTime t;
	t.setUnixTime(unixStat().st_ctime);
	return (t);
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

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

#include "FsObject.h"
#include "Dir.h"

namespace Sp {

struct stat FsObject::unixStat() const
{
	struct stat s;
	int ret = lstat(path().fullName().c_str(), &s);
  assert(ret == 0);
	return (s);
}

DateTime FsObject::lastModification() const
{
	return DateTime::unixDateTime(unixStat().st_mtime);
}

DateTime FsObject::lastAccess() const
{
	return DateTime::unixDateTime(unixStat().st_atime);
}

DateTime FsObject::lastChange() const
{
	return DateTime::unixDateTime(unixStat().st_ctime);
}

User FsObject::user() const
{
	return User::unixUid(unixStat().st_uid);
}

UserGroup FsObject::userGroup() const
{
	return UserGroup::unixGid(unixStat().st_gid);
}

}

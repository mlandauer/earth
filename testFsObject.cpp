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

#include "testFsObject.h"
#include "SpFsObject.h"
#include "SpFile.h"
#include "SpDir.h"

testFsObject::testFsObject() : Tester("FsObject")
{
	test();
};

void testFsObject::test()
{
	FsObjectHandle file = FsObject::construct("test/templateImages/8x8.tiff");
	checkEqual("test 1", file->path().fullName(),
		"test/templateImages/8x8.tiff");
	Uid u = Uid::current();
	Gid g = Gid::current();
	checkEqual("test 2", file->uid().name(), u.name());
	checkEqual("test 3", file->gid().name(), g.name());
	checkNotNULL("test 4", dynamic_cast<File *>(file.pointer()));
	checkNULL("test 5", dynamic_cast<Dir *>(file.pointer()));
	FsObjectHandle file2 = FsObject::construct("test/templateImages/");
	checkEqual("test 6", file2->path().fullName(), "test/templateImages");
	// Find some way to test access, modification and change times
	checkNULL("test 7", dynamic_cast<File *>(file2.pointer()));
	checkNotNULL("test 8", dynamic_cast<Dir *>(file2.pointer()));
	// Test opening a non-existing file or directory
	FsObjectHandle notExist = FsObject::construct("test/templateImages/no");
	check("test 9", notExist.null());
}

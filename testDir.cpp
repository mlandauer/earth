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

#include <iostream>
#include "testDir.h"
#include "Dir.h"

testDir::testDir() : Tester("Dir")
{
	test();
};

void testDir::test()
{
  Dir dir1("test/templateImages/8x8.tiff");
  check("test 7", !dir1.valid());
	Dir dir2("test/templateImages/");
  check("test 8", dir2.valid());
	checkEqual("test 9", dir2.path().fullName(), "test/templateImages");

	Dir dir("test/templateImages/");
	checkEqual("test 1", dir.path().fullName(),
		"test/templateImages");
	// Think of some way to test the modification dates automatically
	// Check that this user owns the files
	check("test 2", dir.user() == User::current());
	check("test 3", dir.userGroup() == UserGroup::current());
	checkEqualBool("test 4", dir.valid(), true);
	std::vector<File> files = dir.listFiles();
	if (checkEqual("ls test 0", files.size(), 12)) {
		checkEqual("ls test 1", files[0].path().fullName(), "test/templateImages/2x2.gif");
		checkEqual("ls test 2", files[1].path().fullName(), "test/templateImages/2x2.jpg");
		checkEqual("ls test 3", files[2].path().fullName(), "test/templateImages/2x2.sgi");
		checkEqual("ls test 4", files[3].path().fullName(), "test/templateImages/2x2.tiff");
		checkEqual("ls test 5", files[4].path().fullName(), "test/templateImages/4x4.gif");		
		checkEqual("ls test 6", files[5].path().fullName(), "test/templateImages/4x4.jpg");						
		checkEqual("ls test 7", files[6].path().fullName(), "test/templateImages/4x4.sgi");		
		checkEqual("ls test 8", files[7].path().fullName(), "test/templateImages/4x4.tiff");		
		checkEqual("ls test 9", files[8].path().fullName(), "test/templateImages/8x8.gif");		
		checkEqual("ls test 10", files[9].path().fullName(), "test/templateImages/8x8.jpg");		
		checkEqual("ls test 11", files[10].path().fullName(), "test/templateImages/8x8.sgi");		
		checkEqual("ls test 12", files[11].path().fullName(), "test/templateImages/8x8.tiff");
	}
  
	std::vector<Dir> dirs = dir.listDirs();
	if (checkEqual("ls test 13", dirs.size(), 1)) {
		checkEqual("ls test 14", dirs[0].path().fullName(), "test/templateImages/CVS");
	}
  
	// Try doing an ls on a non-existant directory
	Dir dirNotExist("test/whatASillyFella");
	checkEqualBool("non-existant test 1", dirNotExist.valid(), false);
	std::vector<File> lsNotExist = dirNotExist.listFiles();
	checkEqual("non-existant test 2", lsNotExist.size(), 0);
}

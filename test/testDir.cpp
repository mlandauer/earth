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
  check(!dir1.valid());
	Dir dir2("test/templateImages/");
  check(dir2.valid());
	checkEqual(dir2.path().fullName(), "test/templateImages");

	Dir dir("test/templateImages/");
	checkEqual(dir.path().fullName(), "test/templateImages");
	// Think of some way to test the modification dates automatically
	// Check that this user owns the files
	check(dir.user() == User::current());
	check(dir.userGroup() == UserGroup::current());
	checkEqualBool(dir.valid(), true);
	std::vector<File> files = dir.listFiles(true);
	if (checkEqual(files.size(), 19)) {
		checkEqual(files[0].path().fullName(), "test/templateImages/2x2.cin");
		checkEqual(files[1].path().fullName(), "test/templateImages/2x2.gif");
		checkEqual(files[2].path().fullName(), "test/templateImages/2x2.iff");
		checkEqual(files[3].path().fullName(), "test/templateImages/2x2.jpg");
		checkEqual(files[4].path().fullName(), "test/templateImages/2x2.sgi");
		checkEqual(files[5].path().fullName(), "test/templateImages/2x2.tiff");
		checkEqual(files[6].path().fullName(), "test/templateImages/4x4.cin");		
		checkEqual(files[7].path().fullName(), "test/templateImages/4x4.gif");		
		checkEqual(files[8].path().fullName(), "test/templateImages/4x4.iff");		
		checkEqual(files[9].path().fullName(), "test/templateImages/4x4.jpg");						
		checkEqual(files[10].path().fullName(), "test/templateImages/4x4.sgi");		
		checkEqual(files[11].path().fullName(), "test/templateImages/4x4.tiff");		
		checkEqual(files[12].path().fullName(), "test/templateImages/8x8.cin");		
		checkEqual(files[13].path().fullName(), "test/templateImages/8x8.cin-invalid");		
		checkEqual(files[14].path().fullName(), "test/templateImages/8x8.gif");		
		checkEqual(files[15].path().fullName(), "test/templateImages/8x8.iff");		
		checkEqual(files[16].path().fullName(), "test/templateImages/8x8.jpg");		
		checkEqual(files[17].path().fullName(), "test/templateImages/8x8.sgi");		
		checkEqual(files[18].path().fullName(), "test/templateImages/8x8.tiff");
	}
  
	std::vector<Dir> dirs = dir.listDirs(true);
	if (checkEqual(dirs.size(), 1)) {
		checkEqual(dirs[0].path().fullName(), "test/templateImages/CVS");
	}
  
	// Try doing an ls on a non-existant directory
	Dir dirNotExist("test/whatASillyFella");
	checkEqualBool(dirNotExist.valid(), false);
	std::vector<File> lsNotExist = dirNotExist.listFiles();
	checkEqual(lsNotExist.size(), 0);
	
	// Test a recursive listing
	files = dir.listFilesRecursive(true);
	if (checkEqual(files.size(), 22)) {
		checkEqual(files[0].path().fullName(), "test/templateImages/2x2.cin");
		checkEqual(files[1].path().fullName(), "test/templateImages/2x2.gif");
		checkEqual(files[2].path().fullName(), "test/templateImages/2x2.iff");
		checkEqual(files[3].path().fullName(), "test/templateImages/2x2.jpg");
		checkEqual(files[4].path().fullName(), "test/templateImages/2x2.sgi");
		checkEqual(files[5].path().fullName(), "test/templateImages/2x2.tiff");
		checkEqual(files[6].path().fullName(), "test/templateImages/4x4.cin");		
		checkEqual(files[7].path().fullName(), "test/templateImages/4x4.gif");		
		checkEqual(files[8].path().fullName(), "test/templateImages/4x4.iff");		
		checkEqual(files[9].path().fullName(), "test/templateImages/4x4.jpg");						
		checkEqual(files[10].path().fullName(), "test/templateImages/4x4.sgi");		
		checkEqual(files[11].path().fullName(), "test/templateImages/4x4.tiff");		
		checkEqual(files[12].path().fullName(), "test/templateImages/8x8.cin");		
		checkEqual(files[13].path().fullName(), "test/templateImages/8x8.cin-invalid");		
		checkEqual(files[14].path().fullName(), "test/templateImages/8x8.gif");		
		checkEqual(files[15].path().fullName(), "test/templateImages/8x8.iff");		
		checkEqual(files[16].path().fullName(), "test/templateImages/8x8.jpg");		
		checkEqual(files[17].path().fullName(), "test/templateImages/8x8.sgi");		
		checkEqual(files[18].path().fullName(), "test/templateImages/8x8.tiff");
		checkEqual(files[19].path().fullName(), "test/templateImages/CVS/Entries");
		checkEqual(files[20].path().fullName(), "test/templateImages/CVS/Repository");
		checkEqual(files[21].path().fullName(), "test/templateImages/CVS/Root");
	}
	
}

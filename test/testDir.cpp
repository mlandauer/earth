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

#include <cppunit/extensions/HelperMacros.h>
#include "testDir.h"
CPPUNIT_TEST_SUITE_REGISTRATION(testDir);

#include "Dir.h"

using namespace Sp;

void testDir::test()
{
	Dir dir1("test/templateImages/8x8.tiff");
	CPPUNIT_ASSERT(!dir1.valid());
	Dir dir2("test/templateImages/");
	CPPUNIT_ASSERT(dir2.valid());
	CPPUNIT_ASSERT(dir2.path().fullName() == "test/templateImages");

	Dir dir("test/templateImages/");
	CPPUNIT_ASSERT(dir.path().fullName() == "test/templateImages");
	// Think of some way to test the modification dates automatically
	// Check that this user owns the files
	CPPUNIT_ASSERT(dir.user() == User::current());
	CPPUNIT_ASSERT(dir.userGroup() == UserGroup::current());
	CPPUNIT_ASSERT(dir.valid());
	std::vector<File> files = dir.listFiles(true);
	
	CPPUNIT_ASSERT(files.size() == 19);
	CPPUNIT_ASSERT(files[0].path().fullName() == "test/templateImages/2x2.cin");
	CPPUNIT_ASSERT(files[1].path().fullName() == "test/templateImages/2x2.gif");
	CPPUNIT_ASSERT(files[2].path().fullName() == "test/templateImages/2x2.iff");
	CPPUNIT_ASSERT(files[3].path().fullName() == "test/templateImages/2x2.jpg");
	CPPUNIT_ASSERT(files[4].path().fullName() == "test/templateImages/2x2.sgi");
	CPPUNIT_ASSERT(files[5].path().fullName() == "test/templateImages/2x2.tiff");
	CPPUNIT_ASSERT(files[6].path().fullName() == "test/templateImages/4x4.cin");		
	CPPUNIT_ASSERT(files[7].path().fullName() == "test/templateImages/4x4.gif");		
	CPPUNIT_ASSERT(files[8].path().fullName() == "test/templateImages/4x4.iff");		
	CPPUNIT_ASSERT(files[9].path().fullName() == "test/templateImages/4x4.jpg");						
	CPPUNIT_ASSERT(files[10].path().fullName() == "test/templateImages/4x4.sgi");		
	CPPUNIT_ASSERT(files[11].path().fullName() == "test/templateImages/4x4.tiff");		
	CPPUNIT_ASSERT(files[12].path().fullName() == "test/templateImages/8x8.cin");		
	CPPUNIT_ASSERT(files[13].path().fullName() == "test/templateImages/8x8.cin-invalid");		
	CPPUNIT_ASSERT(files[14].path().fullName() == "test/templateImages/8x8.gif");		
	CPPUNIT_ASSERT(files[15].path().fullName() == "test/templateImages/8x8.iff");		
	CPPUNIT_ASSERT(files[16].path().fullName() == "test/templateImages/8x8.jpg");		
	CPPUNIT_ASSERT(files[17].path().fullName() == "test/templateImages/8x8.sgi");		
	CPPUNIT_ASSERT(files[18].path().fullName() == "test/templateImages/8x8.tiff");
  
	std::vector<Dir> dirs = dir.listDirs(true);
	CPPUNIT_ASSERT(dirs.size() == 1);
	CPPUNIT_ASSERT(dirs[0].path().fullName() == "test/templateImages/CVS");
  
	// Try doing an ls on a non-existant directory
	Dir dirNotExist("test/whatASillyFella");
	CPPUNIT_ASSERT(!dirNotExist.valid());
	std::vector<File> lsNotExist = dirNotExist.listFiles();
	CPPUNIT_ASSERT(lsNotExist.size() == 0);
	
	// Test a recursive listing
	files = dir.listFilesRecursive(true);
	CPPUNIT_ASSERT(files.size() == 22);
	CPPUNIT_ASSERT(files[0].path().fullName() == "test/templateImages/2x2.cin");
	CPPUNIT_ASSERT(files[1].path().fullName() == "test/templateImages/2x2.gif");
	CPPUNIT_ASSERT(files[2].path().fullName() == "test/templateImages/2x2.iff");
	CPPUNIT_ASSERT(files[3].path().fullName() == "test/templateImages/2x2.jpg");
	CPPUNIT_ASSERT(files[4].path().fullName() == "test/templateImages/2x2.sgi");
	CPPUNIT_ASSERT(files[5].path().fullName() == "test/templateImages/2x2.tiff");
	CPPUNIT_ASSERT(files[6].path().fullName() == "test/templateImages/4x4.cin");		
	CPPUNIT_ASSERT(files[7].path().fullName() == "test/templateImages/4x4.gif");		
	CPPUNIT_ASSERT(files[8].path().fullName() == "test/templateImages/4x4.iff");		
	CPPUNIT_ASSERT(files[9].path().fullName() == "test/templateImages/4x4.jpg");						
	CPPUNIT_ASSERT(files[10].path().fullName() == "test/templateImages/4x4.sgi");		
	CPPUNIT_ASSERT(files[11].path().fullName() == "test/templateImages/4x4.tiff");		
	CPPUNIT_ASSERT(files[12].path().fullName() == "test/templateImages/8x8.cin");		
	CPPUNIT_ASSERT(files[13].path().fullName() == "test/templateImages/8x8.cin-invalid");		
	CPPUNIT_ASSERT(files[14].path().fullName() == "test/templateImages/8x8.gif");		
	CPPUNIT_ASSERT(files[15].path().fullName() == "test/templateImages/8x8.iff");		
	CPPUNIT_ASSERT(files[16].path().fullName() == "test/templateImages/8x8.jpg");		
	CPPUNIT_ASSERT(files[17].path().fullName() == "test/templateImages/8x8.sgi");		
	CPPUNIT_ASSERT(files[18].path().fullName() == "test/templateImages/8x8.tiff");
	CPPUNIT_ASSERT(files[19].path().fullName() == "test/templateImages/CVS/Entries");
	CPPUNIT_ASSERT(files[20].path().fullName() == "test/templateImages/CVS/Repository");
	CPPUNIT_ASSERT(files[21].path().fullName() == "test/templateImages/CVS/Root");
}

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

class testDir : public CppUnit::TestFixture
{
public:
	CPPUNIT_TEST_SUITE(testDir);
	CPPUNIT_TEST(test);
	CPPUNIT_TEST(testValid);
	CPPUNIT_TEST(testRecursiveListing);
	CPPUNIT_TEST(testListFiles);
	CPPUNIT_TEST(testListDirectories);
	CPPUNIT_TEST(testListNonExistantDirectory);
	CPPUNIT_TEST_SUITE_END();
	
	void test();
	void testValid();
	void testRecursiveListing();
	void testListFiles();
	void testListDirectories();
	void testListNonExistantDirectory();
};

CPPUNIT_TEST_SUITE_REGISTRATION(testDir);

#include "Dir.h"

using namespace Sp;

void testDir::test()
{
	Dir dir("test/templateImages/");
	CPPUNIT_ASSERT(dir.getPath().getFullName() == "test/templateImages");
	// Think of some way to test the modification dates automatically
	// Check that this user owns the files
	CPPUNIT_ASSERT(dir.getUser() == User::current());
	CPPUNIT_ASSERT(dir.getUserGroup() == UserGroup::current());
}

void testDir::testValid()
{
	Dir dir1("test/templateImages/8x8.tiff");
	CPPUNIT_ASSERT(!dir1.valid());
	Dir dir2("test/whatASillyFella");
	CPPUNIT_ASSERT(!dir2.valid());
	Dir dir3("test/templateImages/");
	CPPUNIT_ASSERT(dir3.valid());
}

void testDir::testListDirectories()
{
	Dir dir("test/templateImages/");
	std::vector<Dir> dirs = dir.listDirs(true);
	CPPUNIT_ASSERT(dirs.size() == 1);
	CPPUNIT_ASSERT(dirs[0].getPath().getFullName() == "test/templateImages/CVS");
}

void testDir::testListNonExistantDirectory()
{
	Dir dirNotExist("test/whatASillyFella");
	std::vector<File> lsNotExist = dirNotExist.listFiles();
	CPPUNIT_ASSERT(lsNotExist.size() == 0);
}

void testDir::testListFiles()
{
	Dir dir("test/templateImages/");
	std::vector<File> files = dir.listFiles(true);
	CPPUNIT_ASSERT(files.size() == 19);
	CPPUNIT_ASSERT(files[0].getPath().getFullName() == "test/templateImages/2x2.cin");
	CPPUNIT_ASSERT(files[1].getPath().getFullName() == "test/templateImages/2x2.gif");
	CPPUNIT_ASSERT(files[2].getPath().getFullName() == "test/templateImages/2x2.iff");
	CPPUNIT_ASSERT(files[3].getPath().getFullName() == "test/templateImages/2x2.jpg");
	CPPUNIT_ASSERT(files[4].getPath().getFullName() == "test/templateImages/2x2.sgi");
	CPPUNIT_ASSERT(files[5].getPath().getFullName() == "test/templateImages/2x2.tiff");
	CPPUNIT_ASSERT(files[6].getPath().getFullName() == "test/templateImages/4x4.cin");		
	CPPUNIT_ASSERT(files[7].getPath().getFullName() == "test/templateImages/4x4.gif");		
	CPPUNIT_ASSERT(files[8].getPath().getFullName() == "test/templateImages/4x4.iff");		
	CPPUNIT_ASSERT(files[9].getPath().getFullName() == "test/templateImages/4x4.jpg");						
	CPPUNIT_ASSERT(files[10].getPath().getFullName() == "test/templateImages/4x4.sgi");		
	CPPUNIT_ASSERT(files[11].getPath().getFullName() == "test/templateImages/4x4.tiff");		
	CPPUNIT_ASSERT(files[12].getPath().getFullName() == "test/templateImages/8x8.cin");		
	CPPUNIT_ASSERT(files[13].getPath().getFullName() == "test/templateImages/8x8.cin-invalid");		
	CPPUNIT_ASSERT(files[14].getPath().getFullName() == "test/templateImages/8x8.gif");		
	CPPUNIT_ASSERT(files[15].getPath().getFullName() == "test/templateImages/8x8.iff");		
	CPPUNIT_ASSERT(files[16].getPath().getFullName() == "test/templateImages/8x8.jpg");		
	CPPUNIT_ASSERT(files[17].getPath().getFullName() == "test/templateImages/8x8.sgi");		
	CPPUNIT_ASSERT(files[18].getPath().getFullName() == "test/templateImages/8x8.tiff");
}

void testDir::testRecursiveListing()
{
	Dir dir("test/templateImages/");
	std::vector<File> files = dir.listFilesRecursive(true);
	CPPUNIT_ASSERT(files.size() == 22);
	CPPUNIT_ASSERT(files[0].getPath().getFullName() == "test/templateImages/2x2.cin");
	CPPUNIT_ASSERT(files[1].getPath().getFullName() == "test/templateImages/2x2.gif");
	CPPUNIT_ASSERT(files[2].getPath().getFullName() == "test/templateImages/2x2.iff");
	CPPUNIT_ASSERT(files[3].getPath().getFullName() == "test/templateImages/2x2.jpg");
	CPPUNIT_ASSERT(files[4].getPath().getFullName() == "test/templateImages/2x2.sgi");
	CPPUNIT_ASSERT(files[5].getPath().getFullName() == "test/templateImages/2x2.tiff");
	CPPUNIT_ASSERT(files[6].getPath().getFullName() == "test/templateImages/4x4.cin");		
	CPPUNIT_ASSERT(files[7].getPath().getFullName() == "test/templateImages/4x4.gif");		
	CPPUNIT_ASSERT(files[8].getPath().getFullName() == "test/templateImages/4x4.iff");		
	CPPUNIT_ASSERT(files[9].getPath().getFullName() == "test/templateImages/4x4.jpg");						
	CPPUNIT_ASSERT(files[10].getPath().getFullName() == "test/templateImages/4x4.sgi");		
	CPPUNIT_ASSERT(files[11].getPath().getFullName() == "test/templateImages/4x4.tiff");		
	CPPUNIT_ASSERT(files[12].getPath().getFullName() == "test/templateImages/8x8.cin");		
	CPPUNIT_ASSERT(files[13].getPath().getFullName() == "test/templateImages/8x8.cin-invalid");		
	CPPUNIT_ASSERT(files[14].getPath().getFullName() == "test/templateImages/8x8.gif");		
	CPPUNIT_ASSERT(files[15].getPath().getFullName() == "test/templateImages/8x8.iff");		
	CPPUNIT_ASSERT(files[16].getPath().getFullName() == "test/templateImages/8x8.jpg");		
	CPPUNIT_ASSERT(files[17].getPath().getFullName() == "test/templateImages/8x8.sgi");		
	CPPUNIT_ASSERT(files[18].getPath().getFullName() == "test/templateImages/8x8.tiff");
	CPPUNIT_ASSERT(files[19].getPath().getFullName() == "test/templateImages/CVS/Entries");
	CPPUNIT_ASSERT(files[20].getPath().getFullName() == "test/templateImages/CVS/Repository");
	CPPUNIT_ASSERT(files[21].getPath().getFullName() == "test/templateImages/CVS/Root");
}

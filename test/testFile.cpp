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

class testFile : public CppUnit::TestFixture
{
public:
	CPPUNIT_TEST_SUITE(testFile);
	CPPUNIT_TEST(test);
	CPPUNIT_TEST(testValid);
	CPPUNIT_TEST(testRead);
	CPPUNIT_TEST_SUITE_END();
	
	void test(), testValid(), testRead();
};

CPPUNIT_TEST_SUITE_REGISTRATION(testFile);

#include "File.h"

using namespace Sp;

void testFile::test()
{
	File file1("test/templateImages/8x8.tiff");
	File file2("test/templateImages/");
 
	CPPUNIT_ASSERT(file1.getPath().getFullName() == "test/templateImages/8x8.tiff");
	CPPUNIT_ASSERT(file1.getUser() == User::current());
	CPPUNIT_ASSERT(file1.getUserGroup() == UserGroup::current());

	// Find some way to test access, modification and change times

	File file("test/templateImages/8x8.tiff");
	CPPUNIT_ASSERT(file.getPath().getFullName() == "test/templateImages/8x8.tiff");
	CPPUNIT_ASSERT_DOUBLES_EQUAL(file.getSize().getBytes(), 396.0, 0.1);
	CPPUNIT_ASSERT_DOUBLES_EQUAL(file.getSize().getKBytes(), 0.39, 0.1);
}

void testFile::testValid()
{
	File file1("test/templateImages/8x8.tiff");
	CPPUNIT_ASSERT(file1.valid());
	File file2("test/templateImages/");
	CPPUNIT_ASSERT(!file2.valid());
	File notExist("test/templateImages/no");
	CPPUNIT_ASSERT(!notExist.valid());
}

void testFile::testRead()
{
	File file("test/templateImages/8x8.tiff");
	file.open();
	unsigned char buf[2];
	CPPUNIT_ASSERT(file.read(buf, 2) == 2);
	CPPUNIT_ASSERT(buf[0] == 0x49);
	CPPUNIT_ASSERT(buf[1] == 0x49);
	file.seek(10);
	file.read(buf, 1);
	CPPUNIT_ASSERT(buf[0] == 0xff);
	file.seekForward(2);
	file.read(buf, 1);
	CPPUNIT_ASSERT(buf[0] == 0xff);
	file.close();
}

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

#include "testFile.h"
#include "File.h"

testFile::testFile() : Tester("File")
{
	test();
};

void testFile::test()
{
	File file1("test/templateImages/8x8.tiff");
  check("test 1", file1.valid());
  File file2("test/templateImages/");
  check("test 2", !file2.valid());
  
	checkEqual("test 3", file1.path().fullName(), "test/templateImages/8x8.tiff");
	check("test 4", file1.user() == User::current());
	check("test 5", file1.userGroup() == UserGroup::current());

	// Find some way to test access, modification and change times
	// Test opening a non-existing file or directory
	File notExist("test/templateImages/no");
	check("test 6", !notExist.valid());

	File file("test/templateImages/8x8.tiff");
	checkEqualBool("test 0", file.valid(), true);
	checkEqual("test 1", file.path().fullName(), "test/templateImages/8x8.tiff");
	checkEqual("test 2", file.size().getBytes(), 396.0);
	checkEqual("test 3", file.size().getKBytes(), 0.39);
	file.open();
	unsigned char buf[2];
	checkEqual("test 4", file.read(buf, 2), 2);
	checkEqual("test 5", buf[0], 0x49);
	checkEqual("test 6", buf[1], 0x49);
	file.seek(10);
	file.read(buf, 1);
	checkEqual("test 7", buf[0], 0xff);
	file.seekForward(2);
	file.read(buf, 1);
	checkEqual("test 8", buf[0], 0xff);
	file.close();
}

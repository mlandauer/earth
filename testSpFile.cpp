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

#include "testSpFile.h"
#include "SpFile.h"

testSpFile::testSpFile() : SpTester("SpFile")
{
	test();
};

void testSpFile::test()
{
	SpFile file("test/templateImages/8x8.tiff");
	checkEqualBool("test 0", file.valid(), true);
	checkEqual("test 1", file.path().fullName(), "test/templateImages/8x8.tiff");
	checkEqual("test 2", file.size().bytes(), 396.0);
	checkEqual("test 3", file.size().kbytes(), 0.39);
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

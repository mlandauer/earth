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

#include "testIndexDirectory.h"

#include "Path.h"
#include "IndexDirectory.h"

testIndexDirectory::testIndexDirectory() : Tester("IndexDirectory")
{
	test();
}

void testIndexDirectory::test()
{
	// Making the following set of sequences:
	// Format  Width Height Name                        Frames
	// GIF     2     2      test/index/test1.#.gif      1-4
	// GIF     4     4      test/index/test1.#.gif      5
	// SGI     8     8      test/index/test2.@@         8
	// Cineon  4     4      test/index/foo/#            2-3
	// Cineon  8     8      test/index/blah/a/#.cin     6-7
	
	system("rm -rf test/index");
	system("mkdir test/index");
	system("mkdir test/index/foo");
	system("mkdir -p test/index/blah/a");
	// GIF     2     2      test/index/test1.#.gif      1-4
	system("cp test/templateImages/2x2.gif test/index/test1.0001.gif");
	system("cp test/templateImages/2x2.gif test/index/test1.0002.gif");
	system("cp test/templateImages/2x2.gif test/index/test1.0003.gif");
	system("cp test/templateImages/2x2.gif test/index/test1.0004.gif");
	// GIF     4     4      test/index/test1.#.gif      5
	system("cp test/templateImages/4x4.gif test/index/test1.0005.gif");
	// SGI     8     8      test/index/test2.@@         8
	system("cp test/templateImages/8x8.sgi test/index/test2.08");
	// Cineon  4     4      test/index/foo/#            2-3
	system("cp test/templateImages/4x4.cin test/index/foo/0002");
	system("cp test/templateImages/4x4.cin test/index/foo/0003");
	// Cineon  8     8      test/index/blah/a/#.cin     6-7
	system("cp test/templateImages/8x8.cin test/index/blah/a/0006.cin");
	system("cp test/templateImages/8x8.cin test/index/blah/a/0007.cin");
	
	IndexDirectory i;
	std::vector<ImageSeq> r = i.getImageSequences("test/index");
	
	if (checkEqual("test 1", r.size(), 5)) {
		checkSequence("test 2", r[0], "GIF", 2, 2, "test/index/test1.#.gif", "1-4");
		checkSequence("test 3", r[1], "GIF", 4, 4, "test/index/test1.#.gif", "5");
		checkSequence("test 4", r[2], "SGI", 8, 8, "test/index/test2.@@", "8");
		checkSequence("test 5", r[3], "Cineon", 4, 4, "test/index/foo/#", "2-3");
		checkSequence("test 6", r[4], "Cineon", 8, 8, "test/index/blah/a/#.cin", "6-7");
	}
}

void testIndexDirectory::checkSequence(const std::string &name, const ImageSeq &sequence,
	const std::string &format, int width, int height, const std::string &path, const std::string &frames)
{
	checkEqual(name + "a", sequence.format()->formatString(), format);
	check(name + "b", sequence.dim() == ImageDim(width, height));
	checkEqual(name + "c", sequence.path().fullName(), path);
	checkEqual(name + "d", sequence.framesString(), frames);
}

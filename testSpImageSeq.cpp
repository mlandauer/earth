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

#include "testSpImageSeq.h"
#include "SpPath.h"

testSpImageSeq::testSpImageSeq() : SpTester("SpImageSeq")
{
	test();
};

void testSpImageSeq::test()
{
	system ("rm -rf test/seq");
	SpPath path1a("test/seq/test1.0001.gif");
	SpPath path1b("test/seq/test1.0002.gif");
	SpPath path1c("test/seq/test1.0003.gif");
	SpPath path1d("test/seq/test1.0004.gif");
	SpPath path2a("test/seq/test2.8.gif");		
	SpPath path3a("test/seq/test2.000123.gif");		
	SpPath path4a("test/seq/120.gif");		
	SpPath path5a("test/seq/110.gif");
	makeDirectory("test/seq");
	copyFile("test/templateImages/2x2.gif", path1a);
	copyFile("test/templateImages/2x2.gif", path1b);
	copyFile("test/templateImages/2x2.gif", path1c);
	copyFile("test/templateImages/2x2.gif", path1d);
	copyFile("test/templateImages/2x2.gif", path2a);
	copyFile("test/templateImages/2x2.gif", path3a);
	copyFile("test/templateImages/2x2.gif", path4a);
	copyFile("test/templateImages/4x4.tiff", path5a);
	SpImage *i1 = SpImage::construct(path1a);
	SpImage *i2 = SpImage::construct(path1b);
	SpImage *i3 = SpImage::construct(path1c);
	SpImage *i4 = SpImage::construct(path1d);
	SpImage *i5 = SpImage::construct(path2a);
	SpImage *i6 = SpImage::construct(path3a);
	SpImage *i7 = SpImage::construct(path4a);
	SpImage *i8 = SpImage::construct(path5a);
		
	if (checkNotNULL("test 1a", i1)) {
		SpImageSeq seq(i1);
		checkSequence("test 1", seq, "test/seq/test1.#.gif", "1", 2, 2, "GIF");
		if (checkNotNULL("test 2a", i2)) {
			seq.addImage(i2);
			checkSequence("test 2", seq, "test/seq/test1.#.gif", "1-2", 2, 2, "GIF");
		}
		if (checkNotNULL("test 3a", i4)) {
			seq.addImage(i4);
			checkSequence("test 3", seq, "test/seq/test1.#.gif", "1-2,4", 2, 2, "GIF");
		}
		if (checkNotNULL("test 4a", i3)) {
			seq.addImage(i3);
			checkSequence("test 4", seq, "test/seq/test1.#.gif", "1-4", 2, 2, "GIF");
		}
		if (checkNotNULL("test 11a", i2)) {
			seq.removeImage(i2);
			checkSequence("test 11", seq, "test/seq/test1.#.gif", "1,3-4", 2, 2, "GIF");
		}
		// If we remove something that's not part of the sequence nothing should change
		if (checkNotNULL("test 12a", i8)) {
			seq.removeImage(i8);
			checkSequence("test 12", seq, "test/seq/test1.#.gif", "1,3-4", 2, 2, "GIF");
		}
		if (checkNotNULL("test 13a", i2)) {
			seq.removeImage(i2);
			checkSequence("test 13", seq, "test/seq/test1.#.gif", "1,3-4", 2, 2, "GIF");
		}
		// Removing by giving a path
		if (checkNotNULL("test 12a", i3)) {
			seq.removeImage(path1c);
			checkSequence("test 12", seq, "test/seq/test1.#.gif", "1,4", 2, 2, "GIF");
		}
			
	}
		
	if (checkNotNULL("test 5a", i5)) {
		SpImageSeq seq2(i5);
		checkSequence("test 5", seq2, "test/seq/test2.@.gif", "8", 2, 2, "GIF");
	}
	if (checkNotNULL("test 6a", i6)) {
		SpImageSeq seq3(i6);
		checkSequence("test 6", seq3, "test/seq/test2.@@@@@@.gif", "123", 2, 2, "GIF");
	}
		
	if (checkNotNULL("test 7a", i7)) {
		SpImageSeq seq4(i7);
		checkSequence("test 7", seq4, "test/seq/@@@.gif", "120", 2, 2, "GIF");
		if (checkNotNULL("test 8a", i5)) {
			// Adding in an image with a different name should not work
			seq4.addImage(i5);
			checkSequence("test 8", seq4, "test/seq/@@@.gif", "120", 2, 2, "GIF");
		}
		if (checkNotNULL("test 9a", i8)) {
			// Adding in an image with a correct name but wrong image size should not work
			seq4.addImage(i8);
			checkSequence("test 9", seq4, "test/seq/@@@.gif", "120", 2, 2, "GIF");
		}
	}
		
	if (checkNotNULL("test 10a", i8)) {
		SpImageSeq seq5(i8);
		checkSequence("test 10", seq5, "test/seq/@@@.gif", "110", 4, 4, "TIFF");
	}
			
	system ("rm -rf test/seq");
	delete i1, i2, i3, i4, i5, i6, i7, i8;
}

void testSpImageSeq::checkSequence(std::string testName, const SpImageSeq &seq,
	std::string name, std::string frames, int width, int height, std::string format)
{
	checkEqual(testName + "b", seq.path().fullName(), name);
	checkEqual(testName + "c", seq.framesString(), frames);
	checkEqual(testName + "d", seq.dim().width(), width);
	checkEqual(testName + "e", seq.dim().height(), height);
	checkEqual(testName + "f", seq.format()->formatString(), format);		
}

void testSpImageSeq::copyFile(const SpPath &path1, const SpPath &path2)
{
	std::string command = "cp " + path1.fullName() + " " + path2.fullName();
	system (command.c_str());
}
void testSpImageSeq::makeDirectory(const SpPath &path)
{
	std::string command = "mkdir " + path.fullName();
	system (command.c_str());
}

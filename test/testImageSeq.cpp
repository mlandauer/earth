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
#include "testImageSeq.h"
#include "Path.h"

testImageSeq::testImageSeq() : Tester("ImageSeq")
{
	test();
};

void testImageSeq::test()
{
	system ("rm -rf test/seq");
	Path path1a("test/seq/test1.0001.gif");
	Path path1b("test/seq/test1.0002.gif");
	Path path1c("test/seq/test1.0003.gif");
	Path path1d("test/seq/test1.0004.gif");
	Path path2a("test/seq/test2.8.gif");		
	Path path3a("test/seq/test2.000123.gif");		
	Path path4a("test/seq/120.gif");		
	Path path5a("test/seq/110.gif");
	Path path6a("test/seq/test3.0001");
	Path path6b("test/seq/test3.0002");
	Path path6c("test/seq/test3.0003");
	Path path6d("test/seq/test3.0004");
	makeDirectory("test/seq");
	copyFile("test/templateImages/2x2.gif", path1a);
	copyFile("test/templateImages/2x2.gif", path1b);
	copyFile("test/templateImages/2x2.gif", path1c);
	copyFile("test/templateImages/2x2.gif", path1d);
	copyFile("test/templateImages/2x2.gif", path2a);
	copyFile("test/templateImages/2x2.gif", path3a);
	copyFile("test/templateImages/2x2.gif", path4a);
	copyFile("test/templateImages/4x4.tiff", path5a);
	copyFile("test/templateImages/8x8.cin", path6a);
	copyFile("test/templateImages/8x8.cin-invalid", path6b);
	copyFile("test/templateImages/8x8.cin", path6c);
	copyFile("test/templateImages/8x8.cin-invalid", path6d);
	Image *i1 = Image::construct(path1a);
	Image *i2 = Image::construct(path1b);
	Image *i3 = Image::construct(path1c);
	Image *i4 = Image::construct(path1d);
	Image *i5 = Image::construct(path2a);
	Image *i6 = Image::construct(path3a);
	Image *i7 = Image::construct(path4a);
	Image *i8 = Image::construct(path5a);
	Image *i9 = Image::construct(path6a);
	Image *i10 = Image::construct(path6b);
	Image *i11 = Image::construct(path6c);
	Image *i12 = Image::construct(path6d);
		
	if (checkNotNULL("test 1a", i1)) {
		ImageSeq seq(i1);
		checkSequence("test 1", seq, "test/seq/test1.#.gif", "1", 2, 2, "GIF");
		if (checkNotNULL("test 2a", i2)) {
			check("test 2b", seq.addImage(i2));
			checkSequence("test 2", seq, "test/seq/test1.#.gif", "1-2", 2, 2, "GIF");
		}
		if (checkNotNULL("test 3a", i4)) {
			check("test 3b", seq.addImage(i4));
			checkSequence("test 3", seq, "test/seq/test1.#.gif", "1-2,4", 2, 2, "GIF");
		}
		if (checkNotNULL("test 4a", i3)) {
			check("test 4b", seq.addImage(i3));
			checkSequence("test 4", seq, "test/seq/test1.#.gif", "1-4", 2, 2, "GIF");
		}
		if (checkNotNULL("test 11a", i2)) {
			check("test 11b", seq.removeImage(i2));
			checkSequence("test 11", seq, "test/seq/test1.#.gif", "1,3-4", 2, 2, "GIF");
		}
		// If we remove something that's not part of the sequence nothing should change
		if (checkNotNULL("test 12a", i8)) {
			check("test 12b", !seq.removeImage(i8));
			checkSequence("test 12", seq, "test/seq/test1.#.gif", "1,3-4", 2, 2, "GIF");
		}
		if (checkNotNULL("test 13a", i2)) {
			check("test 13b", !seq.removeImage(i2));
			checkSequence("test 13", seq, "test/seq/test1.#.gif", "1,3-4", 2, 2, "GIF");
		}
		// Removing by giving a path
		if (checkNotNULL("test 12a", i3)) {
			check("test 12b", seq.removeImage(path1c));
			checkSequence("test 12", seq, "test/seq/test1.#.gif", "1,4", 2, 2, "GIF");
		}
			
	}
		
	if (checkNotNULL("test 5a", i5)) {
		ImageSeq seq2(i5);
		checkSequence("test 5", seq2, "test/seq/test2.@.gif", "8", 2, 2, "GIF");
	}
	if (checkNotNULL("test 6a", i6)) {
		ImageSeq seq3(i6);
		checkSequence("test 6", seq3, "test/seq/test2.@@@@@@.gif", "123", 2, 2, "GIF");
	}
		
	if (checkNotNULL("test 7a", i7)) {
		ImageSeq seq4(i7);
		checkSequence("test 7", seq4, "test/seq/@@@.gif", "120", 2, 2, "GIF");
		if (checkNotNULL("test 8a", i5)) {
			// Adding in an image with a different name should not work
			check("test 8b", !seq4.addImage(i5));
			checkSequence("test 8", seq4, "test/seq/@@@.gif", "120", 2, 2, "GIF");
		}
		if (checkNotNULL("test 9a", i8)) {
			// Adding in an image with a correct name but wrong image size should not work
			check("test 9b", !seq4.addImage(i8));
			checkSequence("test 9", seq4, "test/seq/@@@.gif", "120", 2, 2, "GIF");
		}
	}
		
	if (checkNotNULL("test 10a", i8)) {
		ImageSeq seq5(i8);
		checkSequence("test 10", seq5, "test/seq/@@@.gif", "110", 4, 4, "TIFF");
	}
	
	// Now test what happens when we have a mix of valid and invalid images
	if (checkNotNULL("test 11", i9) && checkNotNULL("test 12", i10)) {
		ImageSeq one(i9), two(i10);
		check("test 13", i9->valid());
		check("test 14", !i10->valid());
		check("test 15", i11->valid());
		check("test 16", !i12->valid());
		check("test 17", one.addImage(i11));
		check("test 18", !one.addImage(i12));
		check("test 19", !two.addImage(i11));
		check("test 20", two.addImage(i12));
	}
	
	system ("rm -rf test/seq");
	delete i1;
  delete i2;
  delete i3;
  delete i4;
  delete i5;
  delete i6;
  delete i7;
  delete i8;
	delete i9;
	delete i10;
	delete i11;
	delete i12;
}

void testImageSeq::checkSequence(std::string testName, const ImageSeq &seq,
	std::string name, std::string frames, int width, int height, std::string format)
{
	checkEqual(testName + "b", seq.path().fullName(), name);
	checkEqual(testName + "c", seq.framesString(), frames);
	checkEqual(testName + "d", seq.dim().width(), width);
	checkEqual(testName + "e", seq.dim().height(), height);
	checkEqual(testName + "f", seq.format()->formatString(), format);		
}

void testImageSeq::copyFile(const Path &path1, const Path &path2)
{
	std::string command = "cp " + path1.fullName() + " " + path2.fullName();
	system (command.c_str());
}
void testImageSeq::makeDirectory(const Path &path)
{
	std::string command = "mkdir " + path.fullName();
	system (command.c_str());
}

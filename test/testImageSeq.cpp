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
		
	if (check(i1 != NULL)) {
		ImageSeq seq(i1);
		checkSequence(seq, "test/seq/test1.#.gif", "1", 2, 2, "GIF");
		if (check(i2 != NULL)) {
			check(seq.addImage(i2));
			checkSequence(seq, "test/seq/test1.#.gif", "1-2", 2, 2, "GIF");
		}
		if (check(i4 != NULL)) {
			check(seq.addImage(i4));
			checkSequence(seq, "test/seq/test1.#.gif", "1-2,4", 2, 2, "GIF");
		}
		if (check(i3 != NULL)) {
			check(seq.addImage(i3));
			checkSequence(seq, "test/seq/test1.#.gif", "1-4", 2, 2, "GIF");
		}
		if (check(i2 != NULL)) {
			check(seq.removeImage(i2));
			checkSequence(seq, "test/seq/test1.#.gif", "1,3-4", 2, 2, "GIF");
		}
		// If we remove something that's not part of the sequence nothing should change
		if (check(i8 != NULL)) {
			check(!seq.removeImage(i8));
			checkSequence(seq, "test/seq/test1.#.gif", "1,3-4", 2, 2, "GIF");
		}
		if (check(i2 != NULL)) {
			check(!seq.removeImage(i2));
			checkSequence(seq, "test/seq/test1.#.gif", "1,3-4", 2, 2, "GIF");
		}
		// Removing by giving a path
		if (check(i3 != NULL)) {
			check(seq.removeImage(path1c));
			checkSequence(seq, "test/seq/test1.#.gif", "1,4", 2, 2, "GIF");
		}
			
	}
		
	if (check(i5 != NULL)) {
		ImageSeq seq2(i5);
		checkSequence(seq2, "test/seq/test2.@.gif", "8", 2, 2, "GIF");
	}
	if (check(i6 != NULL)) {
		ImageSeq seq3(i6);
		checkSequence(seq3, "test/seq/test2.@@@@@@.gif", "123", 2, 2, "GIF");
	}
		
	if (check(i7 != NULL)) {
		ImageSeq seq4(i7);
		checkSequence(seq4, "test/seq/@@@.gif", "120", 2, 2, "GIF");
		if (check(i5 != NULL)) {
			// Adding in an image with a different name should not work
			check(!seq4.addImage(i5));
			checkSequence(seq4, "test/seq/@@@.gif", "120", 2, 2, "GIF");
		}
		if (check(i8 != NULL)) {
			// Adding in an image with a correct name but wrong image size should not work
			check(!seq4.addImage(i8));
			checkSequence(seq4, "test/seq/@@@.gif", "120", 2, 2, "GIF");
		}
	}
		
	if (check(i8 != NULL)) {
		ImageSeq seq5(i8);
		checkSequence(seq5, "test/seq/@@@.gif", "110", 4, 4, "TIFF");
	}
	
	// Now test what happens when we have a mix of valid and invalid images
	if (check(i9 != NULL) && check(i10 != NULL)) {
		ImageSeq one(i9), two(i10);
		check(i9->valid());
		check(!i10->valid());
		check(i11->valid());
		check(!i12->valid());
		check(one.addImage(i11));
		check(!one.addImage(i12));
		check(!two.addImage(i11));
		check(two.addImage(i12));
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

void testImageSeq::checkSequence(const ImageSeq &seq, std::string name, std::string frames,
	int width, int height, std::string format)
{
	checkEqual(seq.path().fullName(), name);
	checkEqual(seq.framesString(), frames);
	checkEqual(seq.dim().width(), width);
	checkEqual(seq.dim().height(), height);
	checkEqual(seq.format()->formatString(), format);		
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

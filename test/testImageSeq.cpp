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
#include "testImageSeq.h"
CPPUNIT_TEST_SUITE_REGISTRATION(testImageSeq);

#include "Path.h"

using namespace Sp;

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
		
	CPPUNIT_ASSERT(i1 != NULL);
	ImageSeq seq(i1);
	checkSequence(seq, "test/seq/test1.#.gif", "1", 2, 2, "GIF");
	CPPUNIT_ASSERT(i2 != NULL);
	CPPUNIT_ASSERT(seq.addImage(i2));
	checkSequence(seq, "test/seq/test1.#.gif", "1-2", 2, 2, "GIF");

	CPPUNIT_ASSERT(i4 != NULL);
	CPPUNIT_ASSERT(seq.addImage(i4));
	checkSequence(seq, "test/seq/test1.#.gif", "1-2,4", 2, 2, "GIF");

	CPPUNIT_ASSERT(i3 != NULL);
	CPPUNIT_ASSERT(seq.addImage(i3));
	checkSequence(seq, "test/seq/test1.#.gif", "1-4", 2, 2, "GIF");

	CPPUNIT_ASSERT(i2 != NULL);
	CPPUNIT_ASSERT(seq.removeImage(i2));
	checkSequence(seq, "test/seq/test1.#.gif", "1,3-4", 2, 2, "GIF");

	// If we remove something that's not part of the sequence nothing should change
	CPPUNIT_ASSERT(i8 != NULL);
	CPPUNIT_ASSERT(!seq.removeImage(i8));
	checkSequence(seq, "test/seq/test1.#.gif", "1,3-4", 2, 2, "GIF");

	CPPUNIT_ASSERT(i2 != NULL);
	CPPUNIT_ASSERT(!seq.removeImage(i2));
	checkSequence(seq, "test/seq/test1.#.gif", "1,3-4", 2, 2, "GIF");

	// Removing by giving a path
	CPPUNIT_ASSERT(i3 != NULL);
	CPPUNIT_ASSERT(seq.removeImage(path1c));
	checkSequence(seq, "test/seq/test1.#.gif", "1,4", 2, 2, "GIF");		
		
	CPPUNIT_ASSERT(i5 != NULL);
	ImageSeq seq2(i5);
	checkSequence(seq2, "test/seq/test2.@.gif", "8", 2, 2, "GIF");

	CPPUNIT_ASSERT(i6 != NULL);
	ImageSeq seq3(i6);
	checkSequence(seq3, "test/seq/test2.@@@@@@.gif", "123", 2, 2, "GIF");

		
	CPPUNIT_ASSERT(i7 != NULL);
	ImageSeq seq4(i7);
	checkSequence(seq4, "test/seq/@@@.gif", "120", 2, 2, "GIF");
	CPPUNIT_ASSERT(i5 != NULL);
	// Adding in an image with a different name should not work
	CPPUNIT_ASSERT(!seq4.addImage(i5));
	checkSequence(seq4, "test/seq/@@@.gif", "120", 2, 2, "GIF");

	CPPUNIT_ASSERT(i8 != NULL);
	// Adding in an image with a correct name but wrong image size should not work
	CPPUNIT_ASSERT(!seq4.addImage(i8));
	checkSequence(seq4, "test/seq/@@@.gif", "120", 2, 2, "GIF");
		
	CPPUNIT_ASSERT(i8 != NULL);
	ImageSeq seq5(i8);
	checkSequence(seq5, "test/seq/@@@.gif", "110", 4, 4, "TIFF");
	
	// Now test what happens when we have a mix of valid and invalid images
	CPPUNIT_ASSERT((i9 != NULL) && (i10 != NULL));
	ImageSeq one(i9), two(i10);
	CPPUNIT_ASSERT(i9->valid());
	CPPUNIT_ASSERT(!i10->valid());
	CPPUNIT_ASSERT(i11->valid());
	CPPUNIT_ASSERT(!i12->valid());
	CPPUNIT_ASSERT(one.addImage(i11));
	CPPUNIT_ASSERT(!one.addImage(i12));
	CPPUNIT_ASSERT(!two.addImage(i11));
	CPPUNIT_ASSERT(two.addImage(i12));
	
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
	CPPUNIT_ASSERT_EQUAL(seq.path().fullName(), name);
	CPPUNIT_ASSERT_EQUAL(seq.framesString(), frames);
	CPPUNIT_ASSERT(seq.dim().width() == width);
	CPPUNIT_ASSERT(seq.dim().height() == height);
	CPPUNIT_ASSERT_EQUAL(seq.format()->formatString(), format);		
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

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

#include "ImageSeq.h"
#include "Path.h"

using namespace Sp;

class testImageSeq : public CppUnit::TestFixture
{
public:
	CPPUNIT_TEST_SUITE(testImageSeq);
	CPPUNIT_TEST(test);
	CPPUNIT_TEST(testInvalidSequence);
	CPPUNIT_TEST_SUITE_END();
	
	void test();
	void testInvalidSequence();

private:
	void checkSequence(const ImageSeq &seq, std::string name, std::string frames,
		int width, int height, std::string format, bool valid);
};

CPPUNIT_TEST_SUITE_REGISTRATION(testImageSeq);

#include "Path.h"

using namespace Sp;

void testImageSeq::test()
{
	Image *i1 = Image::construct("test/seq/test1.0001.gif");
	Image *i2 = Image::construct("test/seq/test1.0002.gif");
	Image *i3 = Image::construct("test/seq/test1.0003.gif");
	Image *i4 = Image::construct("test/seq/test1.0004.gif");
	Image *i5 = Image::construct("test/seq/test2.8.gif");
	Image *i6 = Image::construct("test/seq/test2.000123.gif");
	Image *i7 = Image::construct("test/seq/120.gif");
	Image *i8 = Image::construct("test/seq/110.gif");
		
	CPPUNIT_ASSERT(i1 != NULL);
	CPPUNIT_ASSERT(i2 != NULL);
	CPPUNIT_ASSERT(i3 != NULL);
	CPPUNIT_ASSERT(i4 != NULL);
	CPPUNIT_ASSERT(i5 != NULL);
	CPPUNIT_ASSERT(i6 != NULL);
	CPPUNIT_ASSERT(i7 != NULL);
	CPPUNIT_ASSERT(i8 != NULL);
	
	ImageSeq seq(i1);
	checkSequence(seq, "test/seq/test1.#.gif", "1", 2, 2, "GIF", true);
	CPPUNIT_ASSERT(seq.addImage(i2));
	checkSequence(seq, "test/seq/test1.#.gif", "1-2", 2, 2, "GIF", true);

	CPPUNIT_ASSERT(seq.addImage(i4));
	checkSequence(seq, "test/seq/test1.#.gif", "1-2,4", 2, 2, "GIF", true);

	CPPUNIT_ASSERT(seq.addImage(i3));
	checkSequence(seq, "test/seq/test1.#.gif", "1-4", 2, 2, "GIF", true);

	CPPUNIT_ASSERT(seq.removeImage(i2));
	checkSequence(seq, "test/seq/test1.#.gif", "1,3-4", 2, 2, "GIF", true);

	// If we remove something that's not part of the sequence nothing should change
	CPPUNIT_ASSERT(!seq.removeImage(i8));
	checkSequence(seq, "test/seq/test1.#.gif", "1,3-4", 2, 2, "GIF", true);

	CPPUNIT_ASSERT(!seq.removeImage(i2));
	checkSequence(seq, "test/seq/test1.#.gif", "1,3-4", 2, 2, "GIF", true);

	// Removing by giving a path
	CPPUNIT_ASSERT(seq.removeImage("test/seq/test1.0003.gif"));
	checkSequence(seq, "test/seq/test1.#.gif", "1,4", 2, 2, "GIF", true);		
		
	ImageSeq seq2(i5);
	checkSequence(seq2, "test/seq/test2.@.gif", "8", 2, 2, "GIF", true);

	ImageSeq seq3(i6);
	checkSequence(seq3, "test/seq/test2.@@@@@@.gif", "123", 2, 2, "GIF", true);

	ImageSeq seq4(i7);
	checkSequence(seq4, "test/seq/@@@.gif", "120", 2, 2, "GIF", true);
	// Adding in an image with a different name should not work
	CPPUNIT_ASSERT(!seq4.addImage(i5));
	checkSequence(seq4, "test/seq/@@@.gif", "120", 2, 2, "GIF", true);

	// Adding in an image with a correct name but wrong image size should not work
	CPPUNIT_ASSERT(!seq4.addImage(i8));
	checkSequence(seq4, "test/seq/@@@.gif", "120", 2, 2, "GIF", true);
		
	ImageSeq seq5(i8);
	checkSequence(seq5, "test/seq/@@@.gif", "110", 4, 4, "TIFF", true);
	
	delete i1;
	delete i2;
	delete i3;
	delete i4;
	delete i5;
	delete i6;
	delete i7;
	delete i8;
}

// Test what happens when we have a mix of valid and invalid images
void testImageSeq::testInvalidSequence()
{
	Image *i1 = Image::construct("test/seq/test3.0001");
	Image *i2 = Image::construct("test/seq/test3.0002");
	Image *i3 = Image::construct("test/seq/test3.0003");
	Image *i4 = Image::construct("test/seq/test3.0004");

	CPPUNIT_ASSERT(i1 != NULL);
	CPPUNIT_ASSERT(i2 != NULL);
	CPPUNIT_ASSERT(i3 != NULL);
	CPPUNIT_ASSERT(i4 != NULL);
	CPPUNIT_ASSERT(i1->valid());
	CPPUNIT_ASSERT(!i2->valid());
	CPPUNIT_ASSERT(i3->valid());
	CPPUNIT_ASSERT(!i4->valid());

	ImageSeq one(i1), two(i2);
	CPPUNIT_ASSERT(one.addImage(i3));
	CPPUNIT_ASSERT(!one.addImage(i4));
	CPPUNIT_ASSERT(!two.addImage(i3));
	CPPUNIT_ASSERT(two.addImage(i4));

	checkSequence(one, "test/seq/test3.#", "1,3", 8, 8, "Cineon", true);
	checkSequence(two, "test/seq/test3.#", "2,4", 0, 0, "Cineon", false);
	
	delete i1;
	delete i2;
	delete i3;
	delete i4;
}

void testImageSeq::checkSequence(const ImageSeq &seq, std::string name, std::string frames,
	int width, int height, std::string format, bool valid)
{
	CPPUNIT_ASSERT_EQUAL(seq.path().fullName(), name);
	CPPUNIT_ASSERT_EQUAL(seq.frames().text(), frames);
	CPPUNIT_ASSERT(seq.dim().width() == width);
	CPPUNIT_ASSERT(seq.dim().height() == height);
	CPPUNIT_ASSERT(seq.format() != NULL);
	CPPUNIT_ASSERT_EQUAL(seq.format()->formatString(), format);		
	CPPUNIT_ASSERT(seq.valid() == valid);
}

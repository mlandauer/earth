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

#include <cppunit/extensions/HelperMacros.h>
//#include <cppunit/SourceLine.h>
//#include <cppunit/TestAssert.h>
#include "ImageSeq.h"
#include <string>

using namespace Sp;

class testImageSeqMon : public CppUnit::TestFixture
{
public:
	CPPUNIT_TEST_SUITE(testImageSeqMon);
	CPPUNIT_TEST(test);
	CPPUNIT_TEST_SUITE_END();
	
	void test();

private:
	void checkSequence(const ImageSeq &sequence, const std::string &format,
		int width, int height, const std::string &path, const std::string &frames);
};

CPPUNIT_TEST_SUITE_REGISTRATION(testImageSeqMon);

#include "DateTime.h"
#include "User.h"
#include "UserGroup.h"
#include "CachedFsObject.h"
#include "CachedFile.h"
#include "CachedImage.h"
#include "ImageSeqMon.h"


void testImageSeqMon::checkSequence(const ImageSeq &sequence,
	const std::string &format, int width, int height, const std::string &path, const std::string &frames)
{
	CPPUNIT_ASSERT_EQUAL(sequence.getFormat()->getFormatString(), format);
	CPPUNIT_ASSERT(sequence.getDim() == ImageDim(width, height));
	CPPUNIT_ASSERT_EQUAL(sequence.getPath().getFullName(), path);
	CPPUNIT_ASSERT_EQUAL(sequence.getFrames().getText(), frames);
}

void testImageSeqMon::test()
{
	// Since the ImageSeqMon class is an ImageEventObserver we can send the image update
	// messages to the object and make sure it produces the correct result. This way, we can test
	// this class without the need for an ImageMon class which will more clearly locate any problems.
	
	ImageSeqMon m;
	
	// Use these values for all the messages
	DateTime time = DateTime::current();
	User user = User::current();
	UserGroup userGroup = UserGroup::current();
	ImageFormat *cineonFormat = ImageFormat::recogniseByFormatString("Cineon");
	
	std::vector<ImageSeq> sequences;

	m.imageAdded(CachedImage(ImageDim(1024, 768), true, cineonFormat, 100, time,
		user, userGroup, Path("/foo/bar/image.0001.cin")));
	sequences = m.getImageSequences();
	CPPUNIT_ASSERT(sequences.size() == 1);
	checkSequence(sequences[0], "Cineon", 1024, 768, "/foo/bar/image.#.cin", "1");

	m.imageAdded(CachedImage(ImageDim(1024, 768), true, cineonFormat, 100, time,
		user, userGroup, Path("/foo/bar/image.0002.cin")));
	sequences = m.getImageSequences();
	CPPUNIT_ASSERT(sequences.size() == 1);
	checkSequence(sequences[0], "Cineon", 1024, 768, "/foo/bar/image.#.cin", "1-2");
	
	m.imageAdded(CachedImage(ImageDim(512, 512), true, cineonFormat, 100, time,
		user, userGroup, Path("/foo/bar/image.0003.cin")));
	sequences = m.getImageSequences();
	CPPUNIT_ASSERT(sequences.size() == 2);
	checkSequence(sequences[0], "Cineon", 1024, 768, "/foo/bar/image.#.cin", "1-2");
	checkSequence(sequences[1], "Cineon", 512, 512, "/foo/bar/image.#.cin", "3");
}


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
#include "testImage.h"
CPPUNIT_TEST_SUITE_REGISTRATION(testImage);

#include "Image.h"

using namespace Sp;

void testImage::test()
{
	Image *image1 = Image::construct("test/templateImages/8x8.sgi");
	CPPUNIT_ASSERT(image1 != NULL);
	CPPUNIT_ASSERT(image1->path().fullName() == "test/templateImages/8x8.sgi");
	CPPUNIT_ASSERT_DOUBLES_EQUAL(image1->size().getKBytes(), 0.89, 0.1);
	CPPUNIT_ASSERT(image1->formatString() == "SGI");
	CPPUNIT_ASSERT(image1->dim().width() == 8);
	CPPUNIT_ASSERT(image1->dim().height() == 8);
	delete image1;
	
	Image *image2 = Image::construct("test/templateImages/8x8.tiff");
	CPPUNIT_ASSERT(image2 != NULL);
	CPPUNIT_ASSERT(image2->path().fullName() == "test/templateImages/8x8.tiff");
	CPPUNIT_ASSERT_DOUBLES_EQUAL(image2->size().getKBytes(), 0.39, 0.1);
	CPPUNIT_ASSERT(image2->formatString() == "TIFF");
	CPPUNIT_ASSERT(image2->dim().width() == 8);
	CPPUNIT_ASSERT(image2->dim().height() == 8);
	delete image2;
		
	// *** FIT File format currently untested ****
	// *** PRMANZ File format currently untested ****
	// *** PRTEX File format currently untested ****
	
	Image *image3 = Image::construct("test/templateImages/8x8.gif");
	CPPUNIT_ASSERT(image3 != NULL);
	CPPUNIT_ASSERT(image3->path().fullName() == "test/templateImages/8x8.gif");
	CPPUNIT_ASSERT_DOUBLES_EQUAL(image3->size().getKBytes(), 0.83, 0.1);
	CPPUNIT_ASSERT(image3->formatString() == "GIF");
	CPPUNIT_ASSERT(image3->dim().width() == 8);
	CPPUNIT_ASSERT(image3->dim().height() == 8);
	delete image3;
	
	Image *image4 = Image::construct("test/templateImages/8x8.cin");
	CPPUNIT_ASSERT(image4 != NULL);
	CPPUNIT_ASSERT(image4->path().fullName() == "test/templateImages/8x8.cin");
	CPPUNIT_ASSERT_DOUBLES_EQUAL(image4->size().getKBytes(), 2.25, 0.1);
	CPPUNIT_ASSERT(image4->formatString() == "Cineon");
	CPPUNIT_ASSERT(image4->dim().width() == 8);
	CPPUNIT_ASSERT(image4->dim().height() == 8);
	delete image4;
		
	Image *image5 = Image::construct("test/templateImages/8x8.iff");
	CPPUNIT_ASSERT(image5 != NULL);
	CPPUNIT_ASSERT(image5->path().fullName() == "test/templateImages/8x8.iff");
	CPPUNIT_ASSERT_DOUBLES_EQUAL(image5->size().getKBytes(), 0.41, 0.1);
	CPPUNIT_ASSERT(image5->formatString() == "IFF");
	CPPUNIT_ASSERT(image5->dim().width() == 8);
	CPPUNIT_ASSERT(image5->dim().height() == 8);
	delete image5;
		
}


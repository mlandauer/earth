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

#include "testImage.h"
#include "Image.h"

testImage::testImage() : Tester("Image")
{
	test();
};

void testImage::test()
{
	Image *image1 = Image::construct("test/templateImages/8x8.sgi");
	if (check(image1 != NULL)) {
		checkEqual(image1->path().fullName(), "test/templateImages/8x8.sgi");
		checkEqualFloat(image1->size().getKBytes(), 0.89, 0.1);
		checkEqual(image1->formatString(), "SGI");
		checkEqual(image1->dim().width(), 8);
		checkEqual(image1->dim().height(), 8);
		delete image1;
	}
	
	Image *image2 = Image::construct("test/templateImages/8x8.tiff");
	if (check(image2 != NULL)) {
		checkEqual(image2->path().fullName(), "test/templateImages/8x8.tiff");
		checkEqualFloat(image2->size().getKBytes(), 0.39, 0.1);
		checkEqual(image2->formatString(), "TIFF");
		checkEqual(image2->dim().width(), 8);
		checkEqual(image2->dim().height(), 8);
		delete image2;
	}
		
	// *** FIT File format currently untested ****
	// *** PRMANZ File format currently untested ****
	// *** PRTEX File format currently untested ****
	
	Image *image3 = Image::construct("test/templateImages/8x8.gif");
	if (check(image3 != NULL)) {
		checkEqual(image3->path().fullName(), "test/templateImages/8x8.gif");
		checkEqualFloat(image3->size().getKBytes(), 0.83, 0.1);
		checkEqual(image3->formatString(), "GIF");
		checkEqual(image3->dim().width(), 8);
		checkEqual(image3->dim().height(), 8);
		delete image3;
	}
	
	Image *image4 = Image::construct("test/templateImages/8x8.cin");
	if (check(image4 != NULL)) {
		checkEqual(image4->path().fullName(), "test/templateImages/8x8.cin");
		checkEqualFloat(image4->size().getKBytes(), 2.25, 0.1);
		checkEqual(image4->formatString(), "Cineon");
		checkEqual(image4->dim().width(), 8);
		checkEqual(image4->dim().height(), 8);
		delete image4;
	}
		
	Image *image5 = Image::construct("test/templateImages/8x8.iff");
	if (check(image5 != NULL)) {
		checkEqual(image5->path().fullName(), "test/templateImages/8x8.iff");
		checkEqualFloat(image5->size().getKBytes(), 0.41, 0.1);
		checkEqual(image5->formatString(), "IFF");
		checkEqual(image5->dim().width(), 8);
		checkEqual(image5->dim().height(), 8);
		delete image5;
	}
		
}


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

#include "Image.h"

using namespace Sp;

class testImage : public CppUnit::TestFixture
{
public:
	CPPUNIT_TEST_SUITE(testImage);
	// *** FIT File format currently untested ****
	// *** PRMANZ File format currently untested ****
	// *** PRTEX File format currently untested ****
	CPPUNIT_TEST(testSGIImage);
	CPPUNIT_TEST( testTIFFImage);
	CPPUNIT_TEST(testGIFImage);
	CPPUNIT_TEST(testCineonImage);
	CPPUNIT_TEST(testIFFImage);
	CPPUNIT_TEST(testNotFile);
	CPPUNIT_TEST(testInvalidCineonImage);
	CPPUNIT_TEST(testImageFormat);
	CPPUNIT_TEST_SUITE_END();
	
	void testSGIImage();
	void testTIFFImage();
	void testGIFImage();
	void testCineonImage();
	void testIFFImage();
	
	void testNotFile();
	void testInvalidCineonImage();
	void testImageFormat();
	
private:
	void checkImage(Image *image, bool valid, const std::string &name, float sizeKb,
		const std::string &format, int width, int height);

};

CPPUNIT_TEST_SUITE_REGISTRATION(testImage);

void testImage::testSGIImage()
{
	Image *image = Image::construct("test/templateImages/8x8.sgi");
	checkImage(image, true, "test/templateImages/8x8.sgi", 0.89, "SGI", 8, 8);
	delete image;
}

void testImage::testTIFFImage()
{
	Image *image = Image::construct("test/templateImages/8x8.tiff");
	checkImage(image, true, "test/templateImages/8x8.tiff", 0.39, "TIFF", 8, 8);
	delete image;
}

void testImage::testGIFImage()
{
	Image *image = Image::construct("test/templateImages/8x8.gif");
	checkImage(image, true, "test/templateImages/8x8.gif", 0.83, "GIF", 8, 8);
	delete image;
}

void testImage::testCineonImage()
{
	Image *image = Image::construct("test/templateImages/8x8.cin");
	checkImage(image, true, "test/templateImages/8x8.cin", 2.25, "Cineon", 8, 8);
	delete image;
}

void testImage::testIFFImage()
{
	Image *image = Image::construct("test/templateImages/8x8.iff");
	checkImage(image, true, "test/templateImages/8x8.iff", 0.41, "IFF", 8, 8);
	delete image;	
}

void testImage::testInvalidCineonImage()
{
	Image *image = Image::construct("test/templateImages/8x8.cin-invalid");
	checkImage(image, false, "test/templateImages/8x8.cin-invalid", 0.13, "Cineon", 0, 0);
	delete image;		
}

void testImage::testNotFile()
{
	// A file that doesn't exist
	Image *image = Image::construct("test/templateImages/foo.blah");
	CPPUNIT_ASSERT(image == NULL);
}

void testImage::testImageFormat()
{
	// Check that we can find image formats by name
	ImageFormat *format = ImageFormat::recogniseByFormatString("Cineon");
	CPPUNIT_ASSERT(ImageFormat::recogniseByFormatString("Cineon") != NULL);
	CPPUNIT_ASSERT(ImageFormat::recogniseByFormatString("Cineon")->getFormatString() == "Cineon");
	CPPUNIT_ASSERT(ImageFormat::recogniseByFormatString("TIFF") != NULL);
	CPPUNIT_ASSERT(ImageFormat::recogniseByFormatString("TIFF")->getFormatString() == "TIFF");
	CPPUNIT_ASSERT(ImageFormat::recogniseByFormatString("Non-existant file format") == NULL);
}

void testImage::checkImage(Image *image, bool valid, const std::string &name, float sizeKb,
	const std::string &format, int width, int height)
{
	CPPUNIT_ASSERT(image != NULL);
	CPPUNIT_ASSERT(image->valid() == valid);
	CPPUNIT_ASSERT(image->getPath().getFullName() == name);
	CPPUNIT_ASSERT_DOUBLES_EQUAL(image->getSize().getKBytes(), sizeKb, 0.1);
	CPPUNIT_ASSERT(image->getFormatString() == format);
	CPPUNIT_ASSERT(image->getDim().getWidth() == width);
	CPPUNIT_ASSERT(image->getDim().getHeight() == height);
}


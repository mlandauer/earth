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

class testPath : public CppUnit::TestFixture
{
public:
	CPPUNIT_TEST_SUITE(testPath);
	CPPUNIT_TEST(test);
	CPPUNIT_TEST_SUITE_END();
	
	void test();
};

CPPUNIT_TEST_SUITE_REGISTRATION(testPath);

#include "Path.h"

using namespace Sp;

void testPath::test()
{
	Path p("/home/blah/foo.tif");
	CPPUNIT_ASSERT(p.getFullName() == "/home/blah/foo.tif");
	CPPUNIT_ASSERT(p.getRoot() == "/home/blah/");
	CPPUNIT_ASSERT(p.getRelative() == "foo.tif");
	Path p2("/home/blah/");
	CPPUNIT_ASSERT(p2.getFullName() == "/home/blah");
	CPPUNIT_ASSERT(p2.getRoot() == "/home/");
	CPPUNIT_ASSERT(p2.getRelative() == "blah");
	Path p3("blah");
	CPPUNIT_ASSERT(p3.getFullName() == "blah");
	CPPUNIT_ASSERT(p3.getRoot() == "");
	CPPUNIT_ASSERT(p3.getRelative() == "blah");
	Path p4("/home/blah///");
	CPPUNIT_ASSERT(p4.getFullName() == "/home/blah");
	CPPUNIT_ASSERT(p4.getRoot() == "/home/");
	CPPUNIT_ASSERT(p4.getRelative() == "blah");
	Path p5("/blah");
	CPPUNIT_ASSERT(p5.getFullName() == "/blah");
	CPPUNIT_ASSERT(p5.getRoot() == "/");
	CPPUNIT_ASSERT(p5.getRelative() == "blah");
	// check that paths can be ordered alphabetically
	Path p6("alpha");
	Path p7("beta");
	Path p8("gamma");
	Path p9("gammb");
	Path p10("gammb");
	CPPUNIT_ASSERT(p6 < p7);
	CPPUNIT_ASSERT(p6 < p8);
	CPPUNIT_ASSERT(p6 < p9);
	CPPUNIT_ASSERT(p7 < p8);
	CPPUNIT_ASSERT(p7 < p9);
	CPPUNIT_ASSERT(p8 < p9);
	// The reverse
	CPPUNIT_ASSERT(!(p7 < p6));
	CPPUNIT_ASSERT(!(p8 < p6));
	CPPUNIT_ASSERT(!(p9 < p6));
	CPPUNIT_ASSERT(!(p8 < p7));
	CPPUNIT_ASSERT(!(p9 < p7));
	CPPUNIT_ASSERT(!(p9 < p8));
	// Equality
	CPPUNIT_ASSERT(p9 == p10);
	CPPUNIT_ASSERT(p6 == p6);
	CPPUNIT_ASSERT(!(p6 == p7));
}

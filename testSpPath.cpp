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

#include "testSpPath.h"
#include "SpPath.h"

testSpPath::testSpPath() : SpTester("SpPath")
{
	test();
};

void testSpPath::test()
{
	SpPath p("/home/blah/foo.tif");
	checkEqual("test 1", p.fullName(), "/home/blah/foo.tif");
	checkEqual("test 2", p.root(),     "/home/blah/");
	checkEqual("test 3", p.relative(), "foo.tif");
	SpPath p2("/home/blah/");
	checkEqual("test 4", p2.fullName(), "/home/blah");
	checkEqual("test 5", p2.root(),     "/home/");
	checkEqual("test 6", p2.relative(), "blah");
	SpPath p3("blah");
	checkEqual("test 7", p3.fullName(), "blah");
	checkEqual("test 8", p3.root(),     "");
	checkEqual("test 9", p3.relative(), "blah");
	SpPath p4("/home/blah///");
	checkEqual("test 10", p4.fullName(), "/home/blah");
	checkEqual("test 11", p4.root(),     "/home/");
	checkEqual("test 12", p4.relative(), "blah");
	SpPath p5("/blah");
	checkEqual("test 13", p5.fullName(), "/blah");
	checkEqual("test 14", p5.root(),     "/");
	checkEqual("test 15", p5.relative(), "blah");
	// Check that paths can be ordered alphabetically
	SpPath p6("alpha");
	SpPath p7("beta");
	SpPath p8("gamma");
	SpPath p9("gammb");
	SpPath p10("gammb");
	check("test 16", p6 < p7);
	check("test 17", p6 < p8);
	check("test 18", p6 < p9);
	check("test 19", p7 < p8);
	check("test 20", p7 < p9);
	check("test 21", p8 < p9);
	// The reverse
	check("test 16", !(p7 < p6));
	check("test 17", !(p8 < p6));
	check("test 18", !(p9 < p6));
	check("test 19", !(p8 < p7));
	check("test 20", !(p9 < p7));
	check("test 21", !(p9 < p8));
	// Equality
	check("test 22", p9 == p10);
	check("test 23", p6 == p6);
	check("test 24", !(p6 == p7));
}

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

#include "testPath.h"
#include "Path.h"

testPath::testPath() : Tester("Path")
{
	test();
};

void testPath::test()
{
	Path p("/home/blah/foo.tif");
	checkEqual(p.fullName(), "/home/blah/foo.tif");
	checkEqual(p.root(),     "/home/blah/");
	checkEqual(p.relative(), "foo.tif");
	Path p2("/home/blah/");
	checkEqual(p2.fullName(), "/home/blah");
	checkEqual(p2.root(),     "/home/");
	checkEqual(p2.relative(), "blah");
	Path p3("blah");
	checkEqual(p3.fullName(), "blah");
	checkEqual(p3.root(),     "");
	checkEqual(p3.relative(), "blah");
	Path p4("/home/blah///");
	checkEqual(p4.fullName(), "/home/blah");
	checkEqual(p4.root(),     "/home/");
	checkEqual(p4.relative(), "blah");
	Path p5("/blah");
	checkEqual(p5.fullName(), "/blah");
	checkEqual(p5.root(),     "/");
	checkEqual(p5.relative(), "blah");
	// Check that paths can be ordered alphabetically
	Path p6("alpha");
	Path p7("beta");
	Path p8("gamma");
	Path p9("gammb");
	Path p10("gammb");
	check(p6 < p7);
	check(p6 < p8);
	check(p6 < p9);
	check(p7 < p8);
	check(p7 < p9);
	check(p8 < p9);
	// The reverse
	check(!(p7 < p6));
	check(!(p8 < p6));
	check(!(p9 < p6));
	check(!(p8 < p7));
	check(!(p9 < p7));
	check(!(p9 < p8));
	// Equality
	check(p9 == p10);
	check(p6 == p6);
	check(!(p6 == p7));
}

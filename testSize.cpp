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

#include "testSize.h"
#include "SpSize.h"

testSize::testSize() : Tester("Size")
{
	test();
};

void testSize::test() {
	Size s;
	s.setBytes(4097);
	checkEqual("test 1", s.bytes(), 4097.0);
	checkEqual("test 2", s.kbytes(), 4.0);
	checkEqual("test 3", s.mbytes(), 0.0);
	checkEqual("test 4", s.gbytes(), 0.0);

	s.setGBytes(10);
	checkEqual("test 5", s.gbytes(), 10.0);
	checkEqual("test 6", s.mbytes(), 10240.0);
	checkEqual("test 7", s.kbytes(), 10485760.0);
	checkEqual("test 8", s.bytes(), 1.073741e10, 10e5);
	
	s.setBytes(0);
	checkEqual("test 9", s.bytes(), 0.0);
	checkEqual("test 10", s.kbytes(), 0.0);
	checkEqual("test 11", s.mbytes(), 0.0);
	checkEqual("test 12", s.gbytes(), 0.0);
}


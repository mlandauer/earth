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
#include "Size.h"

testSize::testSize() : Tester("Size")
{
	test();
};

void testSize::test() {
	Size s = Size::Bytes(4097);
	checkEqual(s.getBytes(), 4097.0);
	checkEqual(s.getKBytes(), 4.0);
	checkEqual(s.getMBytes(), 0.0);
	checkEqual(s.getGBytes(), 0.0);

	s = Size::GBytes(10);
	checkEqual(s.getGBytes(), 10.0);
	checkEqual(s.getMBytes(), 10240.0);
	checkEqual(s.getKBytes(), 10485760.0);
	checkEqualDelta(s.getBytes(), 1.073741e10, 10e5);
	
	s = Size::Bytes(0);
	checkEqual(s.getBytes(), 0.0);
	checkEqual(s.getKBytes(), 0.0);
	checkEqual(s.getMBytes(), 0.0);
	checkEqual(s.getGBytes(), 0.0);
}


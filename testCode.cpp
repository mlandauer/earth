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
// Some very simple test code

#include <stream.h>
#include <algorithm>
#include <vector>

#include "File.h"
#include "Image.h"
#include "FsObject.h"
#include "Dir.h"
#include "Tester.h"
#include "ImageSeq.h"

#include "testSize.h"
#include "testDateTime.h"
#include "testDir.h"
#include "testFile.h"
#include "testImage.h"
#include "testFsObject.h"
#include "testPath.h"
#include "testImageSeq.h"
#include "testFsObjectHandle.h"

int main(int argc, char **argv)
{
	// Register the plugins
	ImageFormat::registerPlugins();
	// Configure the tester
	Tester::setVerbose(false);
	Tester::setFloatDelta(0.1);
	// To make tests reliable have to ensure that ls() always
	// returns things in alphabetical order.
	Dir::setSortByPath(true);
	
	testDir();
	testSize();
	testDateTime();
	testFile();
	testImage();
	testFsObject();
	testPath();
	testImageSeq();
	testFsObjectHandle();
	
	Tester::finish();
	ImageFormat::deRegisterPlugins();
}



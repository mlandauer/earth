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
//  $Id$

// The command line interface to Earth
// Usage:
//     earth <directory>
// Specify a directory and it will parse the whole filesystem below that directory
// and extract a list of image sequences which will be send to standard out

#include <iostream>
#include <string>
#include "IndexDirectory.h"
#include "ImageFormat.h"

using namespace Sp;

void info(std::string programName)
{
	std::cout << "The command line interface to Earth" << std::endl;
	std::cout << "Usage:" << std::endl;
	std::cout << "\t" << programName << " <directory>" << std::endl;
	std::cout << "Specify a directory and it will parse the whole filesystem below that directory" << std::endl;
	std::cout << "and extract a list of image sequences which will be send to standard out." << std::endl;
}

void index(std::string directoryName)
{
	IndexDirectory i;
	std::vector<ImageSeq> s = i.getImageSequences(directoryName);
	std::cout << "path\twidth x height\tformat\tframes" << std::endl;
	std::cout << std::endl;
	for (std::vector<ImageSeq>::iterator i = s.begin(); i != s.end(); ++i) {
		std::cout << i->path().fullName() << "\t" << i->dim().width() << "x" << i->dim().height() << "\t"
			<< i->format()->formatString() << "\t" << i->framesString() << std::endl;
	}
}

int main(int argc, char **argv)
{
	// Parse arguments
	if (argc != 2)
		info(argv[0]);
	std::string directoryName(argv[1]);
	
	// Register the plugins
	ImageFormat::registerPlugins();
	
	index(directoryName);
	
	ImageFormat::deRegisterPlugins();
	return 0;
}


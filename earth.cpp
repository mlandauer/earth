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
#include <getopt.h>
#include <sstream>
#include <libxml++/libxml++.h>

#include "IndexDirectory.h"
#include "ImageFormat.h"

using namespace Sp;

void info(std::string programName)
{
	std::cout << "The command line interface to Earth" << std::endl;
	std::cout << "Usage:" << std::endl;
	std::cout << "\t" << programName << " [--xml] <directory>" << std::endl;
	std::cout << "Specify a directory and it will parse the whole filesystem below that directory" << std::endl;
	std::cout << "and extract a list of image sequences which will be sent to standard out." << std::endl;
	std::cout << std::endl;
	std::cout << "Options: --xml  output XML to standard out (instead of human-readable form)" << std::endl;
}

void printHumanReadable(const std::vector<ImageSeq> &s)
{
	std::cout << "<image format>\t<image size>\t<path>\t<frames>" << std::endl;
	std::cout << std::endl;
	for (std::vector<ImageSeq>::const_iterator i = s.begin(); i != s.end(); ++i) {
		if (i->valid()) {
			std::cout << i->getFormat()->getFormatString() << "\t"
				<< i->getDim().getWidth() << "x" << i->getDim().getHeight() << "\t"
				<< i->getPath().getFullName() << "\t"
				<< i->getFrames().getText() << std::endl;
		}
		else {
			std::cout << "INVALID " << i->getFormat()->getFormatString() << "\t\t"
				<< i->getPath().getFullName() << "\t"
				<< i->getFrames().getText() << std::endl;
		}
	}
}

void printXML(const std::vector<ImageSeq> &s)
{
	try {
		xmlpp::DomParser parser;

		xmlpp::Node* nodeRoot = parser.set_root_node("sequences");
		
		for (std::vector<ImageSeq>::const_iterator i = s.begin(); i != s.end(); ++i) {
			if (i->valid()) {			
				xmlpp::Element* nodeSequence = nodeRoot->add_child("sequence");
				
				std::stringstream wss, hss;
				wss << i->getDim().getWidth();
				hss << i->getDim().getHeight();
				std::string widthString(wss.str()), heightString(hss.str());
				
				nodeSequence->add_child("valid")->set_child_content("true");
				nodeSequence->add_child("format")->set_child_content(i->getFormat()->getFormatString());
		 		nodeSequence->add_child("width")->set_child_content(widthString);
		 		nodeSequence->add_child("height")->set_child_content(heightString);
		 		nodeSequence->add_child("path")->set_child_content(i->getPath().getFullName());
		 		nodeSequence->add_child("frames")->set_child_content(i->getFrames().getText());
			}
			else {
				xmlpp::Element* nodeSequence = nodeRoot->add_child("sequence");
				
				std::stringstream wss, hss;
				wss << i->getDim().getWidth();
				hss << i->getDim().getHeight();
				std::string widthString(wss.str()), heightString(hss.str());
				
				nodeSequence->add_child("valid")->set_child_content("false");
				nodeSequence->add_child("format")->set_child_content(i->getFormat()->getFormatString());
		 		nodeSequence->add_child("path")->set_child_content(i->getPath().getFullName());
		 		nodeSequence->add_child("frames")->set_child_content(i->getFrames().getText());
			}
		}
 		std::cout << parser.write_to_string() << std::endl;
	}
	catch(const std::exception& ex)
	{
		std::cout << "Exception caught: " << ex.what() << std::endl;
	}
}

int main(int argc, char **argv)
{
	// The following parameters are parsed from the command line parameters
	std::string directoryName;
	bool xmlOutput = false;
	
	while (1) {
		static struct option long_options[] = {
			{"xml", 0, 0, 0},
			{0, 0, 0, 0}
		};
		int option_index = 0;

		int c = getopt_long (argc, argv, "", long_options, &option_index);
		if (c == -1)
			break;

		switch (c) {
			case 0:
				if (long_options[option_index].name == "xml")
					xmlOutput = true;
				break;

 			default:
 				std::cerr << "Parsing problem" << std::endl << std::endl;
 				info(argv[0]);
 				return 1;
		}
	}

	// There should only be one parameter left
	if (argc - optind != 1) {
		std::cerr << "Incorrect number of parameters" << std::endl << std::endl;
		info(argv[0]);
		return 1;
	}
	
	directoryName = std::string(argv[optind++]);
	
	// Register the plugins
	ImageFormat::registerPlugins();
	
	IndexDirectory i;
	std::vector<ImageSeq> s = i.getImageSequences(directoryName);
	if (xmlOutput)
		printXML(s);
	else
		printHumanReadable(s);
	
	ImageFormat::deRegisterPlugins();
	return 0;
}


//  Copyright (C) 2001 Matthew Landauer. All Rights Reserved.
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

#include <fstream>
#include <iostream>

#include "SpImageFormat.h"
#include "SpFile.h"

std::list<SpImageFormat *> SpImageFormat::plugins;
SpLibLoader SpImageFormat::loader;

// Register all the supported image types
void SpImageFormat::registerPlugins()
{
	const char formatsFilename[] = "imageFormats.conf";
	std::ifstream formats(formatsFilename);
	if (!formats) {
		std::cerr << "SpImageFormat::registerPlugins(): Could not open image formats file: "
			<< formatsFilename << std::endl;
		return;
	}
	while (formats) {
		std::string libraryFilename;
		formats >> libraryFilename;
		loader.load(libraryFilename);
	}
}

void SpImageFormat::addPlugin(SpImageFormat *plugin)
{
	plugins.push_back(plugin);
}

SpImageFormat* SpImageFormat::recentPlugin()
{
	return *(--plugins.end());
}

void SpImageFormat::removePlugin(SpImageFormat *plugin)
{
	plugins.remove(plugin);
}

void SpImageFormat::deRegisterPlugins()
{
	loader.releaseAll();
}

SpImageFormat* SpImageFormat::recogniseByMagic(const SpPath &path)
{
	// Figure out what the greatest amount of the header that needs
	// to be read so that all the plugins can recognise themselves.
	int largestSizeToRecognise = 0;
	for (std::list<SpImageFormat *>::iterator a = plugins.begin();
		a != plugins.end(); ++a)
		if ((*a)->sizeToRecognise() > largestSizeToRecognise)
			largestSizeToRecognise = (*a)->sizeToRecognise();
			
	// Create a temporary file object
	unsigned char *buf = new unsigned char[largestSizeToRecognise];
	SpFile f(path);
	f.open();
	f.read(buf, largestSizeToRecognise);
	f.close();
	
	// See if any of the plugins recognise themselves.
	for (std::list<SpImageFormat *>::iterator a = plugins.begin();
		a != plugins.end(); ++a)
		if ((*a)->recognise(buf)) {
			delete buf;
			return (*a);
		}
	delete buf;
	return (NULL);
}

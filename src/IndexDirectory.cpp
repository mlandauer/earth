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
//  $Id: IndexDirectory.cpp,v 1.4 2003/01/28 23:23:32 mlandauer Exp $

#include "IndexDirectory.h"
#include "Dir.h"
#include "Sequences.h"

namespace Sp {

std::vector<ImageSeq> IndexDirectory::getImageSequences(const Path &path) const
{
	Dir d(path);
	assert(d.valid());
	
	std::vector<File> files = d.listFilesRecursive();
	// Make a list of image sequences from this
	Sequences sequences;
	for (std::vector<File>::iterator i = files.begin(); i != files.end(); ++i) {
		Image *image = Image::construct(i->getPath());
		// Doesn't correctly take account of whether the image is valid or not
		if (image != NULL) {
			sequences.addImage(CachedImage(image));
		}
	}
	return sequences.getSequences();
}

}

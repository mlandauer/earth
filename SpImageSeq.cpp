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

#include <stdio.h>
#include "SpImageSeq.h"

ImageSeq::ImageSeq(Image *i)
{
	p = pattern(i->path());
	f.insert(frameNumber(i->path()));
	imageFormat = i->getFormat();
	dimensions = i->dim();
}

void ImageSeq::addImage(Image *i)
{
	if (couldBePartOfSequence(i))
		f.insert(frameNumber(i->path()));
}

void ImageSeq::removeImage(Image *i)
{
	if (partOfSequence(i))
		f.erase(frameNumber(i->path()));
}

void ImageSeq::removeImage(const Path &p)
{
	if (partOfSequence(p))
		f.erase(frameNumber(p));
}

bool ImageSeq::partOfSequence(Image *i) const
{
	if (!couldBePartOfSequence(i))
		return false;
	int no = frameNumber(i->path());
	return (f.find(no) != f.end());
}

bool ImageSeq::partOfSequence(const Path &path) const
{
	if (pattern(path) == p) {
    int no = frameNumber(path);
    return (f.find(no) != f.end());
  }
  else
		return false;
}

bool ImageSeq::couldBePartOfSequence(Image *i) const
{
	// Check that the name of the image matches the name of the sequence
	return (pattern(i->path()) == p) && (i->getFormat() == imageFormat)
		&& (i->dim() == dimensions);
}

std::string ImageSeq::framesString() const
{
	std::string r;
	char buf[100];
	int count = 0;
	std::set<int>::iterator a = f.begin();
	while (a != f.end()) {
		int start = *a;
		int current = *a;
		a++;
		while ((*a == current + 1) && (a != f.end())) {
			current = *a;
			a++;
		}
		int end = current;
		if (start == end)
			sprintf(buf, "%i", start);
		else
			sprintf(buf, "%i-%i", start, end);
		if (count > 0)
			r += ",";
		r += std::string(buf);
		count++;
	}
	return r;
}

Path ImageSeq::path() const
{
	return p;
}

Path ImageSeq::pattern(const Path &a) const
{
	std::string s = a.fullName();
	// Search backwards from the end for numbers
	std::string::size_type last = s.find_last_of("0123456789");
	std::string::size_type first = s.find_last_not_of("0123456789", last) + 1;
	int size = last - first + 1;
	s.replace(first, size, hash(size));
	return Path(s);
}

int ImageSeq::frameNumber(const Path &a) const
{
	std::string s = a.fullName();
	// Search backwards from the end for numbers
	std::string::size_type last = s.find_last_of("0123456789");
	std::string::size_type first = s.find_last_not_of("0123456789", last) + 1;
	int size = last - first + 1;
	std::string number = s.substr(first, size);
	unsigned int r;
	sscanf(number.c_str(), "%u", &r);
	return r;
}

// Returns the correct replacement for a number based on the number of
// characters
std::string ImageSeq::hash(int size) const
{
	if (size == 4)
		return "#";
	else
		return std::string(size, '@');	
}

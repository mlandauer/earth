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

#include <stdio.h>
#include "ImageSeq.h"

namespace Sp {

/*!
	\todo should give values to imageFormat and dimensions when image not valid
*/
ImageSeq::ImageSeq(Image *i)
{
	p = pattern(i->path());
	frames.add(frameNumber(i->path()));
	m_valid = i->valid();
	imageFormat = i->getFormat();
	dimensions = i->dim();
}

bool ImageSeq::addImage(Image *i)
{
	if (couldBePartOfSequence(i)) {
		frames.add(frameNumber(i->path()));
    return true;
  }
  else {
    return false;
  }
}

bool ImageSeq::removeImage(Image *i)
{
	if (partOfSequence(i)) {
		return frames.remove(frameNumber(i->path()));
  }
  else {
    return false;
  }
}

bool ImageSeq::removeImage(const Path &p)
{
	if (partOfSequence(p)) {
		return frames.remove(frameNumber(p));
  }
  else {
    return false;
  }
}

bool ImageSeq::partOfSequence(Image *i) const
{
	if (couldBePartOfSequence(i)) {
		return (frames.partOfSequence(frameNumber(i->path())));
  }
  else {
		return false;
  }
}

bool ImageSeq::partOfSequence(const Path &path) const
{
	if (couldBePartOfSequence(path)) {
		return (frames.partOfSequence(frameNumber(path)));
  }
  else
		return false;
}

bool ImageSeq::couldBePartOfSequence(const Path &path) const
{
	// Check that the name of the image matches the name of the sequence
  return (pattern(path) == p);
}

bool ImageSeq::couldBePartOfSequence(Image *i) const
{
	// Check that the name of the image matches the name of the sequence
	if ((pattern(i->path()) == p) && (i->valid() == m_valid)) {
		if (m_valid) {
			return (i->getFormat() == imageFormat) && (i->dim() == dimensions);
		}
		else {
			return true;
		}
	}
	else {
		return false;
	}
}

std::string ImageSeq::framesString() const
{
	return frames.text();
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

}

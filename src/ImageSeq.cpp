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
// $Id: ImageSeq.cpp,v 1.14 2003/02/03 04:50:35 mlandauer Exp $

#include <stdio.h>
#include "ImageSeq.h"

namespace Sp {

/*!
	\todo should give values to imageFormat and dimensions when image not valid
*/
ImageSeq::ImageSeq(const CachedImage &image)
{
	p = pattern(image.getPath());
	int frame = frameNumber(image.getPath());
	// If frame is -1 there is no frame number in the path
	if (frame != -1) {
		m_frames.add(frame);
	}
	m_valid = image.valid();
	imageFormat = image.getFormat();
	dimensions = image.getDim();
}

bool ImageSeq::addImage(const CachedImage &image)
{
	if (couldBePartOfSequence(image)) {
		m_frames.add(frameNumber(image.getPath()));
    return true;
  }
  else {
    return false;
  }
}

bool ImageSeq::removeImage(const Path &p)
{
	if (partOfSequence(p)) {
		return m_frames.remove(frameNumber(p));
  }
  else {
    return false;
  }
}

bool ImageSeq::partOfSequence(const CachedImage &image) const
{
	if (couldBePartOfSequence(image)) {
		return (m_frames.partOfSequence(frameNumber(image.getPath())));
  }
  else {
		return false;
  }
}

bool ImageSeq::partOfSequence(const Path &path) const
{
	if (couldBePartOfSequence(path)) {
		return (m_frames.partOfSequence(frameNumber(path)));
  }
  else
		return false;
}

bool ImageSeq::couldBePartOfSequence(const Path &path) const
{
	// Check that the name of the image matches the name of the sequence
  return (pattern(path) == p);
}

bool ImageSeq::couldBePartOfSequence(const CachedImage &image) const
{
	// Check that the name of the image matches the name of the sequence
	if ((pattern(image.getPath()) == p) && (image.valid() == m_valid)) {
		if (m_valid) {
			return (image.getFormat() == imageFormat) && (image.getDim() == dimensions);
		}
		else {
			return true;
		}
	}
	else {
		return false;
	}
}

Frames ImageSeq::getFrames() const
{
	return m_frames;
}

Path ImageSeq::getPath() const
{
	return p;
}

Path ImageSeq::pattern(const Path &a) const
{
	std::string s = a.getFullName();
	std::string::size_type first, size;
	if (findLastNumber(s, first, size)) {
		s.replace(first, size, hash(size));
		return Path(s);
	}
	else {
		return a;
	}
}

/*!
	/return false if there are no numbers in the string
*/
bool ImageSeq::findLastNumber(const std::string &s, std::string::size_type &pos, std::string::size_type &size) const
{
	// Search backwards from the end for numbers
	std::string::size_type last = s.find_last_of("0123456789");
	if (last == std::string::npos)
		return false;
	pos = s.find_last_not_of("0123456789", last) + 1;
	size = last - pos + 1;
	return true;
}

/*!
	/return -1 if there is no frame number in the path
*/
int ImageSeq::frameNumber(const Path &a) const
{
	std::string s = a.getFullName();
	std::string::size_type first, size;

	if (findLastNumber(s, first, size)) {
		std::string number = s.substr(first, size);
		unsigned int r;
		sscanf(number.c_str(), "%u", &r);
		return r;
	}
	else {
		return -1;
	}
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

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
// $Id: ImageSeq.h,v 1.15 2003/02/03 04:50:35 mlandauer Exp $

#ifndef _imageseq_h_
#define _imageseq_h_

#include <string>
#include "Image.h"
#include "Frames.h"
#include "CachedImage.h"

namespace Sp {

//! A sequence of image files
class ImageSeq
{
public:
	//! Construct an image sequence from a single image
	ImageSeq(const CachedImage &image);

	//! Add an image to current sequence
	/*!
		The image must be part of the sequence. This can be checked with couldBePartOfSequence.
	*/
	void addImage(const CachedImage &image);

	//! Remove an image from the current sequence
	/*!
		The image must be part of the sequence. This can be checked with partOfSequence.
	*/
	void removeImage(const Path &p);

	//! Returns the path of the image sequence
	/*!
		A four padded frame number is represented by "#" and an arbitrary length
		frame padding is represented by a number of "@".
	*/
	Path getPath() const;

	//! Returns the size of the images in the sequence
	/*!
		For images to be part of the same sequence they all have to have the same dimensions.
	*/
	ImageDim getDim() const { return dimensions; };

	//! Returns the image format of the images in the sequence
	/*!
		For images to be part of the same sequence they all have to have the same image format.
	*/
	ImageFormat* getFormat() const { return imageFormat; };
	
	//! Returns the frames in this sequence
	Frames getFrames() const;
	
	//! Is this a sequence consisting of valid images?
	bool valid() const { return m_valid; }
	
	//! Could this image be part of this sequence?
	bool couldBePartOfSequence(const CachedImage &image) const;
	//! Is this image part of this sequence?
	bool partOfSequence(const Path &p) const;
	
private:
	Frames m_frames;
	Path p;
	bool findLastNumber(const std::string &s, std::string::size_type &pos, std::string::size_type &size) const;
	Path pattern(const Path &a) const;
	int frameNumber(const Path &a) const;
	std::string hash(int size) const;

	// Image/Sequence attributes
	ImageFormat *imageFormat;
	ImageDim dimensions;
	bool m_valid;
};

}

#endif

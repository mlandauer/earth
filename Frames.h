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

#ifndef _frames_h_
#define _frames_h_

#include <set>

namespace Sp {

//! A sequence of frame numbers
/*!
	This is a utility class for storing a list of frame numbers. It's main benefit is that it
	abstracts the short hand description of the list as a string such as "1-245".
*/
class Frames
{
private:
	std::set<int> f;
	
public:
	//! Add a frame to the sequence
	void add(int frame);
	
	//! Remove a frame from the sequence
	/*!
		\return false if frame is originally not part of the sequence
	*/
	bool remove(int frame);
	
	//! Returns whether frame is in this sequence
	bool partOfSequence(int frame) const;
	
	//! Returns a concise string containing the range of frames in this sequence
	/*!
		For example, a continuous frame range is written as "1-245" and a discontinuous
		range is written as "1-145,147-240,242,245"
	*/
	std::string getText() const;
};

}

#endif

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

// A utility class for keeping of track of file or sequence sizes using
// either a measure of bytes, Kb, Mb, etc...

#include "Size.h"

namespace Sp {

Size::Size() : kb(0)
{
}

Size::~Size()
{
}

Size Size::Bytes(float n)
{
  Size s;
  s.kb = n / 1024;
  return s;
}

Size Size::KBytes(float n)
{
  Size s;
	s.kb = n;
  return s;
}

Size Size::MBytes(float n)
{
  Size s;
	s.kb = n * 1024;
  return s;
}

Size Size::GBytes(float n)
{
  Size s;
	s.kb = n * 1024 * 1024;
  return s;
}

float Size::getBytes() const
{
	return kb * 1024;
}

float Size::getKBytes() const
{
	return kb;
}

float Size::getMBytes() const
{
	return kb / 1024;
}

float Size::getGBytes() const
{
	return kb / 1024 / 1024;
}

}


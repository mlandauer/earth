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

#ifndef _spdirmon_h_
#define _spdirmon_h_

#include "SpDir.h"

class SpDirMonObserver
{
	public:
		virtual void notifyChanged(SpFsObject *o) = 0;
		virtual void notifyDeleted(SpFsObject *o) = 0;
		virtual void notifyAdded(SpFsObject *o) = 0;
};

// This class monitors just one directory and its contents
class SpDirMon
{
	public:
		~SpDirMon() { }
		static SpDirMon * construct(const SpDir &d, SpDirMonObserver *o);
		virtual void update() = 0;
		void setMaxEvents(int number) { maxEvents = number; };
		int getMaxEvents() { return maxEvents; };
	protected:
		SpDirMon() : maxEvents(1000) { }
		virtual bool start(const SpDir &d) = 0;
		virtual bool stop() = 0;
		void notifyChanged(SpFsObject *o);
		void notifyDeleted(SpFsObject *o);
		void notifyAdded(SpFsObject *o);
		int maxEvents;
	private:
		SpDirMonObserver *observer;
};


#endif

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

#include <queue>
#include "SpDir.h"

class SpDirMonEvent
{
	public:
		enum SpCode {changed, deleted, added, null};
		SpDirMonEvent(SpCode c = null, const SpPath &p = "") : code(c), path(p) { }
		~SpDirMonEvent() { }
		SpCode getCode() const { return code; }
		SpPath getPath() const { return path; }
		bool operator==(const SpDirMonEvent &e) const {
			return ((code == e.code) && (path == e.path));
		}
	private:
		SpCode code;
		SpPath path;
};

// This class monitors just one directory and its contents
class SpDirMon
{
	public:
		~SpDirMon() { }
		static SpDirMon * construct(const SpDir &d);
		bool pendingEvent();
		SpDirMonEvent getNextEvent();
	protected:
		virtual bool start(const SpDir &d) = 0;
		virtual bool stop() = 0;
		virtual void update() = 0;
		void notifyChanged(const SpPath &path);
		void notifyDeleted(const SpPath &path);
		void notifyAdded(const SpPath &path);
	private:
		queue<SpDirMonEvent> eventQueue;
};


#endif

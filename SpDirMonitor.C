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

#include "SpDirMonitor.h"
#include "SpDirMonitorFam.h"

SpDirMonitor * SpDirMonitor::construct(const SpDir &d) {
	SpDirMonitor *m = new SpDirMonitorFam;
	if (!m->start(d)) {
		delete m;
		return NULL;
	}
	else 
		return m;
}

bool SpDirMonitor::pendingEvent() {
	update();
	return (!eventQueue.empty());
}

SpDirMonitorEvent SpDirMonitor::getNextEvent() {
	if (eventQueue.empty())
		return SpDirMonitorEvent(SpDirMonitorEvent::null);
	else {
		SpDirMonitorEvent e = eventQueue.front();
		eventQueue.pop();
		return e;
	}
}

void SpDirMonitor::notifyChanged(const SpPath &path) {
	eventQueue.push(SpDirMonitorEvent(SpDirMonitorEvent::changed, path));
}
	
void SpDirMonitor::notifyDeleted(const SpPath &path) {
	eventQueue.push(SpDirMonitorEvent(SpDirMonitorEvent::deleted, path));
}
	
void SpDirMonitor::notifyAdded(const SpPath &path) {
	eventQueue.push(SpDirMonitorEvent(SpDirMonitorEvent::added, path));
}


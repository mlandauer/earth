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

#include "testSpDirMon.h"

testSpDirMonitor::testSpDirMonitor() : SpTester("SpDirMonitor")
{
	test();
};

void testSpDirMonitor::checkNextEvent(string testName, SpDirMon *m, const SpDirMonEvent &event)
{
	m->update();
	check(testName + "a", event == nextEvent);
}

SpDirMonEvent::SpType testSpDirMonitor::type(SpFsObjectHandle o)
{
	if (dynamic_cast<SpDir *>(o.pointer()))
		return SpDirMonEvent::dir;
	else
		return SpDirMonEvent::file;
}

void testSpDirMonitor::notifyChanged(SpFsObjectHandle o)
{
	nextEvent = SpDirMonEvent(SpDirMonEvent::changed, type(o), o->path());
}

void testSpDirMonitor::notifyDeleted(SpFsObjectHandle o)
{
	nextEvent = SpDirMonEvent(SpDirMonEvent::deleted, type(o), o->path());
}

void testSpDirMonitor::notifyAdded(SpFsObjectHandle o)
{
	nextEvent = SpDirMonEvent(SpDirMonEvent::added, type(o), o->path());
}
	
void testSpDirMonitor::test()
{
	cout << "Note: the following tests will take about 20 seconds" << endl;
	// First create a directory with some test files
	system ("rm -fr test/FsMonitor");
	system ("mkdir test/FsMonitor");
	system ("cp test/templateImages/2x2.gif test/FsMonitor/test.0001.gif");
	system ("cp test/templateImages/2x2.gif test/FsMonitor/test.0002.gif");
	system ("cp test/templateImages/2x2.gif test/FsMonitor/test.0003.gif");
	system ("cp test/templateImages/2x2.gif test/FsMonitor/test.0004.gif");
	SpDirMon *m = SpDirMon::construct(SpDir("test/FsMonitor"), this);
	m->setMaxEvents(1);
	if (checkNotNULL("test 0", m)) {
		checkNextEvent("test 1", m, SpDirMonEvent(SpDirMonEvent::added, SpDirMonEvent::file, "test/FsMonitor/test.0001.gif"));
		checkNextEvent("test 2", m, SpDirMonEvent(SpDirMonEvent::added, SpDirMonEvent::file, "test/FsMonitor/test.0002.gif"));
		checkNextEvent("test 3", m, SpDirMonEvent(SpDirMonEvent::added, SpDirMonEvent::file, "test/FsMonitor/test.0003.gif"));
		checkNextEvent("test 4", m, SpDirMonEvent(SpDirMonEvent::added, SpDirMonEvent::file, "test/FsMonitor/test.0004.gif"));
		
		system ("rm test/FsMonitor/test.0001.gif");
		system ("cp test/templateImages/2x2.gif test/FsMonitor/test.0005.gif");
		system ("mkdir test/FsMonitor/subdirectory");
		SpTime::sleep(6);
		checkNextEvent("test 6", m, SpDirMonEvent(SpDirMonEvent::added,   SpDirMonEvent::file, "test/FsMonitor/test.0005.gif"));
		checkNextEvent("test 7", m, SpDirMonEvent(SpDirMonEvent::added,   SpDirMonEvent::dir,  "test/FsMonitor/subdirectory"));
		checkNextEvent("test 8", m, SpDirMonEvent(SpDirMonEvent::deleted, SpDirMonEvent::file, "test/FsMonitor/test.0001.gif"));
		system ("rm -fr test/FsMonitor");
		SpTime::sleep(6);
		checkNextEvent("test 10", m, SpDirMonEvent(SpDirMonEvent::deleted, SpDirMonEvent::file, "test/FsMonitor/test.0005.gif"));
		checkNextEvent("test 11", m, SpDirMonEvent(SpDirMonEvent::deleted, SpDirMonEvent::file, "test/FsMonitor/test.0002.gif"));
		checkNextEvent("test 12", m, SpDirMonEvent(SpDirMonEvent::deleted, SpDirMonEvent::file, "test/FsMonitor/test.0003.gif"));
		checkNextEvent("test 13", m, SpDirMonEvent(SpDirMonEvent::deleted, SpDirMonEvent::file, "test/FsMonitor/test.0004.gif"));
		checkNextEvent("test 14", m, SpDirMonEvent(SpDirMonEvent::deleted, SpDirMonEvent::dir,  "test/FsMonitor/subdirectory"));
		delete m;
	}
}


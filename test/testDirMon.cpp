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

#include <cppunit/extensions/HelperMacros.h>
#include <cppunit/SourceLine.h>
#include <cppunit/TestAssert.h>
#include <algorithm>
#include "DirMon.h"

using namespace Sp;

class testDirMon : public CppUnit::TestFixture
{
public:
	CPPUNIT_TEST_SUITE(testDirMon);
	CPPUNIT_TEST(test);
	CPPUNIT_TEST_SUITE_END();
	
	void test();
};

CPPUNIT_TEST_SUITE_REGISTRATION(testDirMon);

void checkNextEvents(DirMon &m, std::list<DirMonEvent> &e, CppUnit::SourceLine sourceLine)
{
	while (!e.empty()) {
		CppUnit::Asserter::failIf(!m.pendingEvent(), "fewer events than expected", sourceLine);
		DirMonEvent nextEvent = m.getNextEvent();
		// Check that this event is expected
		std::list<DirMonEvent>::iterator i = std::find(e.begin(), e.end(), nextEvent);
		CppUnit::Asserter::failIf(i == e.end(), "next event has unexpected value", sourceLine);
		// Remove the found event
		e.erase(i);
	}
	CppUnit::Asserter::failIf(m.pendingEvent(), "more events than expected", sourceLine);
}

#define CPPUNIT_CHECK_NEXT_EVENTS( m, e ) checkNextEvents( m, e,  CPPUNIT_SOURCELINE() )

#include "Path.h"

void testDirMon::test()
{
	std::cout << "Note: the following tests will take about 10 seconds" << std::endl;
	// First create a directory with some test files
	system ("rm -fr test/FsMonitor");
	system ("mkdir test/FsMonitor");
	system ("cp test/templateImages/2x2.gif test/FsMonitor/test.0001.gif");
	system ("cp test/templateImages/2x2.gif test/FsMonitor/test.0002.gif");
	system ("cp test/templateImages/2x2.gif test/FsMonitor/test.0003.gif");
	system ("cp test/templateImages/2x2.gif test/FsMonitor/test.0004.gif");

	// Test initial startup
	DirMon m;
	m.startMonitorDirectory(Dir("test/FsMonitor"));
	
	// I'm putting these tests out of order as these events are not guaranteed to come in any
	// particular order.
	std::list<DirMonEvent> expectedEvents;
	expectedEvents.push_back(DirMonEvent(DirMonEvent::added, File("test/FsMonitor/test.0001.gif")));
	expectedEvents.push_back(DirMonEvent(DirMonEvent::added, File("test/FsMonitor/test.0004.gif")));
	expectedEvents.push_back(DirMonEvent(DirMonEvent::added, File("test/FsMonitor/test.0002.gif")));
	expectedEvents.push_back(DirMonEvent(DirMonEvent::added, File("test/FsMonitor/test.0003.gif")));
	CPPUNIT_CHECK_NEXT_EVENTS(m, expectedEvents);
	
	// Test adding files
	DateTime before = Dir("test/FsMonitor").lastChange();
	// Wait one second to ensure that change can be detected
	DateTime::sleep(1);
	system ("cp test/templateImages/2x2.gif test/FsMonitor/test.0005.gif");
	system ("cp test/templateImages/2x2.gif test/FsMonitor/test.0006.gif");
	// Check that the change time of the directory has changed
	DateTime after = Dir("test/FsMonitor").lastChange();
	CPPUNIT_ASSERT(after > before);
	m.update();
	expectedEvents.push_back(DirMonEvent(DirMonEvent::added, File("test/FsMonitor/test.0005.gif")));
	expectedEvents.push_back(DirMonEvent(DirMonEvent::added, File("test/FsMonitor/test.0006.gif")));
	CPPUNIT_CHECK_NEXT_EVENTS(m, expectedEvents);
	
	// Test changing nothing
	m.update();
	CPPUNIT_CHECK_NEXT_EVENTS(m, expectedEvents);
	
	// Test deleting files
	DateTime::sleep(1);
	system ("rm test/FsMonitor/test.0001.gif");
	system ("rm test/FsMonitor/test.0006.gif");
	m.update();
	expectedEvents.push_back(DirMonEvent(DirMonEvent::deleted, File("test/FsMonitor/test.0001.gif")));
	expectedEvents.push_back(DirMonEvent(DirMonEvent::deleted, File("test/FsMonitor/test.0006.gif")));
	CPPUNIT_CHECK_NEXT_EVENTS(m, expectedEvents);
	
	// Test changing nothing
	m.update();
	CPPUNIT_CHECK_NEXT_EVENTS(m, expectedEvents);

	// Test adding subdirectory
	DateTime::sleep(1);
	system ("mkdir test/FsMonitor/subdirectory");
	system ("cp test/templateImages/2x2.gif test/FsMonitor/subdirectory/test.0001.gif");
	m.update();
	expectedEvents.push_back(DirMonEvent(DirMonEvent::added, File("test/FsMonitor/subdirectory/test.0001.gif")));
	CPPUNIT_CHECK_NEXT_EVENTS(m, expectedEvents);
	
	// Test changing nothing
	m.update();
	CPPUNIT_CHECK_NEXT_EVENTS(m, expectedEvents);

	// Test adding in both directories
	DateTime::sleep(1);
	system ("cp test/templateImages/2x2.gif test/FsMonitor/test.0006.gif");
	system ("cp test/templateImages/2x2.gif test/FsMonitor/subdirectory/test.0002.gif");
	m.update();
	expectedEvents.push_back(DirMonEvent(DirMonEvent::added, File("test/FsMonitor/test.0006.gif")));
	expectedEvents.push_back(DirMonEvent(DirMonEvent::added, File("test/FsMonitor/subdirectory/test.0002.gif")));
	CPPUNIT_CHECK_NEXT_EVENTS(m, expectedEvents);

	// Test changing nothing
	m.update();
	CPPUNIT_CHECK_NEXT_EVENTS(m, expectedEvents);
	
	// Test removing a directory
	DateTime::sleep(1);
	system ("rm -fr test/FsMonitor/subdirectory");
	m.update();
	expectedEvents.push_back(DirMonEvent(DirMonEvent::deleted, File("test/FsMonitor/subdirectory/test.0001.gif")));
	expectedEvents.push_back(DirMonEvent(DirMonEvent::deleted, File("test/FsMonitor/subdirectory/test.0002.gif")));
	CPPUNIT_CHECK_NEXT_EVENTS(m, expectedEvents);

	// Test removing the rest
	DateTime::sleep(1);
	system ("rm -fr test/FsMonitor/*");
	m.update();
	expectedEvents.push_back(DirMonEvent(DirMonEvent::deleted, File("test/FsMonitor/test.0002.gif")));
	expectedEvents.push_back(DirMonEvent(DirMonEvent::deleted, File("test/FsMonitor/test.0003.gif")));
	expectedEvents.push_back(DirMonEvent(DirMonEvent::deleted, File("test/FsMonitor/test.0004.gif")));
	expectedEvents.push_back(DirMonEvent(DirMonEvent::deleted, File("test/FsMonitor/test.0005.gif")));
	expectedEvents.push_back(DirMonEvent(DirMonEvent::deleted, File("test/FsMonitor/test.0006.gif")));
	CPPUNIT_CHECK_NEXT_EVENTS(m, expectedEvents);
	
	// We're stopping watching. So we can delete the top level directory
	system ("rmdir test/FsMonitor");
}


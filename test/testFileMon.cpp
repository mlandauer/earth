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
#include "FileMon.h"
#include "Path.h"
#include "FileObserver.h"

using namespace Sp;

class testFileMon : public CppUnit::TestFixture, public FileObserver
{
public:
	CPPUNIT_TEST_SUITE(testFileMon);
	CPPUNIT_TEST(test);
	CPPUNIT_TEST_SUITE_END();
	
	virtual void fileAdded(const File &file);
	virtual void fileDeleted(const File &file);
	void test();
	
private:
	void checkNextEvents(std::list<FileMonEvent> &actualEvents, std::list<FileMonEvent> &expectedEvents, CppUnit::SourceLine sourceLine);
	std::list<FileMonEvent> events;
};

CPPUNIT_TEST_SUITE_REGISTRATION(testFileMon);

#define CPPUNIT_CHECK_NEXT_EVENTS( actualEvents, expectedEvents ) checkNextEvents( actualEvents, expectedEvents,  CPPUNIT_SOURCELINE() )

void testFileMon::checkNextEvents(std::list<FileMonEvent> &actualEvents, std::list<FileMonEvent> &expectedEvents, CppUnit::SourceLine sourceLine)
{
	// The lists must be sorted for set_symmetric_difference
	actualEvents.sort();
	expectedEvents.sort();
	std::list<FileMonEvent> difference;
	std::set_symmetric_difference(actualEvents.begin(), actualEvents.end(),
		expectedEvents.begin(), expectedEvents.end(),
		std::back_inserter(difference));
	
	// First check the respective sizes
	CppUnit::Asserter::failIf(actualEvents.size() < expectedEvents.size(), "fewer events than expected", sourceLine);
	CppUnit::Asserter::failIf(actualEvents.size() > expectedEvents.size(), "more events than expected", sourceLine);		
	CppUnit::Asserter::failIf(!difference.empty(), "unexpected event", sourceLine);
	
	// Clear both lists if succesful
	actualEvents.clear();
	expectedEvents.clear();
}

void testFileMon::fileAdded(const File &file)
{
	events.push_back(FileMonEvent(FileMonEvent::added, file));
}

void testFileMon::fileDeleted(const File &file)
{
	events.push_back(FileMonEvent(FileMonEvent::deleted, file));
}

void testFileMon::test()
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
	FileMon m;
	m.registerObserver(this);
	m.startMonitorDirectory(Dir("test/FsMonitor"));
	
	// I'm putting these tests out of order as these events are not guaranteed to come in any
	// particular order.
	std::list<FileMonEvent> expectedEvents;
	expectedEvents.push_back(FileMonEvent(FileMonEvent::added, File("test/FsMonitor/test.0001.gif")));
	expectedEvents.push_back(FileMonEvent(FileMonEvent::added, File("test/FsMonitor/test.0004.gif")));
	expectedEvents.push_back(FileMonEvent(FileMonEvent::added, File("test/FsMonitor/test.0002.gif")));
	expectedEvents.push_back(FileMonEvent(FileMonEvent::added, File("test/FsMonitor/test.0003.gif")));
	CPPUNIT_CHECK_NEXT_EVENTS(events, expectedEvents);
	
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
	expectedEvents.push_back(FileMonEvent(FileMonEvent::added, File("test/FsMonitor/test.0005.gif")));
	expectedEvents.push_back(FileMonEvent(FileMonEvent::added, File("test/FsMonitor/test.0006.gif")));
	CPPUNIT_CHECK_NEXT_EVENTS(events, expectedEvents);
	
	// Test changing nothing
	m.update();
	CPPUNIT_CHECK_NEXT_EVENTS(events, expectedEvents);
	
	// Test deleting files
	DateTime::sleep(1);
	system ("rm test/FsMonitor/test.0001.gif");
	system ("rm test/FsMonitor/test.0006.gif");
	m.update();
	expectedEvents.push_back(FileMonEvent(FileMonEvent::deleted, File("test/FsMonitor/test.0001.gif")));
	expectedEvents.push_back(FileMonEvent(FileMonEvent::deleted, File("test/FsMonitor/test.0006.gif")));
	CPPUNIT_CHECK_NEXT_EVENTS(events, expectedEvents);
	
	// Test changing nothing
	m.update();
	CPPUNIT_CHECK_NEXT_EVENTS(events, expectedEvents);

	// Test adding subdirectory
	DateTime::sleep(1);
	system ("mkdir test/FsMonitor/subdirectory");
	system ("cp test/templateImages/2x2.gif test/FsMonitor/subdirectory/test.0001.gif");
	m.update();
	expectedEvents.push_back(FileMonEvent(FileMonEvent::added, File("test/FsMonitor/subdirectory/test.0001.gif")));
	CPPUNIT_CHECK_NEXT_EVENTS(events, expectedEvents);
	
	// Test changing nothing
	m.update();
	CPPUNIT_CHECK_NEXT_EVENTS(events, expectedEvents);

	// Test adding in both directories
	DateTime::sleep(1);
	system ("cp test/templateImages/2x2.gif test/FsMonitor/test.0006.gif");
	system ("cp test/templateImages/2x2.gif test/FsMonitor/subdirectory/test.0002.gif");
	m.update();
	expectedEvents.push_back(FileMonEvent(FileMonEvent::added, File("test/FsMonitor/test.0006.gif")));
	expectedEvents.push_back(FileMonEvent(FileMonEvent::added, File("test/FsMonitor/subdirectory/test.0002.gif")));
	CPPUNIT_CHECK_NEXT_EVENTS(events, expectedEvents);

	// Test changing nothing
	m.update();
	CPPUNIT_CHECK_NEXT_EVENTS(events, expectedEvents);
	
	// Test removing a directory
	DateTime::sleep(1);
	system ("rm -fr test/FsMonitor/subdirectory");
	m.update();
	expectedEvents.push_back(FileMonEvent(FileMonEvent::deleted, File("test/FsMonitor/subdirectory/test.0001.gif")));
	expectedEvents.push_back(FileMonEvent(FileMonEvent::deleted, File("test/FsMonitor/subdirectory/test.0002.gif")));
	CPPUNIT_CHECK_NEXT_EVENTS(events, expectedEvents);

	// Test removing the rest
	DateTime::sleep(1);
	system ("rm -fr test/FsMonitor/*");
	m.update();
	expectedEvents.push_back(FileMonEvent(FileMonEvent::deleted, File("test/FsMonitor/test.0002.gif")));
	expectedEvents.push_back(FileMonEvent(FileMonEvent::deleted, File("test/FsMonitor/test.0003.gif")));
	expectedEvents.push_back(FileMonEvent(FileMonEvent::deleted, File("test/FsMonitor/test.0004.gif")));
	expectedEvents.push_back(FileMonEvent(FileMonEvent::deleted, File("test/FsMonitor/test.0005.gif")));
	expectedEvents.push_back(FileMonEvent(FileMonEvent::deleted, File("test/FsMonitor/test.0006.gif")));
	CPPUNIT_CHECK_NEXT_EVENTS(events, expectedEvents);
	
	// We're stopping watching. So we can delete the top level directory
	system ("rmdir test/FsMonitor");
}


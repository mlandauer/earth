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
#include "FileEventObserver.h"

using namespace Sp;

class testFileMon : public CppUnit::TestFixture, public FileEventObserver
{
public:
	CPPUNIT_TEST_SUITE(testFileMon);
	CPPUNIT_TEST(test);
	CPPUNIT_TEST_SUITE_END();
	
	virtual void fileAdded(const File &file);
	virtual void fileDeleted(const File &file);
	void test();
	
private:
	void addExpectedAdded(std::string name);
	void addExpectedDeleted(std::string name);
	void checkNextEvents(std::list<File> &actualEventsAdded, std::list<File> &actualEventsDeleted, std::list<File> &expectedEventsAdded, std::list<File> &expectedEventsDeleted, CppUnit::SourceLine sourceLine);
	std::list<File> eventsAdded, eventsDeleted, expectedEventsAdded, expectedEventsDeleted;
};

CPPUNIT_TEST_SUITE_REGISTRATION(testFileMon);

#define CPPUNIT_CHECK_NEXT_EVENTS( actualEventsAdded, actualEventsDeleted, expectedEventsAdded, expectedEventsDeleted ) checkNextEvents( actualEventsAdded, actualEventsDeleted, expectedEventsAdded, expectedEventsDeleted,  CPPUNIT_SOURCELINE() )

void testFileMon::checkNextEvents(std::list<File> &actualEventsAdded, std::list<File> &actualEventsDeleted, std::list<File> &expectedEventsAdded, std::list<File> &expectedEventsDeleted, CppUnit::SourceLine sourceLine)
{
	// The lists must be sorted for set_symmetric_difference
	actualEventsAdded.sort();
	actualEventsDeleted.sort();
	expectedEventsAdded.sort();
	expectedEventsDeleted.sort();
	std::list<File> differenceAdded, differenceDeleted;
	std::set_symmetric_difference(actualEventsAdded.begin(), actualEventsAdded.end(),
		expectedEventsAdded.begin(), expectedEventsAdded.end(),
		std::back_inserter(differenceAdded));
	std::set_symmetric_difference(actualEventsDeleted.begin(), actualEventsDeleted.end(),
		expectedEventsDeleted.begin(), expectedEventsDeleted.end(),
		std::back_inserter(differenceDeleted));
	
	// First check the respective sizes
	CppUnit::Asserter::failIf(actualEventsAdded.size() < expectedEventsAdded.size(), "fewer added events than expected", sourceLine);
	CppUnit::Asserter::failIf(actualEventsAdded.size() > expectedEventsAdded.size(), "more added events than expected", sourceLine);		
	CppUnit::Asserter::failIf(!differenceAdded.empty(), "unexpected added event", sourceLine);
	CppUnit::Asserter::failIf(actualEventsDeleted.size() < expectedEventsDeleted.size(), "fewer deleted events than expected", sourceLine);
	CppUnit::Asserter::failIf(actualEventsDeleted.size() > expectedEventsDeleted.size(), "more deleted events than expected", sourceLine);		
	CppUnit::Asserter::failIf(!differenceDeleted.empty(), "unexpected deleted event", sourceLine);
	
	// Clear lists if succesful
	actualEventsAdded.clear();
	actualEventsDeleted.clear();
	expectedEventsAdded.clear();
	expectedEventsDeleted.clear();
}

void testFileMon::fileAdded(const File &file)
{
	eventsAdded.push_back(file);
}

void testFileMon::fileDeleted(const File &file)
{
	eventsDeleted.push_back(file);
}

void testFileMon::addExpectedAdded(std::string name)
{
	expectedEventsAdded.push_back(File(name));
}

void testFileMon::addExpectedDeleted(std::string name)
{
	expectedEventsDeleted.push_back(File(name));
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
	addExpectedAdded("test/FsMonitor/test.0001.gif");
	addExpectedAdded("test/FsMonitor/test.0004.gif");
	addExpectedAdded("test/FsMonitor/test.0002.gif");
	addExpectedAdded("test/FsMonitor/test.0003.gif");
	CPPUNIT_CHECK_NEXT_EVENTS(eventsAdded, eventsDeleted,
		expectedEventsAdded, expectedEventsDeleted);
	
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
	addExpectedAdded("test/FsMonitor/test.0005.gif");
	addExpectedAdded("test/FsMonitor/test.0006.gif");
	CPPUNIT_CHECK_NEXT_EVENTS(eventsAdded, eventsDeleted,
		expectedEventsAdded, expectedEventsDeleted);
	
	// Test changing nothing
	m.update();
	CPPUNIT_CHECK_NEXT_EVENTS(eventsAdded, eventsDeleted,
		expectedEventsAdded, expectedEventsDeleted);
	
	// Test deleting files
	DateTime::sleep(1);
	system ("rm test/FsMonitor/test.0001.gif");
	system ("rm test/FsMonitor/test.0006.gif");
	m.update();
	addExpectedDeleted("test/FsMonitor/test.0001.gif");
	addExpectedDeleted("test/FsMonitor/test.0006.gif");
	CPPUNIT_CHECK_NEXT_EVENTS(eventsAdded, eventsDeleted,
		expectedEventsAdded, expectedEventsDeleted);
	
	// Test changing nothing
	m.update();
	CPPUNIT_CHECK_NEXT_EVENTS(eventsAdded, eventsDeleted,
		expectedEventsAdded, expectedEventsDeleted);

	// Test adding subdirectory
	DateTime::sleep(1);
	system ("mkdir test/FsMonitor/subdirectory");
	system ("cp test/templateImages/2x2.gif test/FsMonitor/subdirectory/test.0001.gif");
	m.update();
	addExpectedAdded("test/FsMonitor/subdirectory/test.0001.gif");
	CPPUNIT_CHECK_NEXT_EVENTS(eventsAdded, eventsDeleted,
		expectedEventsAdded, expectedEventsDeleted);
	
	// Test changing nothing
	m.update();
	CPPUNIT_CHECK_NEXT_EVENTS(eventsAdded, eventsDeleted,
		expectedEventsAdded, expectedEventsDeleted);

	// Test adding in both directories
	DateTime::sleep(1);
	system ("cp test/templateImages/2x2.gif test/FsMonitor/test.0006.gif");
	system ("cp test/templateImages/2x2.gif test/FsMonitor/subdirectory/test.0002.gif");
	m.update();
	addExpectedAdded("test/FsMonitor/test.0006.gif");
	addExpectedAdded("test/FsMonitor/subdirectory/test.0002.gif");
	CPPUNIT_CHECK_NEXT_EVENTS(eventsAdded, eventsDeleted,
		expectedEventsAdded, expectedEventsDeleted);

	// Test changing nothing
	m.update();
	CPPUNIT_CHECK_NEXT_EVENTS(eventsAdded, eventsDeleted,
		expectedEventsAdded, expectedEventsDeleted);
	
	// Test removing a directory
	DateTime::sleep(1);
	system ("rm -fr test/FsMonitor/subdirectory");
	m.update();
	addExpectedDeleted("test/FsMonitor/subdirectory/test.0001.gif");
	addExpectedDeleted("test/FsMonitor/subdirectory/test.0002.gif");
	CPPUNIT_CHECK_NEXT_EVENTS(eventsAdded, eventsDeleted,
		expectedEventsAdded, expectedEventsDeleted);

	// Test removing the rest
	DateTime::sleep(1);
	system ("rm -fr test/FsMonitor/*");
	m.update();
	addExpectedDeleted("test/FsMonitor/test.0002.gif");
	addExpectedDeleted("test/FsMonitor/test.0003.gif");
	addExpectedDeleted("test/FsMonitor/test.0004.gif");
	addExpectedDeleted("test/FsMonitor/test.0005.gif");
	addExpectedDeleted("test/FsMonitor/test.0006.gif");
	CPPUNIT_CHECK_NEXT_EVENTS(eventsAdded, eventsDeleted,
		expectedEventsAdded, expectedEventsDeleted);
	
	// We're stopping watching. So we can delete the top level directory
	system ("rmdir test/FsMonitor");
}


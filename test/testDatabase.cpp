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
// $Id: testDir.cpp,v 1.11 2003/01/28 23:23:33 mlandauer Exp $

#include <cppunit/extensions/HelperMacros.h>

class testDatabase : public CppUnit::TestFixture
{
public:
	CPPUNIT_TEST_SUITE(testDatabase);
	CPPUNIT_TEST(test);
	CPPUNIT_TEST_SUITE_END();
	
	void test();
};

CPPUNIT_TEST_SUITE_REGISTRATION(testDatabase);

#include <iostream>
#include <iomanip>
#include <sqlplus.hh>

// Do some simple tests of MySQL database access using MySQL++ API
// Also assuming that the database has been created and populated with the
// script populateTestDatabase.sql
void testDatabase::test()
{
  Connection con("earth", "localhost", "matthewl", "foo"); 
  Query query = con.query();
 
  query << "select * from sequences where frames='2-3'";
 
  Result res = query.store();
  // There should only be one result
  CPPUNIT_ASSERT(res.size() == 1);
  
   Result::iterator i = res.begin();
   Row row = *i;
   int valid = row["valid"];
   std::string imageFormat(row["imageFormat"]);
   int width = row["width"];
   int height = row["height"];
   std::string path(row["path"]);
   std::string frames(row["frames"]);
   
   CPPUNIT_ASSERT(valid == 1);
   CPPUNIT_ASSERT(imageFormat == "Cineon");
   CPPUNIT_ASSERT(width == 4);
   CPPUNIT_ASSERT(height == 4);
   CPPUNIT_ASSERT(path == "test/index/foo/#");
   CPPUNIT_ASSERT(frames == "2-3");
}

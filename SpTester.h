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

class SpTester
{
	public:
		SpTester(string className);
		static void finish();
		static void setVerbose(bool v) { verbose = v; };
		static void setFloatDelta(float d) { floatDelta = d; };
		static float getFloatDelta() { return floatDelta; };
		virtual void test() = 0;
	protected:
		bool checkEqual(string testName, string a, string b);
		bool checkEqual(string testName, int a, int b);
		bool checkEqualBool(string testName, bool a, bool b);
		bool checkEqual(string testName, float a, float b);
		bool checkEqual(string testName, float a, float b, float delta);
		bool check(string testName, bool a);
		bool checkNULL(string testName, void *p);
		bool checkNotNULL(string testName, void *p);
	private:
		static bool verbose;
		static int noFails, noSuccesses;
		static float floatDelta;
		string name;
		string toString(int a);
		string toStringBool(bool a);
		string toString(float a);
		bool check(string testName, bool a, string expected, string got);
		void failMessage(string testName, string expected, string got);
		void successMessage(string testName, string message);
};


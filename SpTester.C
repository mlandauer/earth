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

#include <string>
#include <stdio.h>
#include <math.h>

#include "SpTester.h"

bool SpTester::verbose = false;
int SpTester::noFails = 0;
int SpTester::noSuccesses = 0;
float SpTester::floatDelta = 0.1;

SpTester::SpTester(string className) : name(className)
{
	cout << endl << "Testing " << name << ": ";
	cout.flush();
}

void SpTester::failMessage(string testName, string expected, string got)
{
	cout << endl << "FAILED " << name << " " << testName << ": Expected "
		<< expected << " but got " << got;
	cout.flush();
}

void SpTester::successMessage(string testName, string returned)
{
	if (verbose) {
		cout << endl << "SUCCESS " << name << " " << testName << ": Returned "
			<< returned;
	}
	else
		cout << ".";
	cout.flush();
}

bool SpTester::check(string testName, bool a, string expected, string got)
{
	if (a) {
		successMessage(testName, expected);
		noSuccesses++;
		return true;
	}
	else {
		failMessage(testName, expected, got);
		noFails++;
		return false;
	}
}

bool SpTester::check(string testName, bool a)
{
	return check(testName, a, "true", "false");
}

bool SpTester::checkEqual(string testName, string a, string b)
{
	return check(testName, a == b, b, a);
}

bool SpTester::checkEqual(string testName, int a, int b)
{
	return check(testName, a == b, toString(b), toString(a));
}

bool SpTester::checkEqualBool(string testName, bool a, bool b)
{
	return check(testName, a == b, toStringBool(b), toStringBool(a));
}

bool SpTester::checkEqual(string testName, float a, float b, float delta)
{
	return check(testName, fabs(a-b) <= delta, toString(b), toString(a));
}

bool SpTester::checkEqual(string testName, float a, float b)
{
	return checkEqual(testName, a, b, floatDelta);
}

bool SpTester::checkNotNULL(string testName, void *p)
{
	return check(testName, p != NULL, "non-null pointer", "null pointer");
}

bool SpTester::checkNULL(string testName, void *p)
{
	return check(testName, p == NULL, "null pointer", "non-null pointer");
}

void SpTester::finish()
{
	cout << endl;
	cout << "Tests carried out: " << noFails + noSuccesses << endl;
	if (noFails == 0)
		cout << "All tests passed!" << endl;
	else
		cout << "Tests failed: " << noFails << endl;
}

string SpTester::toString(int a)
{
	char buf[500];
	sprintf(buf, "%i", a);
	return string(buf);
}

string SpTester::toStringBool(bool a)
{
	if (a)
		return "true";
	else
		return "false";
}

string SpTester::toString(float a)
{
	char buf[500];
	sprintf(buf, "%f", a);
	return string(buf);
}

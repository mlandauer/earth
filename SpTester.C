// $Id$

#include <string>

#include "SpTester.h"

bool SpTester::verbose = false;
int SpTester::noErrors = 0;
float SpTester::floatDelta = 0.1;

void SpTester::check(string testName, bool a)
{
	if (!a) {
		cout << endl << "FAILED " << testName << endl;
		noErrors++;
	}
	else
		if (verbose)
			cout << endl << "SUCCESS " << testName;
		else
			cout << ".";
}

void SpTester::checkEqual(string testName, string a, string b)
{
	if (a != b) {
		cout << endl << "FAILED " << testName << ": Expected " << b
			<< " but got " << a << endl;
		noErrors++;
	}
	else
		if (verbose)
			cout << endl << "SUCCESS " << testName << ": returned " << a;
		else
			cout << ".";
}

void SpTester::checkEqual(string testName, bool a, bool b)
{
	if (a != b) {
		cout << endl << "FAILED " << testName << ": Expected " << b
			<< " but got " << a << endl;
		noErrors++;
	}
	else
		if (verbose)
			cout << endl << "SUCCESS " << testName << ": returned " << a;
		else
			cout << ".";
}

void SpTester::checkEqual(string testName, int a, int b)
{
	if (a != b) {
		cout << endl << "FAILED " << testName << ": Expected " << b
			<< " but got " << a << endl;
		noErrors++;
	}
	else
		if (verbose)
			cout << endl << "SUCCESS " << testName << ": returned " << a;
		else
			cout << ".";
}

void SpTester::checkEqual(string testName, float a, float b)
{
	if (fabs(a-b) > floatDelta) {
		cout << endl << "FAILED " << testName << ": Expected " << b
			<< " but got " << a << endl;
		noErrors++;
	}
	else
		if (verbose)
			cout << endl << "SUCCESS " << testName << ": returned " << a;
		else
			cout << ".";
}

void SpTester::finish()
{
	cout << endl;
	if (noErrors == 0)
		cout << "All tests passed!" << endl;
}

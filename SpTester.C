// $Id$

#include <string>

#include "SpTester.h"

bool SpTester::verbose = false;
int SpTester::noErrors = 0;
float SpTester::floatDelta = 0.1;

SpTester::SpTester(string className) : name(className)
{
	cout << endl << "Testing " << name << ": ";
}

bool SpTester::check(string testName, bool a)
{
	if (!a) {
		cout << endl << "FAILED " << name << " " << testName << endl;
		noErrors++;
		return false;
	}
	else {
		if (verbose)
			cout << "SUCCESS " << name << " " << testName << endl;
		else
			cout << ".";
		return true;
	}
}

bool SpTester::checkEqual(string testName, string a, string b)
{
	if (a != b) {
		cout << endl << "FAILED " << name << " " << testName << ": Expected " << b
			<< " but got " << a << endl;
		noErrors++;
		return false;
	}
	else {
		if (verbose)
			cout << "SUCCESS " << name << " " << testName << ": returned " << a << endl;
		else
			cout << ".";
		return true;
	}
}

bool SpTester::checkEqual(string testName, bool a, bool b)
{
	if (a != b) {
		cout << endl << "FAILED " << name << " " << testName << ": Expected " << b
			<< " but got " << a << endl;
		noErrors++;
		return false;
	}
	else {
		if (verbose)
			cout << "SUCCESS " << name << " " << testName << ": returned " << a << endl;
		else
			cout << ".";
		return true;
	}
}

bool SpTester::checkEqual(string testName, int a, int b)
{
	if (a != b) {
		cout << endl << "FAILED " << name << " " << testName << ": Expected " << b
			<< " but got " << a << endl;
		noErrors++;
		return false;
	}
	else {
		if (verbose)
			cout << "SUCCESS " << name << " " << testName << ": returned " << a << endl;
		else
			cout << ".";
		return true;
	}
}

bool SpTester::checkEqual(string testName, float a, float b)
{
	return checkEqual(testName, a, b, floatDelta);
}

bool SpTester::checkEqual(string testName, float a, float b, float delta)
{
	if (fabs(a-b) > delta) {
		cout << endl << "FAILED " << name << " " << testName << ": Expected " << b
			<< " but got " << a << endl;
		noErrors++;
		return false;
	}
	else {
		if (verbose)
			cout << "SUCCESS " << name << " " << testName << ": returned " << a << endl;
		else
			cout << ".";
		return true;
	}
}

bool SpTester::checkNotNULL(string testName, void *p)
{
	if (p == NULL) {
		cout << endl << "FAILED " << name << " " << testName <<
			": Expected non-null pointer" << endl;
		noErrors++;
		return false;
	}
	else {
		if (verbose)
			cout << "SUCCESS " << name << " " << testName <<
				": returned non-null pointer" << endl;
		else
			cout << ".";
		return true;
	}
}

bool SpTester::checkNULL(string testName, void *p)
{
	if (p != NULL) {
		cout << endl << "FAILED " << name << " " << testName <<
			": Expected null pointer" << endl;
		noErrors++;
		return false;
	}
	else {
		if (verbose)
			cout << "SUCCESS " << name << " " << testName <<
				": returned null pointer" << endl;
		else
			cout << ".";
		return true;
	}
}

void SpTester::finish()
{
	cout << endl;
	if (noErrors == 0)
		cout << "All tests passed!" << endl;
}

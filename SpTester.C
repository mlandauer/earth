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

void SpTester::failMessage(string testName)
{
	cout << endl << "FAILED " << name << " " << testName;
}

void SpTester::successMessage(string testName)
{
	cout << "SUCCESS " << name << " " << testName;
}

bool SpTester::check(string testName, bool a)
{
	if (!a) {
		failMessage(testName);
		cout << endl;
		noErrors++;
		return false;
	}
	else {
		if (verbose) {
			successMessage(testName);
			cout << endl;
		}
		else
			cout << ".";
		return true;
	}
}

bool SpTester::checkEqual(string testName, string a, string b)
{
	if (a != b) {
		failMessage(testName);
		cout << ": Expected " << b << " but got " << a << endl;
		noErrors++;
		return false;
	}
	else {
		if (verbose) {
			successMessage(testName);
			cout << ": returned " << a << endl;
		}
		else
			cout << ".";
		return true;
	}
}

bool SpTester::checkEqual(string testName, int a, int b)
{
	if (a != b) {
		failMessage(testName);
		cout << ": Expected " << b << " but got " << a << endl;
		noErrors++;
		return false;
	}
	else {
		if (verbose) {
			successMessage(testName);
			cout << ": returned " << a << endl;
		}
		else
			cout << ".";
		return true;
	}
}

bool SpTester::checkEqual(string testName, float a, float b, float delta)
{
	if (fabs(a-b) > delta) {
		failMessage(testName);
		cout << ": Expected " << b << " but got " << a << endl;
		noErrors++;
		return false;
	}
	else {
		if (verbose) {
			successMessage(testName);
			cout << ": returned " << a << endl;
		}
		else
			cout << ".";
		return true;
	}
}

bool SpTester::checkNotNULL(string testName, void *p)
{
	if (p == NULL) {
		failMessage(testName);
		cout << ": Expected non-null pointer" << endl;
		noErrors++;
		return false;
	}
	else {
		if (verbose) {
			successMessage(testName);
			cout << ": returned non-null pointer" << endl;
		}
		else
			cout << ".";
		return true;
	}
}

bool SpTester::checkNULL(string testName, void *p)
{
	if (p != NULL) {
		failMessage(testName);
		cout << ": Expected null pointer" << endl;
		noErrors++;
		return false;
	}
	else {
		if (verbose) {
			successMessage(testName);
			cout << ": returned null pointer" << endl;
		}
		else
			cout << ".";
		return true;
	}
}

bool SpTester::checkEqual(string testName, float a, float b)
{
	return checkEqual(testName, a, b, floatDelta);
}

void SpTester::finish()
{
	cout << endl;
	if (noErrors == 0)
		cout << "All tests passed!" << endl;
}

// $Id$

#include "SpPath.h"

SpPath::SpPath(const string &a)
{
	set(a);
}

SpPath::~SpPath()
{
}

void SpPath::set(const string &a)
{
	pathString = a;
	// Remove trailing "/" characters
	int length = pathString.length();
	if (length > 0)
		while (pathString[length-1] == '/') {
			pathString.resize(length - 1);
			length--;
		}
}

string SpPath::root() const
{
	string a = pathString;
	int f = pathString.rfind('/');
	if (f < pathString.length()) {
		a.resize(f);
		a += "/";
	}
	else
		a = "";
	return (a);
}

string SpPath::relative() const
{
	string a = pathString;
	int f = pathString.rfind('/');
	if (f < pathString.length()) {
		a = a.substr(f+1);
	}
	return (a);
}

string SpPath::fullName() const
{
	return (pathString);
}

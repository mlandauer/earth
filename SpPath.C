// $Id$

#include <unistd.h>
#include "SpPath.h"

SpPath::SpPath(const string &a)
{
	set(a);
}

SpPath::SpPath(char *s)
{
	 set(string(s));
}

SpPath::~SpPath()
{
}

bool SpPath::operator<(const SpPath &p) const
{
	return (pathString < p.pathString);
}

bool SpPath::operator==(const SpPath &p) const
{
	return (pathString == p.pathString);
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

// Returns an absolute version of the path
// i.e. foo/blah.tif -> /home/fiddle/foo/blah.tif
string SpPath::absolute() const
{
	if (pathString[0] == '/')
		return pathString;
	char workingDirectory[512];
	if (getcwd(workingDirectory, 512) == NULL) {
		cerr << "SpPath::absolute() getcwd buffer overflow!" << endl;
		exit(1);
	}
	return (string(workingDirectory) + "/" + pathString);
}

string SpPath::fullName() const
{
	return (pathString);
}

void SpPath::add(const string &a)
{
	pathString += "/" + a;
}




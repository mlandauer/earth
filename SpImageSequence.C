// $Id$

#include <stdio.h>
#include "SpImageSequence.h"

SpImageSequence::SpImageSequence(SpImage *i)
{
	p = pattern(i->path());
	//f.push_back(frameNumber(i->path()));
	f.insert(frameNumber(i->path()));
}

void SpImageSequence::addImage(SpImage *i)
{
	//f.push_back(frameNumber(i->path()));
	f.insert(frameNumber(i->path()));
}

string SpImageSequence::framesString()
{
	string r;
	char buf[100];
	int count = 0;
	set<int>::iterator a = f.begin();
	while (a != f.end()) {
		int start = *a;
		int current = *a;
		a++;
		while ((*a == current + 1) && (a != f.end())) {
			current = *a;
			a++;
		}
		int end = current;
		if (start == end)
			sprintf(buf, "%i", start);
		else
			sprintf(buf, "%i-%i", start, end);
		if (count > 0)
			r += ",";
		r += string(buf);
		count++;
	}
	return r;
}

SpPath SpImageSequence::path()
{
	return p;
}

SpPath SpImageSequence::pattern(const SpPath &a)
{
	string s = a.fullName();
	// Search backwards from the end for numbers
	string::size_type last = s.find_last_of("0123456789");
	string::size_type first = s.find_last_not_of("0123456789", last) + 1;
	int size = last - first + 1;
	s.replace(first, size, hash(size));
	return SpPath(s);
}

int SpImageSequence::frameNumber(const SpPath &a)
{
	string s = a.fullName();
	// Search backwards from the end for numbers
	string::size_type last = s.find_last_of("0123456789");
	string::size_type first = s.find_last_not_of("0123456789", last) + 1;
	int size = last - first + 1;
	string number = s.substr(first, size);
	unsigned int r;
	sscanf(number.c_str(), "%u", &r);
	return r;
}

// Returns the correct replacement for a number based on the number of
// characters
string SpImageSequence::hash(int size)
{
	if (size == 4)
		return "#";
	else
		return string(size, '@');	
}

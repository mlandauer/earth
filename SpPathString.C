// $Id$

#include "SpPathString.h"

SpPathString::SpPathString()
{
}

SpPathString::~SpPathString()
{
}

void SpPathString::set(string a)
{
	pathString = a;
}

string SpPathString::fullName() const
{
	return (pathString);
}

// $Id$

#include "SpPath.h"

SpPath::SpPath()
{
}

SpPath::~SpPath()
{
}

void SpPath::set(const string &a)
{
	pathString = a;
}

string SpPath::fullName() const
{
	return (pathString);
}

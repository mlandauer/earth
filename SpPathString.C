// $Id$

#include "SpPathString.h"

SpPathString::SpPathString()
{
}

SpPathString::~SpPathString()
{
}

void SpPathString::set(SpString a)
{
	pathString = a;
}

SpString SpPathString::fullName() const
{
	return (pathString);
}

// $Id$

#include "SpTime.h"

SpTime::SpTime()
{
}

SpTime::~SpTime()
{
}

void SpTime::setUnixTime(time_t t)
{
	time = t;
}

SpString SpTime::string()
{
	SpString s(ctime(&time));
	return s;
}

void SpTime::setCurrentTime()
{
	time = std::time(NULL);
}

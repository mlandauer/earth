// $Id$

// A utility class for keeping of track of file or sequence sizes using
// either a measure of bytes, Kb, Mb, etc...

#include "SpSize.h"

SpSize::SpSize()
{
	KBytes = 0;
}

SpSize::~SpSize()
{
}

void SpSize::setBytes(unsigned long int n)
{
	KBytes = n / 1024;
}

void SpSize::setKBytes(unsigned long int n)
{
	KBytes = n;
}

void SpSize::setMBytes(unsigned long int n)
{
	KBytes = n * 1024;
}

void SpSize::setGBytes(unsigned long int n)
{
	KBytes = n * 1024 * 1024;
}

unsigned long int SpSize::bytes() const
{
	return KBytes * 1024;
}

unsigned long int SpSize::kbytes() const
{
	return KBytes;
}

unsigned long int SpSize::mbytes() const
{
	return KBytes / 1024;
}

unsigned long int SpSize::gbytes() const
{
	return KBytes / 1024 / 1024;
}


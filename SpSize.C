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

void SpSize::setBytes(float n)
{
	KBytes = n / 1024;
}

void SpSize::setKBytes(float n)
{
	KBytes = n;
}

void SpSize::setMBytes(float n)
{
	KBytes = n * 1024;
}

void SpSize::setGBytes(float n)
{
	KBytes = n * 1024 * 1024;
}

float SpSize::bytes() const
{
	return KBytes * 1024;
}

float SpSize::kbytes() const
{
	return KBytes;
}

float SpSize::mbytes() const
{
	return KBytes / 1024;
}

float SpSize::gbytes() const
{
	return KBytes / 1024 / 1024;
}


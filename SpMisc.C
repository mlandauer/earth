// $Id$

// A utility class for keeping of track of file or sequence sizes using
// either a measure of bytes, Kb, Mb, etc...

#include "SpMisc.h"

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

unsigned long int SpSize::bytes()
{
	return KBytes * 1024;
}

unsigned long int SpSize::kbytes()
{
	return KBytes;
}

unsigned long int SpSize::mbytes()
{
	return KBytes / 1024;
}

unsigned long int SpSize::gbytes()
{
	return KBytes / 1024 / 1024;
}


// $Id$

#include "SpDir.h"

SpDir::SpDir()
{
}

SpDir::~SpDir()
{
}

SpDir::SpDir(const string &path) : SpFsObject(path)
{
}

// Overrides default implementation in SpFsObject for efficiency
bool SpDir::isFile() const
{
	return (false);
}

// Overrides default implementation in SpFsObject for efficiency
bool SpDir::isDir() const
{
	return (true);
}

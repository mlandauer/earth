// $Id$

#include <sys/stat.h>
#include <unistd.h>

#include <stream.h>

#include "SpFile.h"
#include "SpPathString.h"

SpFile::SpFile(SpString path)
{
	cout << "Creating SpFile with path = " << path << endl;
	pathString.set(path);
}

SpFile::~SpFile()
{
}

SpPathString SpFile::path()
{
	return pathString;
}

SpSize SpFile::size()
{
	struct stat fileStat;
	SpSize s;
	lstat(pathString.fullName(), &fileStat);
	s.setBytes(fileStat.st_size);
	return (s);
}

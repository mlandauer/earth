// $Id$

#include <sys/stat.h>
#include <unistd.h>

#include <stream.h>

#include "SpFile.h"
#include "SpPathString.h"

SpFile::SpFile(SpString path)
{
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

SpTime SpFile::lastModification()
{
	struct stat fileStat;
	SpTime t;
	lstat(pathString.fullName(), &fileStat);
	t.setUnixTime(fileStat.st_mtime);
	return (t);
}

SpTime SpFile::lastAccess()
{
	struct stat fileStat;
	SpTime t;
	lstat(pathString.fullName(), &fileStat);
	t.setUnixTime(fileStat.st_atime);
	return (t);
}

SpTime SpFile::lastChange()
{
	struct stat fileStat;
	SpTime t;
	lstat(pathString.fullName(), &fileStat);
	t.setUnixTime(fileStat.st_ctime);
	return (t);
}

SpUid SpFile::uid()
{
	struct stat fileStat;
	SpUid u;
	lstat(pathString.fullName(), &fileStat);
	u.setUnixUid(fileStat.st_uid);
	return (u);
}

SpGid SpFile::gid()
{
	struct stat fileStat;
	SpGid g;
	lstat(pathString.fullName(), &fileStat);
	g.setUnixGid(fileStat.st_gid);
	return (g);
}

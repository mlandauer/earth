// $Id$

#include <sys/stat.h>
#include <unistd.h>

#include "SpFsObject.h"

SpFsObject::SpFsObject()
{
}

SpFsObject::SpFsObject(const string &path)
{
	setPath(path);
}

SpFsObject::~SpFsObject()
{
}

void SpFsObject::setPath(const string &path)
{
	pathString.set(path);
}

SpTime SpFsObject::lastModification() const
{
	struct stat fileStat;
	SpTime t;
	lstat(pathString.fullName().c_str(), &fileStat);
	t.setUnixTime(fileStat.st_mtime);
	return (t);
}

SpTime SpFsObject::lastAccess() const
{
	struct stat fileStat;
	SpTime t;
	lstat(pathString.fullName().c_str(), &fileStat);
	t.setUnixTime(fileStat.st_atime);
	return (t);
}

SpTime SpFsObject::lastChange() const
{
	struct stat fileStat;
	SpTime t;
	lstat(pathString.fullName().c_str(), &fileStat);
	t.setUnixTime(fileStat.st_ctime);
	return (t);
}

bool SpFsObject::isFile() const
{
	struct stat fileStat;
	lstat(pathString.fullName().c_str(), &fileStat);
	return(S_ISREG(fileStat.st_mode));
}

bool SpFsObject::isDir() const
{
	struct stat fileStat;
	lstat(pathString.fullName().c_str(), &fileStat);
	return(S_ISDIR(fileStat.st_mode));
}

SpUid SpFsObject::uid() const
{
	struct stat fileStat;
	SpUid u;
	lstat(pathString.fullName().c_str(), &fileStat);
	u.setUnixUid(fileStat.st_uid);
	return (u);
}

SpGid SpFsObject::gid() const
{
	struct stat fileStat;
	SpGid g;
	lstat(pathString.fullName().c_str(), &fileStat);
	g.setUnixGid(fileStat.st_gid);
	return (g);
}

SpSize SpFsObject::size() const
{
	struct stat fileStat;
	SpSize s;
	lstat(pathString.fullName().c_str(), &fileStat);
	s.setBytes(fileStat.st_size);
	return (s);
}

SpPathString SpFsObject::path() const
{
	return pathString;
}




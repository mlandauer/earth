// $Id$

#include <sys/stat.h>
#include <unistd.h>
#include <fcntl.h>

#include <stream.h>

#include "SpFile.h"
#include "SpPathString.h"

SpFile::SpFile()
{
}

SpFile::SpFile(string path)
{
	pathString.set(path);
}

SpFile::~SpFile()
{
}

SpPathString SpFile::path() const
{
	return pathString;
}

SpSize SpFile::size() const
{
	struct stat fileStat;
	SpSize s;
	lstat(pathString.fullName().data(), &fileStat);
	s.setBytes(fileStat.st_size);
	return (s);
}

SpTime SpFile::lastModification() const
{
	struct stat fileStat;
	SpTime t;
	lstat(pathString.fullName().data(), &fileStat);
	t.setUnixTime(fileStat.st_mtime);
	return (t);
}

SpTime SpFile::lastAccess() const
{
	struct stat fileStat;
	SpTime t;
	lstat(pathString.fullName().data(), &fileStat);
	t.setUnixTime(fileStat.st_atime);
	return (t);
}

SpTime SpFile::lastChange() const
{
	struct stat fileStat;
	SpTime t;
	lstat(pathString.fullName().data(), &fileStat);
	t.setUnixTime(fileStat.st_ctime);
	return (t);
}

SpUid SpFile::uid() const
{
	struct stat fileStat;
	SpUid u;
	lstat(pathString.fullName().data(), &fileStat);
	u.setUnixUid(fileStat.st_uid);
	return (u);
}

SpGid SpFile::gid() const
{
	struct stat fileStat;
	SpGid g;
	lstat(pathString.fullName().data(), &fileStat);
	g.setUnixGid(fileStat.st_gid);
	return (g);
}

// Opens for read only at the moment
void SpFile::open()
{
	fd = std::open(pathString.fullName().data(), O_RDONLY);
}

void SpFile::close()
{
	std::close(fd);
}

unsigned long int SpFile::read(void *buf, unsigned long int count) const
{
	return (std::read(fd, buf, count));
}

void SpFile::seek(unsigned long int pos) const
{
	lseek(fd, pos, SEEK_SET);
}

void SpFile::seekForward(unsigned long int pos) const
{
	lseek(fd, pos, SEEK_CUR);
}

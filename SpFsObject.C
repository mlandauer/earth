// $Id$

#include <sys/stat.h>
#include <unistd.h>

#include "SpFsObject.h"
#include "SpDir.h"
#include "SpImage.h"

SpFsObject::SpFsObject(const SpPath &path) : p(path)
{
}

SpFsObject::~SpFsObject()
{
}

SpFsObject *SpFsObject::construct(const SpPath &path)
{
	SpFsObject *o;
	o = new SpDir(path);
	if (o->valid())
		return (o);
	else
		delete o;
		
	o = new SpFile(path);
	if (o->valid()) {
		SpImage *i = SpImage::construct(path);
		if (i == NULL)
			return (o);
		else {
			delete o;
			return (i);
		}
	}
	else
		delete o;
	return (NULL);
}

void SpFsObject::setPath(const SpPath &path)
{
	p = path;
}

SpTime SpFsObject::lastModification() const
{
	struct stat fileStat;
	SpTime t;
	lstat(path().fullName().c_str(), &fileStat);
	t.setUnixTime(fileStat.st_mtime);
	return (t);
}

SpTime SpFsObject::lastAccess() const
{
	struct stat fileStat;
	SpTime t;
	lstat(path().fullName().c_str(), &fileStat);
	t.setUnixTime(fileStat.st_atime);
	return (t);
}

SpTime SpFsObject::lastChange() const
{
	struct stat fileStat;
	SpTime t;
	lstat(path().fullName().c_str(), &fileStat);
	t.setUnixTime(fileStat.st_ctime);
	return (t);
}

SpUid SpFsObject::uid() const
{
	struct stat fileStat;
	SpUid u;
	lstat(path().fullName().c_str(), &fileStat);
	u.setUnixUid(fileStat.st_uid);
	return (u);
}

SpGid SpFsObject::gid() const
{
	struct stat fileStat;
	SpGid g;
	lstat(path().fullName().c_str(), &fileStat);
	g.setUnixGid(fileStat.st_gid);
	return (g);
}

SpPath SpFsObject::path() const
{
	return p;
}




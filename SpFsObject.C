// $Id$

#include <sys/stat.h>
#include <unistd.h>

#include "SpFsObject.h"
#include "SpDir.h"
#include "SpImage.h"

SpFsObject::~SpFsObject()
{
}

SpFsObject *SpFsObject::construct(const SpPath &path)
{
	SpFsObject *o = new SpFsObject;
	o->setPath(path);
	if (o->isDir()) {
		delete o;
		SpDir *d = new SpDir;
		d->setPath(path);
		return (d);
	}
	else if (o->isFile()) {
		delete o;
		SpImage *i = SpImage::construct(path);
		if (i == NULL) {
			SpFile *f = new SpFile;
			f->setPath(path);
			return (f);
		}
		else
			return (i);
	}
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

bool SpFsObject::isFile() const
{
	struct stat fileStat;
	lstat(path().fullName().c_str(), &fileStat);
	return(S_ISREG(fileStat.st_mode));
}

bool SpFsObject::isDir() const
{
	struct stat fileStat;
	lstat(path().fullName().c_str(), &fileStat);
	return(S_ISDIR(fileStat.st_mode));
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




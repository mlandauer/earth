// $Id$

#include <sys/stat.h>
#include <unistd.h>

#include "SpFsObject.h"
#include "SpDir.h"
#include "SpImage.h"

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

struct stat SpFsObject::unixStat() const
{
	struct stat s;
	lstat(path().fullName().c_str(), &s);
	return (s);
}

SpTime SpFsObject::lastModification() const
{
	SpTime t;
	t.setUnixTime(unixStat().st_mtime);
	return (t);
}

SpTime SpFsObject::lastAccess() const
{
	SpTime t;
	t.setUnixTime(unixStat().st_atime);
	return (t);
}

SpTime SpFsObject::lastChange() const
{
	SpTime t;
	t.setUnixTime(unixStat().st_ctime);
	return (t);
}

SpUid SpFsObject::uid() const
{
	SpUid u;
	u.setUnixUid(unixStat().st_uid);
	return (u);
}

SpGid SpFsObject::gid() const
{
	SpGid g;
	g.setUnixGid(unixStat().st_gid);
	return (g);
}

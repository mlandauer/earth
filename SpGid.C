// $Id$ 

#include <pwd.h>
#include <unistd.h>
#include <grp.h>

#include "SpGid.h"

SpGid::SpGid()
{
}

SpGid::~SpGid()
{
}

void SpGid::setUnixGid(gid_t g)
{
	gid = g;
}

void SpGid::setCurrent()
{
	gid = getgid();
}

string SpGid::name()
{
	struct group *e = getgrgid(gid);
	return (string(e->gr_name));
}

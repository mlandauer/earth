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

SpString SpGid::string()
{
	struct group *e = getgrgid(gid);
	return (SpString(e->gr_name));
}

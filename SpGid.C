// $Id$ 

#include <pwd.h>

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

SpString SpGid::string()
{
	struct group *e = getgrgid(gid);
	return (SpString(e->gr_name));
}

// $Id$ 

#include <pwd.h>
#include <unistd.h>

#include "SpUid.h"

SpUid::SpUid()
{
}

SpUid::~SpUid()
{
}

void SpUid::setUnixUid(uid_t u)
{
	uid = u;
}

void SpUid::setCurrent()
{
	uid = getuid();
}

SpString SpUid::string()
{
	struct passwd *p = getpwuid(uid);
	return (SpString(p->pw_name));
}

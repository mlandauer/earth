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

string SpUid::name()
{
	struct passwd *p = getpwuid(uid);
	return (string(p->pw_name));
}

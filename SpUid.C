// $Id$ 

#include <pwd.h>

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

SpString SpUid::string()
{
	struct passwd *p = getpwuid(uid);
	return (SpString(p->pw_name));
}

// $Id$

#ifndef _spuid_h_
#define _spuid_h_

#include <sys/types.h>

#include "SpString.h"

class SpUid
{
	public:
		SpUid();
		~SpUid();
		void setUnixUid(uid_t u);
		SpString string();
	private:
		uid_t uid;
};

#endif

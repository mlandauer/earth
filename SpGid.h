// $Id$

#ifndef _spgid_h_
#define _spgid_h_

#include <sys/types.h>

#include "SpString.h"

class SpGid
{
	public:
		SpGid();
		~SpGid();
		void setUnixGid(gid_t g);
		SpString string();
		void setCurrent();
	private:
		gid_t gid;
};

#endif

// $Id$

#ifndef _spgid_h_
#define _spgid_h_

#include <sys/types.h>
#include <string>

class SpGid
{
	public:
		SpGid();
		~SpGid();
		void setUnixGid(gid_t g);
		void setCurrent();
		string name() const;
	private:
		gid_t gid;
};

#endif

// $Id$

#ifndef _spuid_h_
#define _spuid_h_

#include <sys/types.h>
#include <string>

class SpUid
{
	public:
		SpUid();
		~SpUid();
		void setUnixUid(uid_t u);
		string name() const;
		void setCurrent();
	private:
		uid_t uid;
};

#endif

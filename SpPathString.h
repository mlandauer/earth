// $Id$

#ifndef _sppathstring_h_
#define _sppathstring_h_

#include "SpString.h"

class SpPathString
{
	public:
		SpPathString();
		~SpPathString();
		void set(SpString a);
		SpString fullName();
	private:
		SpString pathString;
};

#endif

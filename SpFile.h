// $Id$

#ifndef _spfile_h
#define _spfile_h

#include "SpMisc.h"

class SpFile
{
	public:
		SpFile(SpString path);
		~SpFile();
		//SpTime getLastUpdateTime();
		//SpSize getSize();
		//SpString getName();
		//SpString getFullName();
	private:
		SpString fullName;
};

#endif

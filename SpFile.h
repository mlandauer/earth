// $Id$

#ifndef _spfile_h
#define _spfile_h

#include "SpPathString.h"

class SpFile
{
	public:
		SpFile(SpString path);
		~SpFile();
		//SpTime lastUpdateTime();
		SpSize size();
		SpPathString path();
		//SpString fullName();
	private:
		SpPathString pathString;
};

#endif

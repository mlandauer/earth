// $Id$

#ifndef _spfile_h
#define _spfile_h

#include "SpPathString.h"
#include "SpTime.h"
#include "SpSize.h"

class SpFile
{
	public:
		SpFile(SpString path);
		~SpFile();
		SpTime lastAccess();
		SpTime lastModification();
		SpTime lastChange();
		SpSize size();
		SpPathString path();
	private:
		SpPathString pathString;
};

#endif

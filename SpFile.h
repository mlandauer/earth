// $Id$

#ifndef _spfile_h
#define _spfile_h

#include "SpPathString.h"
#include "SpTime.h"
#include "SpSize.h"
#include "SpUid.h"
#include "SpGid.h"

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
		SpUid uid();
		SpGid gid();
	private:
		SpPathString pathString;
};

#endif

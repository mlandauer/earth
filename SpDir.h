// $Id$

#ifndef _spdir_h_
#define _spdir_h_

#include "SpFsObject.h"

class SpDir : public SpFsObject
{
	public:
		SpDir();
		~SpDir();
		SpDir(const string &path);
		bool isFile() const;
		bool isDir() const;
	private:
};

#endif


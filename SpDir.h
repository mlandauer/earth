// $Id$

#ifndef _spdir_h_
#define _spdir_h_

#include <list>
#include "SpFsObject.h"

class SpDir : public SpFsObject
{
	public:
		SpDir();
		~SpDir();
		SpDir(const SpPath &path);
		list<SpFsObject *> ls() const;
		bool isFile() const;
		bool isDir() const;
	private:
};

#endif


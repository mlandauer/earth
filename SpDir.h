// $Id$

#ifndef _spdir_h_
#define _spdir_h_

#include <vector>
#include "SpFsObject.h"

class SpDir : public SpFsObject
{
	public:
		SpDir();
		~SpDir();
		SpDir(const SpPath &path);
		vector<SpFsObject *> ls() const;
		vector<SpFsObject *> lsSortedByPath() const;
		bool isFile() const;
		bool isDir() const;
	private:
};

#endif


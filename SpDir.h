// $Id$

#ifndef _spdir_h_
#define _spdir_h_

#include <vector>
#include "SpFsObject.h"
#include "SpImage.h"

class SpDir : public SpFsObject
{
	public:
		SpDir(const SpPath &path) : SpFsObject(path) { };
		~SpDir() { };
		vector<SpFsObject *> ls() const;
		bool valid() const;
		static void setSortByPath(bool b) { sortByPath = b; };
	private:
		static bool sortByPath;
};

#endif


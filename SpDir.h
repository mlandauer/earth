// $Id$

#ifndef _spdir_h_
#define _spdir_h_

#include <vector>
#include "SpFsObject.h"
#include "SpImage.h"

class SpDir : public SpFsObject
{
	public:
		SpDir();
		~SpDir();
		SpDir(const SpPath &path);
		vector<SpFsObject *> ls() const;
		vector<SpFile *> lsFiles() const;
		vector<SpImage *> lsImages() const;
		vector<SpFsObject *> lsSortedByPath() const;
		vector<SpImage *> lsImagesSortedByPath() const;
		bool isFile() const;
		bool isDir() const;
		bool valid() const;
	private:
};

#endif


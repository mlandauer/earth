// $Id$

#ifndef _spdir_h_
#define _spdir_h_

#include <vector>
#include <map>
#include "SpFsObject.h"
#include "SpImage.h"

class SpDir : public SpFsObject
{
	public:
		SpDir(const SpPath &path) : SpFsObject(path) { };
		~SpDir() { };
		vector<SpFsObject *> ls() const;
		map<SpPath, SpFsObject *> lsMap() const;
		bool valid() const;
		static void setSortByPath(bool b) { sortByPath = b; };
	private:
		static bool sortByPath;
};

// Stores a directory with its time stamps
class SpDirTime : public SpDir
{
	public:
		SpDirTime(const SpDir &dir) : SpDir(dir) { }
		bool changed() {
			if (lastChange() > cachedChange) {
				cachedChange = lastChange();
				return true;
			}
			else
				return false;
		}
	protected:
		SpTime cachedChange;
};


#endif


// $Id$

#include "SpDir.h"
#include "SpFile.h"

#include <list>
#include <algorithm>
#include <sys/types.h>
#include <dirent.h>

#include "SpFsObject.h"

SpDir::SpDir()
{
}

SpDir::~SpDir()
{
}

SpDir::SpDir(const SpPath &path) : SpFsObject(path)
{
}

// Overrides default implementation in SpFsObject for efficiency
bool SpDir::isFile() const
{
	return (false);
}

// Overrides default implementation in SpFsObject for efficiency
bool SpDir::isDir() const
{
	return (true);
}

vector<SpFsObject *> SpDir::ls() const
{
	// First open a directory stream
	DIR *d = opendir(path().fullName().c_str());
	struct dirent *entry;
	vector<SpFsObject *> l;
	while ((entry = readdir(d)) != NULL) {
		SpFsObject *o = new SpFsObject;
		string pathString = entry->d_name;
		if ((pathString != ".") && (pathString != "..")) {
			SpPath p = path();
			p.add(pathString);
			o->setPath(p);
			l.push_back(o);
		}
	}
	return (l);
}

class SpCompareFsObjectPaths
{
	public:
		bool operator()(const SpFsObject *s1, const SpFsObject *s2) const
			{ return s1->path() < s2->path(); }
};

vector<SpFsObject *> SpDir::lsSortedByPath() const
{
	vector<SpFsObject *> l = ls();
	sort(l.begin(), l.end(), SpCompareFsObjectPaths());
	return(l);
}

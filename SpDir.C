// $Id$

#include "SpDir.h"
#include "SpFile.h"

#include <list>
#include <algorithm>
#include <sys/types.h>
#include <dirent.h>
#include <sys/stat.h>
#include <unistd.h>

#include "SpFsObject.h"

bool SpDir::valid() const
{
	struct stat fileStat;
	lstat(path().fullName().c_str(), &fileStat);
	return(S_ISDIR(fileStat.st_mode));
}

SpDir::SpDir(const SpPath &path) : SpFsObject(path)
{
}

vector<SpFsObject *> SpDir::ls() const
{
	vector<SpFsObject *> l;
	if (!valid())
		return l;
	// First open a directory stream
	DIR *d = opendir(path().fullName().c_str());
	struct dirent *entry;
	while ((entry = readdir(d)) != NULL) {
		string pathString = entry->d_name;
		if ((pathString != ".") && (pathString != "..")) {
			SpPath p = path();
			p.add(pathString);
			SpFsObject *o = SpFsObject::construct(p);
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

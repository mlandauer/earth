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
	// First open a directory stream
	DIR *d = opendir(path().fullName().c_str());
	struct dirent *entry;
	vector<SpFsObject *> l;
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

vector<SpFile *> SpDir::lsFiles() const
{
	// First open a directory stream
	DIR *d = opendir(path().fullName().c_str());
	struct dirent *entry;
	vector<SpFile *> l;
	while ((entry = readdir(d)) != NULL) {
		string pathString = entry->d_name;
		if ((pathString != ".") && (pathString != "..")) {
			SpPath p = path();
			p.add(pathString);
			SpFsObject *o = SpFsObject::construct(p);
			//SpFile *f = dynamic_cast<SpFile *>(o);
			//if (f)
			//	l.push_back(o);
		}
	}
	return (l);
}

vector<SpImage *> SpDir::lsImages() const
{
	// First open a directory stream
	DIR *d = opendir(path().fullName().c_str());
	struct dirent *entry;
	vector<SpImage *> images;
	while ((entry = readdir(d)) != NULL) {
		string pathString = entry->d_name;
		if ((pathString != ".") && (pathString != "..")) {
			SpPath p = path();
			p.add(pathString);
			SpImage *i = SpImage::construct(p);
			if (i != NULL)
				images.push_back(i);
		}
	}
	return (images);
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

vector<SpImage *> SpDir::lsImagesSortedByPath() const
{
	vector<SpImage *> l = lsImages();
	sort(l.begin(), l.end(), SpCompareFsObjectPaths());
	return(l);
}

// $Id$

#include "SpDir.h"
#include "SpFile.h"

#include <list>
#include <sys/types.h>
#include <dirent.h>

#include "SpFsObject.h"

SpDir::SpDir(const string &path) : SpFsObject(path)
{
}

SpDir::~SpDir()
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

list<SpFsObject *> SpDir::ls() const
{
	// First open a directory stream
	DIR *d = opendir(path().fullName().c_str());
	cout << "Have opened directory stream" << endl;
	struct dirent *entry;
	list<SpFsObject *> l;
	while ((entry = readdir(d)) != NULL) {
		SpFsObject *o = new SpFsObject;
		string pathString = entry->d_name;
		if ((pathString != ".") && (pathString != "..")) {
			o->setPath(pathString);
			l.push_back(o);
		}
	}
	return (l);
}

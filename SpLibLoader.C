// $Id$

#include "SpLibLoader.h"

void SpLibLoader::load(string fileName)
{
	void *handle = dlopen(fileName.c_str(), RTLD_LAZY);
	if (handle == NULL)
		cerr << "SpLibLoader: dlopen failed: " << dlerror() << endl;
	else
		handles.push_back(handle);
}

void SpLibLoader::releaseAll()
{
	for (list<void *>::iterator a = handles.begin(); a != handles.end(); ++a)
		dlclose((*a));
}


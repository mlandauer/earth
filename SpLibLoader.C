// $Id$

#include "SpLibLoader.h"

void SpLibLoader::load(char *fileName)
{
	void *handle = dlopen(fileName, RTLD_LAZY);
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


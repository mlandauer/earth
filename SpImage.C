// $Id$

#include <stream.h>

// HACK: not platform independent
#include <dlfcn.h>

#include "SpImage.h"

list<SpImageFormat *> SpImageFormat::plugins;
list<void *> SpImageFormat::dynamicLibraryHandles;

SpImageFormat::SpImageFormat()
{
	addPlugin(this);
}

SpImageFormat::~SpImageFormat()
{
	removePlugin(this);
}

// Register all the supported image types
void SpImageFormat::registerPlugins()
{
	// Construct one of every image type. This is all leading up
	// to some kind of nice plugin architecture
	loadDynamicLibrary("SpTIFFImage.so");
	loadDynamicLibrary("SpTIFFImage.so");
	loadDynamicLibrary("SpIFFImage.so");
	loadDynamicLibrary("SpSGIImage.so");
	loadDynamicLibrary("SpFITImage.so");
	loadDynamicLibrary("SpGIFImage.so");
	loadDynamicLibrary("SpPRMANZImage.so");
	loadDynamicLibrary("SpCINEONImage.so");
	loadDynamicLibrary("SpPRTEXImage.so");
}

void SpImageFormat::loadDynamicLibrary(char *fileName)
{
	void *handle = dlopen(fileName, RTLD_LAZY);
	if (handle == NULL)
		cerr << "dlopen failed: " << dlerror() << endl;
	else
		dynamicLibraryHandles.push_back(handle);
}

void SpImageFormat::releaseDynamicLibraries()
{
	for (list<void *>::iterator a = dynamicLibraryHandles.begin();
		a != dynamicLibraryHandles.end(); ++a)
		dlclose((*a));
}

void SpImageFormat::addPlugin(SpImageFormat *plugin)
{
	plugins.push_back(plugin);
}

void SpImageFormat::removePlugin(SpImageFormat *plugin)
{
	plugins.remove(plugin);
}

void SpImageFormat::deRegisterPlugins()
{
	releaseDynamicLibraries();
}

SpImage* SpImage::construct(const SpPath &path)
{
	list<SpImageFormat *> plugins = SpImageFormat::getPlugins();
	// Figure out what the greatest amount of the header that needs
	// to be read so that all the plugins can recognise themselves.
	int largestSizeToRecognise = 0;
	for (list<SpImageFormat *>::iterator a = plugins.begin();
		a != plugins.end(); ++a)
		if ((*a)->sizeToRecognise() > largestSizeToRecognise)
			largestSizeToRecognise = (*a)->sizeToRecognise();
			
	// Create a temporary file object
	unsigned char *buf = new unsigned char[largestSizeToRecognise];
	SpFile f(path);
	f.open();
	f.read(buf, largestSizeToRecognise);
	f.close();
	
	// See if any of the plugins recognise themselves.
	for (list<SpImageFormat *>::iterator a = plugins.begin();
		a != plugins.end(); ++a)
		if ((*a)->recognise(buf)) {
			SpImage* image = (*a)->constructImage();
			image->format = *a;
			image->setPath(path);
			delete buf;
			return (image);
		}
	// This signals an error or an unrecognised image type
	delete buf;
	return (NULL);
}




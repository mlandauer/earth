// $Id$

#include <fstream>

#include "SpImageFormat.h"
#include "SpFile.h"

list<SpImageFormat *> SpImageFormat::plugins;
SpLibLoader SpImageFormat::loader;

// Register all the supported image types
void SpImageFormat::registerPlugins()
{
	const char formatsFilename[] = "imageFormats.conf";
	ifstream formats(formatsFilename);
	if (!formats) {
		cerr << "SpImageFormat::registerPlugins(): Could not open image formats file: "
			<< formatsFilename << endl;
		return;
	}
	while (formats) {
		string libraryFilename, formatString;
		formats >> libraryFilename;
		formats >> formatString;
		loader.load(libraryFilename);
		// Set the format name on the plugin we just loaded
		recentPlugin()->setFormatString(formatString);
	}
}

void SpImageFormat::addPlugin(SpImageFormat *plugin)
{
	plugins.push_back(plugin);
}

SpImageFormat* SpImageFormat::recentPlugin()
{
	return *(--plugins.end());
}

void SpImageFormat::removePlugin(SpImageFormat *plugin)
{
	plugins.remove(plugin);
}

void SpImageFormat::deRegisterPlugins()
{
	loader.releaseAll();
}

void SpImageFormat::setFormatString(string n)
{
	shortFormat = n;
}

SpImageFormat* SpImageFormat::recogniseByMagic(const SpPath &path)
{
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
			delete buf;
			return (*a);
		}
	delete buf;
	return (NULL);
}

// $Id$

#ifndef _spimageformat_h_
#define _spimageformat_h_

#include <string>
#include "SpLibLoader.h"
#include "SpPath.h"

class SpImage;

class SpImageFormat
{
	public:
		SpImageFormat() { addPlugin(this); };
		~SpImageFormat() { removePlugin(this); };
		string formatString() { return shortFormat; };
		virtual SpImage* constructImage() = 0;
		static void registerPlugins();
		static void deRegisterPlugins();
		static SpImageFormat* recogniseByMagic(const SpPath &path);
	private:
		string shortFormat;
		virtual bool recognise(unsigned char *buf) = 0;
		virtual int sizeToRecognise() = 0;
		void setFormatString(string n);
		static list<SpImageFormat *> plugins;
		static void addPlugin(SpImageFormat *plugin);
		static void removePlugin(SpImageFormat *plugin);
		static SpImageFormat* recentPlugin();
		static SpLibLoader loader;
};

#endif

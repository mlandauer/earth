// $Id$

#ifndef _spimage_h_
#define _spimage_h_

#include <list>

#include "SpFile.h"
#include "SpImageDim.h"
#include "SpLibLoader.h"

class SpImage;

class SpImageFormat
{
	public:
		SpImageFormat();
		~SpImageFormat();
		virtual string formatString() = 0;
		virtual SpImage* constructImage() = 0;
		virtual bool recognise(unsigned char *buf) = 0;
		virtual int sizeToRecognise() = 0;
		static void registerPlugins();
		static void deRegisterPlugins();
		static list<SpImageFormat *> getPlugins() { return plugins; };
	private:
		static list<SpImageFormat *> plugins;
		static void addPlugin(SpImageFormat *plugin);
		static void removePlugin(SpImageFormat *plugin);
		static SpLibLoader loader;
};

class SpImage : public SpFile
{
	public:
		static SpImage* construct(const SpPath &path);
		static void registerPlugins();
		static void deRegisterPlugins();
		virtual SpImageDim dim() = 0;
		virtual bool valid() = 0;
		string formatString() { return getFormat()->formatString(); };
		SpImageFormat* getFormat() { return format; };
	private:
		SpImageFormat *format;
};

#endif

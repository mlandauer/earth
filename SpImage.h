// $Id$

#ifndef _spimage_h_
#define _spimage_h_

#include <list>

#include "SpFile.h"
#include "SpImageDim.h"
#include "SpImageFormat.h"

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

// $Id$

#ifndef _spimage_h_
#define _spimage_h_

#include "SpFile.h"
#include "SpString.h"

class SpImage
{
	public:
		static SpImage* open(SpFile f);
		SpImage();
		~SpImage();
		virtual unsigned int width() const = 0;
		virtual unsigned int height() const = 0;
		virtual SpString formatString() const = 0;
	protected:
		unsigned short readShort(const int &endian) const;
		SpFile file;
	private:
};

#endif

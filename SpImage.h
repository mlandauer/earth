// $Id$

#ifndef _spimage_h_
#define _spimage_h_

#include "SpFile.h"

class SpImage
{
	public:
		static SpImage* open(SpFile f);
		SpImage();
		~SpImage();
		virtual unsigned int width() = 0;
		virtual unsigned int height() = 0;
		virtual string formatString() = 0;
		virtual bool valid() = 0;
	protected:
		unsigned char  readChar() const;
		unsigned short readShort(const int &endian) const;
		unsigned long  readLong(const int &endian) const;
		SpFile file;
	private:
};

#endif

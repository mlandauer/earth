// $Id$

#ifndef _spimage_h_
#define _spimage_h_

#include "SpFile.h"
#include "SpImageDim.h"

class SpImage
{
	public:
		static SpImage* open(SpFile f);
		SpImage();
		~SpImage();
		virtual SpImageDim dim() = 0;
		virtual string formatString() = 0;
		virtual bool valid() = 0;
		void close();
	protected:
		unsigned char  readChar() const;
		unsigned short readShort(const int &endian) const;
		unsigned long  readLong(const int &endian) const;
		SpFile file;
	private:
};

#endif

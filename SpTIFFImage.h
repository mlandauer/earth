// $Id$

#ifndef _sptiffimage_h_
#define _sptiffimage_h_

#include "SpImage.h"

class SpTIFFImage : public SpImage
{
	public:
		SpTIFFImage();
		~SpTIFFImage();
		unsigned int width();
		unsigned int height();
		string formatString();
		bool valid();
	private:
		unsigned int h, w;
		bool headerRead;
		bool validHeader;
		void readHeader();
};

#endif

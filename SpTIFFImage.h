// $Id$

#ifndef _sptiffimage_h_
#define _sptiffimage_h_

#include "SpImage.h"
#include "SpImageDim.h"

class SpTIFFImage : public SpImage
{
	public:
		SpTIFFImage();
		~SpTIFFImage();
		SpImageDim dim();
		string formatString();
		bool valid();
		int sizeToRecognise();
		bool recognise(unsigned char *buf);
		SpImage* clone();
	private:
		unsigned int h, w;
		bool headerRead;
		bool validHeader;
		void readHeader();
};

#endif

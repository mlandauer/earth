// $Id$

#ifndef _spiffimage_h_
#define _spiffimage_h_

#include "SpImage.h"
#include "SpImageDim.h"

class SpIFFImage : public SpImage
{
	public:
		SpIFFImage();
		~SpIFFImage();
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

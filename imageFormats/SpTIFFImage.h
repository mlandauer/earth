// $Id$

#ifndef _sptiffimage_h_
#define _sptiffimage_h_

#include "SpImage.h"
#include "SpImageFormat.h"
#include "SpImageDim.h"

class SpTIFFImageFormat: public SpImageFormat
{
	public:
		virtual SpImage* constructImage();
		virtual bool recognise(unsigned char *buf);
		virtual int sizeToRecognise() { return 4; };
};

class SpTIFFImage : public SpImage
{
	public:
		SpTIFFImage() : headerRead(false), validHeader(false) { };
		~SpTIFFImage() { };
		SpImageDim dim();
		bool valid();
	private:
		unsigned int h, w;
		bool headerRead;
		bool validHeader;
		void readHeader();
};

#endif

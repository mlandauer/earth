// $Id$

#ifndef _sptiffimage_h_
#define _sptiffimage_h_

#include "SpImage.h"
#include "SpImageDim.h"

class SpTIFFImageFormat: public SpImageFormat
{
	public:
		virtual string formatString() { return "TIFF"; };
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
		string formatString() { return format.formatString(); };
		SpImage* clone() { return format.constructImage(); };
		bool recognise(unsigned char *buf) { return format.recognise(buf); };
		int sizeToRecognise() { return format.sizeToRecognise(); };
	private:
		unsigned int h, w;
		bool headerRead;
		bool validHeader;
		void readHeader();
		SpTIFFImageFormat format;
};

#endif

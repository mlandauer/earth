// $Id$

#ifndef _spgifimage_h_
#define _spgifimage_h_

#include "SpImage.h"
#include "SpImageDim.h"

class SpGIFImageFormat: public SpImageFormat
{
	public:
		virtual string formatString() { return "GIF"; };
		virtual SpImage* constructImage();
		virtual bool recognise(unsigned char *buf);
		virtual int sizeToRecognise() { return 4; };
};

class SpGIFImage : public SpImage
{
	public:
		SpGIFImage() { };
		~SpGIFImage() { };
		SpImageDim dim();
		bool valid() { return (true); };
		string formatString() { return format.formatString(); };
		SpImage* clone() { return format.constructImage(); };
		bool recognise(unsigned char *buf) { return format.recognise(buf); };
		int sizeToRecognise() { return format.sizeToRecognise(); };
	private:
		SpGIFImageFormat format;
};

#endif

// $Id$

#ifndef _spgifimage_h_
#define _spgifimage_h_

#include "SpImage.h"
#include "SpImageFormat.h"
#include "SpImageDim.h"

class SpGIFImageFormat: public SpImageFormat
{
	public:
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
	private:
};

#endif

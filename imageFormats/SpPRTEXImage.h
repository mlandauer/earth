// $Id$

#ifndef _spprteximage_h_
#define _spprteximage_h_

#include "SpImage.h"
#include "SpImageFormat.h"
#include "SpImageDim.h"

class SpPRTEXImageFormat: public SpImageFormat
{
	public:
		virtual SpImage* constructImage();
		virtual bool recognise(unsigned char *buf);
		virtual int sizeToRecognise() { return 4; };
};

class SpPRTEXImage : public SpImage
{
	public:
		SpPRTEXImage() { };
		~SpPRTEXImage() { };
		SpImageDim dim();
		bool valid() { return (true); };
	private:
};

#endif

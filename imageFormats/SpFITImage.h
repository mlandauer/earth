// $Id$

#ifndef _spfitimage_h_
#define _spfitimage_h_

#include "SpImage.h"
#include "SpImageFormat.h"
#include "SpImageDim.h"

class SpFITImageFormat: public SpImageFormat
{
	public:
		virtual SpImage* constructImage();
		virtual bool recognise(unsigned char *buf);
		virtual int sizeToRecognise() { return 4; };
};

class SpFITImage : public SpImage
{
	public:
		SpFITImage() { };
		~SpFITImage() { };
		SpImageDim dim();
		bool valid() { return true; };
	private:
};

#endif

// $Id$

#ifndef _spprteximage_h_
#define _spprteximage_h_

#include "SpImage.h"
#include "SpImageDim.h"

class SpPRTEXImage : public SpImage
{
	public:
		SpPRTEXImage();
		~SpPRTEXImage();
		SpImageDim dim();
		string formatString();
		bool valid();
		int sizeToRecognise();
		bool recognise(unsigned char *buf);
	private:
};

#endif

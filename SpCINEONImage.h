// $Id$

#ifndef _spcineonimage_h_
#define _spcineonimage_h_

#include "SpImage.h"
#include "SpImageDim.h"

class SpCINEONImage : public SpImage
{
	public:
		SpCINEONImage();
		~SpCINEONImage();
		SpImageDim dim();
		string formatString();
		bool valid();
		int sizeToRecognise();
		bool recognise(unsigned char *buf);
		SpImage* clone();
	private:
};

#endif

// $Id$

#ifndef _spprmanzimage_h_
#define _spprmanzimage_h_

#include "SpImage.h"

class SpPRMANZImage : public SpImage
{
	public:
		unsigned int width();
		unsigned int height();
		string formatString();
		bool valid();
		SpPRMANZImage();
		~SpPRMANZImage();
	private:
};

#endif

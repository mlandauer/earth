// $Id$

#ifndef _spsgiimage_h_
#define _spsgiimage_h_

#include "SpImage.h"

class SpSGIImage : public SpImage
{
	public:
		unsigned int width();
		unsigned int height();
		string formatString();
		SpSGIImage();
		~SpSGIImage();
	private:
};

#endif

// $Id$

#ifndef _spsgiimage_h_
#define _spsgiimage_h_

#include "SpImage.h"

class SpSGIImage : public SpImage
{
	public:
		unsigned int width() const;
		unsigned int height() const;
		SpString formatString() const;
		SpSGIImage();
		~SpSGIImage();
	private:
};

#endif

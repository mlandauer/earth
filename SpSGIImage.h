// $Id$

#ifndef _spsgiimage_h_
#define _spsgiimage_h_

#include "SpImage.h"
#include "SpImageDim.h"

class SpSGIImage : public SpImage
{
	public:
		SpImageDim dim();
		string formatString();
		bool valid();
		SpSGIImage();
		~SpSGIImage();
	private:
};

#endif

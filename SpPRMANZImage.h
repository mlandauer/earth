// $Id$

#ifndef _spprmanzimage_h_
#define _spprmanzimage_h_

#include "SpImage.h"
#include "SpImageDim.h"

class SpPRMANZImage : public SpImage
{
	public:
		SpImageDim dim();
		string formatString();
		bool valid();
		SpPRMANZImage();
		~SpPRMANZImage();
	private:
};

#endif

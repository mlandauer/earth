// $Id$

#ifndef _spgifimage_h_
#define _spgifimage_h_

#include "SpImage.h"
#include "SpImageDim.h"

class SpGIFImage : public SpImage
{
	public:
		SpImageDim dim();
		string formatString();
		bool valid();
		SpGIFImage();
		~SpGIFImage();
	private:
};

#endif

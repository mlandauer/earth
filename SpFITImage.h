// $Id$

#ifndef _spfitimage_h_
#define _spfitimage_h_

#include "SpImage.h"
#include "SpImageDim.h"

class SpFITImage : public SpImage
{
	public:
		SpImageDim dim();
		string formatString();
		bool valid();
		SpFITImage();
		~SpFITImage();
	private:
};

#endif

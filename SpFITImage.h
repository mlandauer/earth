// $Id$

#ifndef _spfitimage_h_
#define _spfitimage_h_

#include "SpImage.h"

class SpFITImage : public SpImage
{
	public:
		unsigned int width();
		unsigned int height();
		string formatString();
		bool valid();
		SpFITImage();
		~SpFITImage();
	private:
};

#endif

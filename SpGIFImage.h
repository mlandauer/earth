// $Id$

#ifndef _spgifimage_h_
#define _spgifimage_h_

#include "SpImage.h"

class SpGIFImage : public SpImage
{
	public:
		unsigned int width();
		unsigned int height();
		string formatString();
		bool valid();
		SpGIFImage();
		~SpGIFImage();
	private:
};

#endif

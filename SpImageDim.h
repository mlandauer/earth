// $Id$

#ifndef _spimagedim_h_
#define _spimagedim_h_

class SpImageDim
{
	public:
		SpImageDim(unsigned int width = 0, unsigned int height = 0);
		~SpImageDim();
		void setWidth(unsigned int width);
		void setHeight(unsigned int height);
		unsigned int width() const;
		unsigned int height() const;
	private:
		unsigned int w, h;
};

#endif

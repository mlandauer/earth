// $Id$

#include "SpImageDim.h"

SpImageDim::SpImageDim(unsigned int width = 0, unsigned int height = 0)
{
	setWidth(width);
	h = height;
}

SpImageDim::~SpImageDim()
{
}

void SpImageDim::setWidth(unsigned int width)
{
	w = width;
}

void SpImageDim::setHeight(unsigned int height)
{
	h = height;
}

unsigned int SpImageDim::width() const
{
	return w;
}

unsigned int SpImageDim::height() const
{
	return h;
}


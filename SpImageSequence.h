// $Id$

#ifndef _spimagesequence_h_
#define _spimagesequence_h_

#include <set>
#include "SpImage.h"

class SpImageSequence
{
	public:
		SpImageSequence(SpImage *i);
		void addImage(SpImage *i);
		SpPath path();
		string framesString();
	private:
		set<int> f;
		SpPath p;
		SpPath pattern(const SpPath &a);
		int frameNumber(const SpPath &a);
		string hash(int size);
};

#endif

// $Id$

#ifndef _sppathstring_h_
#define _sppathstring_h_

#include <string>

class SpPathString
{
	public:
		SpPathString();
		~SpPathString();
		void set(string a);
		string fullName() const;
	private:
		string pathString;
};

#endif

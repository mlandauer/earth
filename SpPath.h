// $Id$

#ifndef _sppath_h_
#define _sppath_h_

#include <string>

class SpPath
{
	public:
		SpPath();
		~SpPath();
		void set(const string &a);
		string fullName() const;
	private:
		string pathString;
};

#endif

// $Id$

#ifndef _sppath_h_
#define _sppath_h_

#include <string>

class SpPath
{
	public:
		SpPath(const string &a = "");
		~SpPath();
		void set(const string &a);
		string fullName() const;
		string root() const;
		string relative() const;
	private:
		string pathString;
};

#endif

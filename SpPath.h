// $Id$

#ifndef _sppath_h_
#define _sppath_h_

#include <string>

class SpPath
{
	public:
		SpPath(const string &a = "");
		SpPath(char *s);
		~SpPath();
		void set(const string &a);
		string fullName() const;
		string root() const;
		string relative() const;
		string absolute() const;
		void add(const string &a);
		bool operator<(const SpPath &p) const;
		bool operator==(const SpPath &p) const;
	private:
		string pathString;
};

#endif

// $Id$

#ifndef _spmisc_h
#define _spmisc_h

#include <qstring.h>

typedef QString SpString;

// A utility class for keeping of track of file or sequence sizes using
// either a measure of bytes, Kb, Mb, etc...
class SpSize
{
	public:
		SpSize();
		~SpSize();
		void setBytes(unsigned long int n);
		void setKBytes(unsigned long int n);
		void setMBytes(unsigned long int n);
		void setGBytes(unsigned long int n);
		unsigned long int bytes();
		unsigned long int kbytes();
		unsigned long int mbytes();
		unsigned long int gbytes();
	private:
		unsigned long int KBytes;
};

#endif

// $Id$

#ifndef _spsize_h
#define _spsize_h

// A utility class for keeping of track of file or sequence sizes using
// either a measure of bytes, Kb, Mb, etc...
class SpSize
{
	public:
		SpSize();
		~SpSize();
		void setBytes(float n);
		void setKBytes(float n);
		void setMBytes(float n);
		void setGBytes(float n);
		float bytes() const;
		float kbytes() const;
		float mbytes() const;
		float gbytes() const;
	private:
		float KBytes;
};

#endif

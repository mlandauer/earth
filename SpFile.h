// $Id$

#ifndef _spfile_h
#define _spfile_h

#include "SpPathString.h"
#include "SpTime.h"
#include "SpSize.h"
#include "SpUid.h"
#include "SpGid.h"
#include "SpFsObject.h"

class SpFile : public SpFsObject
{
	public:
		SpFile();
		~SpFile();
		SpFile(const string &path);
		inline bool isFile() const;
		inline bool isDir() const;
		void open();
		void close();
		unsigned long int read(void *buf, unsigned long int count) const;
		unsigned char  readChar() const;
		unsigned short readShort(const int &endian) const;
		unsigned long  readLong(const int &endian) const;
		void seek(unsigned long int pos) const;
		void seekForward(unsigned long int pos) const;
	private:
		int fd;
};

#endif

// $Id$

#ifndef _spfile_h
#define _spfile_h

#include "SpPath.h"
#include "SpTime.h"
#include "SpSize.h"
#include "SpUid.h"
#include "SpGid.h"
#include "SpFsObject.h"

class SpFile : public SpFsObject
{
	public:
		SpFile(const SpPath &path);
		~SpFile() { };
		void open();
		void close();
		unsigned long int read(void *buf, unsigned long int count) const;
		unsigned char  readChar() const;
		unsigned short readShort(const int &endian) const;
		unsigned long  readLong(const int &endian) const;
		void seek(unsigned long int pos) const;
		void seekForward(unsigned long int pos) const;
		SpSize size() const;
		bool valid() const;
	protected:
		SpFile() { };
	private:
		int fd;
		bool fileOpen;
};

// Stores a file with its time stamps
class SpFileTime : public SpFile
{
	public:
		SpFileTime(const SpFile &file) : SpFile(file) { }
		bool changed() {
			if (lastChange() > cachedChange) {
				cachedChange = lastChange();
				return true;
			}
			else
				return false;
		}
	protected:
		SpTime cachedChange;
};

#endif

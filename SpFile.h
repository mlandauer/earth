// $Id$

#ifndef _spfile_h
#define _spfile_h

#include "SpPathString.h"
#include "SpTime.h"
#include "SpSize.h"
#include "SpUid.h"
#include "SpGid.h"

class SpFile
{
	public:
		SpFile();
		~SpFile();
		SpFile(string path);
		SpTime lastAccess() const;
		SpTime lastModification() const;
		SpTime lastChange() const;
		SpSize size() const;
		SpPathString path() const;
		SpUid uid() const;
		SpGid gid() const;
		void open();
		void close();
		unsigned long int read(void *buf, unsigned long int count) const;
		void seek(unsigned long int pos) const;
		void seekForward(unsigned long int pos) const;
	protected:
		void setPath(string path);
	private:
		SpPathString pathString;
		int fd;
};

#endif

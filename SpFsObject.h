// $Id$
//
// A file system object that SpFile and SpDir inherit from
//

#ifndef _spfsobject_h_
#define _spfsobject_h_

#include <string>
#include "SpTime.h"
#include "SpPathString.h"
#include "SpUid.h"
#include "SpGid.h"
#include "SpSize.h"

class SpFsObject
{
	public:
		SpFsObject();
		~SpFsObject();
		SpFsObject(const string &path);
		bool isDir() const;
		bool isFile() const;
		SpTime lastAccess() const;
		SpTime lastModification() const;
		SpTime lastChange() const;
		SpPathString path() const;
		SpUid uid() const;
		SpGid gid() const;
		SpSize size() const;
	protected:
		void setPath(const string &path);
	private:
		SpPathString pathString;
};

#endif

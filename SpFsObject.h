// $Id$
//
// A file system object that SpFile and SpDir inherit from
//

#ifndef _spfsobject_h_
#define _spfsobject_h_

#include <sys/stat.h>

#include "SpTime.h"
#include "SpPath.h"
#include "SpUid.h"
#include "SpGid.h"
#include "SpSize.h"

class SpFsObject
{
	public:
		~SpFsObject() { };
		static SpFsObject * construct(const SpPath &path);
		SpTime lastAccess() const;
		SpTime lastModification() const;
		SpTime lastChange() const;
		SpUid uid() const;
		SpGid gid() const;
		void setPath(const SpPath &path) { p = path; };
		SpPath path() const { return p; };
		virtual bool valid() const = 0;
	protected:
		SpFsObject(const SpPath &path = "") : statCached(false), p(path) { };
	private:
		struct stat & SpFsObject::unixStat() const;
		SpPath p;
		mutable struct stat s;
		mutable bool statCached;
};

#endif

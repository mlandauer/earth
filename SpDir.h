// $Id$

#ifndef _spdir_h_
#define _spdir_h_

class SpDir
{
	public:
		SpDir();
		~SpDir();
		SpDir(const string &path);
		void setParent(SpDirectory *parent);
		SpTime getLastUpdateTime();
		string getName();
	protected:
		void setPath(const string &path);
	private:
}

#endif


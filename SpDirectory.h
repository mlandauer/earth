// $Id$

#ifndef _spdirectory_h_
#define _spdirectory_h_

class SpDirectory
{
	public:
		SpDirectory();
		void setParent(SpDirectory *parent);
		SpTime getLastUpdateTime();
		string getName();
		~SpDirectory();
	private:
}

class SpDirectoryReal : SpDirectory
{
	public:
	private:
}

#endif


//  Copyright (C) 2001, 2002 Matthew Landauer. All Rights Reserved.
//  
//  This program is free software; you can redistribute it and/or modify it
//  under the terms of version 2 of the GNU General Public License as
//  published by the Free Software Foundation.
//
//  This program is distributed in the hope that it would be useful, but
//  WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  Further, any
//  license provided herein, whether implied or otherwise, is limited to
//  this program in accordance with the express provisions of the GNU
//  General Public License.  Patent licenses, if any, provided herein do not
//  apply to combinations of this program with other product or programs, or
//  any other product whatsoever.  This program is distributed without any
//  warranty that the program is delivered free of the rightful claim of any
//  third person by way of infringement or the like.  See the GNU General
//  Public License for more details.
//
//  You should have received a copy of the GNU General Public License along
//  with this program; if not, write the Free Software Foundation, Inc., 59
//  Temple Place - Suite 330, Boston MA 02111-1307, USA.
//
// $Id$

#ifndef _FileMon_h_
#define _FileMon_h_

#include <queue>
#include "Dir.h"
#include "File.h"
#include "FileEventObserver.h"

namespace Sp {
	
class CachedDir
{
public:
	CachedDir(const Dir &d) : dir(d) {
		// Really the following should be an automatic operation
		// By default making the lists sorted
		files = dir.listFiles(true);
		dirs = dir.listDirs(true);
		change = dir.lastChange();
	}
	
	//! Returns all the files in this directory
	std::vector<File> listFiles() const { return files; }
	//! Returns all the directories immediately under this directory
	std::vector<Dir> listDirs() const { return dirs; }
	DateTime lastChange() const { return change; }
	Dir getDir() const { return dir; }
	
private:
	std::vector<File> files;
	std::vector<Dir> dirs;
	DateTime change;
	Dir dir;
};

//! This class monitors directories and their contents and sends out updates on changes to files
/*!
	This assumes a POSIX type filesystem which we can monitor using update
	times of the directories.
	\todo Refactor: extract superclass when we add more monitoring types
	\todo add change (different from deleted or added) notification when it is appropriate
*/
class FileMon
{
	public:
		FileMon();
		void startMonitorDirectory(const Dir &d);
		void stopMonitorDirectory(const Dir &d);
		
		void registerObserver(FileEventObserver *o);
		
		void update();
		
	private:
		void notifyDeleted(const File &o);
		void notifyAdded(const File &o);
		std::list<CachedDir> dirs;
		FileEventObserver *observer;
};

}

#endif

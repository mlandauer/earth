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

#include <algorithm>
#include "FileMon.h"

namespace Sp {
	
FileMon::FileMon()
{
}

void FileMon::startMonitorDirectory(const Dir &d)
{
	CachedDir c(d);
	dirs.push_back(c);
	std::vector<File> files = c.listFiles();
	// Tell the world about the files we've found
	for (std::vector<File>::iterator i = files.begin(); i != files.end(); ++i)
		notifyAdded(*i);
	// And check for subdirectories
	std::vector<Dir> dirs = c.listDirs();
	for (std::vector<Dir>::iterator i = dirs.begin(); i != dirs.end(); ++i)
		startMonitorDirectory(*i);
}

void FileMon::stopMonitorDirectory(const Dir &d)
{
	// Find the directory
	for (std::list<CachedDir>::iterator i = dirs.begin(); i != dirs.end(); ++i) {
		if (i->getDir() == d) {
			std::vector<File> deletedFiles = i->listFiles();
			// Tell the world about the files that have been deleted
			for (std::vector<File>::iterator j = deletedFiles.begin(); j != deletedFiles.end(); ++j)
				notifyDeleted(*j);
			// And check for subdirectories
			std::vector<Dir> deletedDirs = i->listDirs();
			for (std::vector<Dir>::iterator j = deletedDirs.begin(); j != deletedDirs.end(); ++j)
				stopMonitorDirectory(*j);
			dirs.erase(i);
			return;
		}
	}
}

void FileMon::update()
{
	// Go through the cached directories and check if any of them have been updated
	for (std::list<CachedDir>::iterator i = dirs.begin(); i != dirs.end(); ++i ) {
		DateTime cachedTime = i->lastChange();
		DateTime currentTime = i->getDir().lastChange();
		if (currentTime > cachedTime) {
			CachedDir currentDir(i->getDir());
			
			// Directory has changed
			std::vector<File> cachedFiles = i->listFiles();
			std::vector<File> currentFiles = currentDir.listFiles();
			std::vector<File> addedFiles, deletedFiles;
			std::set_difference(currentFiles.begin(), currentFiles.end(),
				cachedFiles.begin(), cachedFiles.end(),
				std::back_inserter(addedFiles));
			std::set_difference(cachedFiles.begin(), cachedFiles.end(),
				currentFiles.begin(), currentFiles.end(),
				std::back_inserter(deletedFiles));
			for (std::vector<File>::iterator j = addedFiles.begin(); j != addedFiles.end(); ++j) {
				notifyAdded(*j);
			}
			for (std::vector<File>::iterator j = deletedFiles.begin(); j != deletedFiles.end(); ++j) {
				notifyDeleted(*j);
			}
			
			// Check for directories
			std::vector<Dir> cachedDirs = i->listDirs();
			std::vector<Dir> currentDirs = currentDir.listDirs();
			std::vector<Dir> addedDirs, deletedDirs;
			std::set_difference(currentDirs.begin(), currentDirs.end(),
				cachedDirs.begin(), cachedDirs.end(),
				std::back_inserter(addedDirs));
			std::set_difference(cachedDirs.begin(), cachedDirs.end(),
				currentDirs.begin(), currentDirs.end(),
				std::back_inserter(deletedDirs));
			for (std::vector<Dir>::iterator j = addedDirs.begin(); j != addedDirs.end(); ++j) {
				startMonitorDirectory(*j);
			}
			for (std::vector<Dir>::iterator j = deletedDirs.begin(); j != deletedDirs.end(); ++j) {
				stopMonitorDirectory(*j);
			}
			
			// Replace stored cached directory
			*i = currentDir;
		}
	}
}

bool FileMon::pendingEvent() const
{
	return (!eventQueue.empty());
}

FileMonEvent FileMon::getNextEvent()
{
	if (pendingEvent()) {
		FileMonEvent e = eventQueue.front();
		eventQueue.pop();
		return e;
	}
	else
		return FileMonEvent(FileMonEvent::null);
}

void FileMon::notifyDeleted(const File &o)
{
	eventQueue.push(FileMonEvent(FileMonEvent::deleted, o));
}	
void FileMon::notifyAdded(const File &o)
{
	eventQueue.push(FileMonEvent(FileMonEvent::added, o));
}

}


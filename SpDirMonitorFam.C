//  Copyright (C) 2001 Matthew Landauer. All Rights Reserved.
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

#include <fam.h>
#include "SpDirMonitorFam.h"

bool SpDirMonitorFam::start(const SpDir &d) {
	dir = d;
	if (FAMOpen(&fc) != 0) {
		cerr << "Could not connect to fam daemon" << endl;
		return false;
	}
	// Start monitoring the requested directory
	string dirName = dir.path().absolute();
	FAMMonitorDirectory(&fc, dirName.c_str(), &fr, NULL);
	return true;	
}
	
bool SpDirMonitorFam::stop() {
	if (FAMCancelMonitor(&fc, &fr) == -1) {
		cerr << "SpDirMonitor::~SpDirMonitor() FAMCancelMonitor failed" << endl;
		return false;
	}
	if (FAMClose(&fc)) {
		cerr << "SpDirMonitor::~SpDirMonitor() FAMClose failed!" << endl;
		return false;
	}
	return true;
}
	
void SpDirMonitorFam::update() {
	while (FAMPending(&fc) == 1) {
		FAMEvent fe;
		if (FAMNextEvent(&fc, &fe) == -1) {
			cerr << "SpDirMonitor::update() FAMNextEvent failed" << endl;
			exit(1);
		}
		SpPath fileNamePath = dir.path();
		fileNamePath.add(fe.filename);
		// Ignore messages about the directory itself
		if (string(fe.filename) != dir.path().absolute())	
			switch (fe.code) {
				case FAMChanged:
					notifyChanged(fileNamePath);
					break;
				case FAMDeleted:
					notifyDeleted(fileNamePath);
					break;
				case FAMCreated:
					notifyAdded(fileNamePath);
					break;
				case FAMExists:
					notifyAdded(fileNamePath);
					break;
				// Do nothing with the following
				case FAMStartExecuting:
				case FAMStopExecuting:
				case FAMAcknowledge:
				case FAMEndExist:
				break;
			}
	}	
}




// $Id$

#include <fam.h>
#include "SpDirMonitorFam.h"

void SpDirMonitorFam::start(const SpDir &d) {
	dir = d;
	if (FAMOpen(&fc) != 0) {
		cerr << "Could not connect to fam daemon" << endl;
		exit(1);
	}
	// Start monitoring the requested directory
	string dirName = dir.path().absolute();
	FAMMonitorDirectory(&fc, dirName.c_str(), &fr, NULL);		
}
	
void SpDirMonitorFam::stop() {
	if (FAMCancelMonitor(&fc, &fr) == -1) {
		cerr << "SpDirMonitor::~SpDirMonitor() FAMCancelMonitor failed" << endl;
		exit(1);
	}
	if (FAMClose(&fc)) {
		cerr << "SpDirMonitor::~SpDirMonitor() FAMClose failed!" << endl;
		exit(1);
	}
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




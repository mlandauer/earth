// $Id$

#ifndef _spdirmonitorfam_h_
#define _spdirmonitorfam_h_

#include <fam.h>
#include "SpDirMonitor.h"

// This class monitors just one directory and its contents
// This implementation uses FAM in its entirety (VERY costly)
class SpDirMonitorFam : public SpDirMonitor
{
	public:
		SpDirMonitorFam() { }
		~SpDirMonitorFam() { stop(); }
		void update();
	private:
		void start(const SpDir &d);
		void stop();
		FAMConnection fc;
		FAMRequest fr;
		SpDir dir;
};

#endif



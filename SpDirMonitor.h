// $Id$

#ifndef _spdirmonitor_h_
#define _spdirmonitor_h_

#include <queue>
#include "SpDir.h"

class SpDirMonitorEvent
{
	public:
		enum SpCode {changed, deleted, added, null};
		SpDirMonitorEvent(SpCode c = null, const SpPath &p = "") : code(c), path(p) { }
		~SpDirMonitorEvent() { }
		SpCode getCode() const { return code; }
		SpPath getPath() const { return path; }
		bool operator==(const SpDirMonitorEvent &e) const {
			return ((code == e.code) && (path == e.path));
		}
	private:
		SpCode code;
		SpPath path;
};

// This class monitors just one directory and its contents
class SpDirMonitor
{
	public:
		~SpDirMonitor() { }
		static SpDirMonitor * construct(const SpDir &d);
		bool pendingEvent();
		SpDirMonitorEvent getNextEvent();
	protected:
		virtual void start(const SpDir &d) = 0;
		virtual void stop() = 0;
		virtual void update() = 0;
		void notifyChanged(const SpPath &path);
		void notifyDeleted(const SpPath &path);
		void notifyAdded(const SpPath &path);
	private:
		queue<SpDirMonitorEvent> eventQueue;
};


#endif

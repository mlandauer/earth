// $Id$

#include "SpDirMonitor.h"
#include "SpDirMonitorFam.h"

SpDirMonitor * SpDirMonitor::construct(const SpDir &d) {
	SpDirMonitor *m = new SpDirMonitorFam;
	if (!m->start(d)) {
		delete m;
		return NULL;
	}
	else 
		return m;
}

bool SpDirMonitor::pendingEvent() {
	update();
	return (!eventQueue.empty());
}

SpDirMonitorEvent SpDirMonitor::getNextEvent() {
	if (eventQueue.empty())
		return SpDirMonitorEvent(SpDirMonitorEvent::null);
	else {
		SpDirMonitorEvent e = eventQueue.front();
		eventQueue.pop();
		return e;
	}
}

void SpDirMonitor::notifyChanged(const SpPath &path) {
	eventQueue.push(SpDirMonitorEvent(SpDirMonitorEvent::changed, path));
}
	
void SpDirMonitor::notifyDeleted(const SpPath &path) {
	eventQueue.push(SpDirMonitorEvent(SpDirMonitorEvent::deleted, path));
}
	
void SpDirMonitor::notifyAdded(const SpPath &path) {
	eventQueue.push(SpDirMonitorEvent(SpDirMonitorEvent::added, path));
}


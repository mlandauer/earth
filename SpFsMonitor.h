// $Id$

// This class monitors just one directory and its contents
class SpDirMonitor
{
private:
	SpDir dir;
	vector<SpFsObject *> contents;
	SpTime lastChanged;
public:
	SpDirMonitor(SpDir d) : dir(d) { };
	~SpDirMonitor() { };
	void update() {
		cout << "SpDirMonitor::update()" << endl;
		cout << "data last cached:       " << lastChanged.timeAndDateString() << endl;
		cout << "directory modification: " << dir.lastModification().timeAndDateString() << endl;
		cout << "directory change:       " << dir.lastChange().timeAndDateString() << endl;
		if (dir.lastChange() > lastChanged) {
			lastChanged = dir.lastChange();
			vector<SpFsObject *> l = dir.ls();
			for (vector<SpFsObject *>::iterator a = l.begin(); a != l.end(); a++) {
				newFsObject(*a);
			}
		}
	}
	void newFsObject(SpFsObject *o) {
		cout << "New Filesystem object: " << o->path().fullName() << endl;
	}
};

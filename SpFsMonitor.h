// $Id$

#include <map>
#include <set>

// This class monitors just one directory and its contents
class SpDirMonitor
{
private:
public:
	SpDirMonitor(SpDir d) { };
	~SpDirMonitor() { };
	void update() {
		cout << "SpDirMonitor::update()" << endl;
	}
	
	void fileAdded(SpFile *f) {
		cout << "File added: " << f->path().fullName() << endl;
	}
	void directoryAdded(SpDir *d) {
		cout << "Directory added: " << d->path().fullName() << endl;
	}
	void directoryChanged(SpDir *d) {
		cout << "Directory changed: " << d->path().fullName() << endl;
	}
};


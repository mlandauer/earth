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
		vector<SpFsObject *> l = dir.ls();
		for (vector<SpFsObject *>::iterator a = l.begin(); a != l.end(); a++) {
			newFsObject(*a);
		}
	}
	void newFsObject(SpFsObject *o) {
		if (dynamic_cast<SpFile *>(o))
			newFile(dynamic_cast<SpFile *>(o));
		else if (dynamic_cast<SpDir *>(o))
			newDirectory(dynamic_cast<SpDir *>(o));
		else
			cerr << "newFsObject:: unknown SpFsObject" << endl;
	}
	void newFile(SpFile *f) {
		cout << "New file: " << f->path().fullName() << endl;
	}
	void newDirectory(SpDir *d) {
		cout << "New directory: " << d->path().fullName() << endl;
	}
};

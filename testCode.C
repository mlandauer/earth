// $Id$
// Some very simple test code

#include <stream.h>
#include <algorithm>
#include <vector>

#include "SpFile.h"
#include "SpImage.h"
#include "SpFsObject.h"
#include "SpDir.h"
#include "SpTester.h"
#include "SpFsMonitor.h"

class testSpSize : public SpTester
{
public:
	testSpSize() : SpTester("SpSize") { test(); };
	void test() {
		SpSize s;
		s.setBytes(4097);
		checkEqual("test 1", s.bytes(), 4097.0);
		checkEqual("test 2", s.kbytes(), 4.0);
		checkEqual("test 3", s.mbytes(), 0.0);
		checkEqual("test 4", s.gbytes(), 0.0);

		s.setGBytes(10);
		checkEqual("test 5", s.gbytes(), 10.0);
		checkEqual("test 6", s.mbytes(), 10240.0);
		checkEqual("test 7", s.kbytes(), 10485760.0);
		checkEqual("test 8", s.bytes(), 1.073741e10, 10e5);
	
		s.setBytes(0);
		checkEqual("test 9", s.bytes(), 0.0);
		checkEqual("test 10", s.kbytes(), 0.0);
		checkEqual("test 11", s.mbytes(), 0.0);
		checkEqual("test 12", s.gbytes(), 0.0);
	}
};

class testSpTime : public SpTester
{
public:
	testSpTime() : SpTester("SpTime") { test(); };
	void test() {
		SpTime t;
		t.setUnixTime(0);
		checkEqual("test 1", t.timeAndDateString(), "Wed Dec 31 16:00:00 1969");
		checkEqual("test 2", t.year(), 1969);
		checkEqual("test 3", t.hour(), 16);
		checkEqual("test 4", t.minute(), 0);
		checkEqual("test 5", t.second(), 0);
		checkEqual("test 6", t.dayOfWeek(), 3);
		checkEqual("test 7", t.dayOfMonth(), 31);
		checkEqual("test 8", t.month(), 12);
		checkEqual("test 9", t.monthStringShort(), "Dec");
		checkEqual("test 10", t.monthString(), "December");
		checkEqual("test 11", t.dayOfWeekStringShort(), "Wed");
		checkEqual("test 12", t.dayOfWeekString(), "Wednesday");
		checkEqual("test 13", t.timeString(), "16:00:00");
	}
};

class testSpFile : public SpTester
{
public:
	testSpFile() : SpTester("SpFile") { test(); };
	void test() {
		SpFile file("test/templateImages/8x8.tiff");
		checkEqual("test 0", file.valid(), true);
		checkEqual("test 1", file.path().fullName(), "test/templateImages/8x8.tiff");
		checkEqual("test 2", file.size().bytes(), 396.0);
		checkEqual("test 3", file.size().kbytes(), 0.39);
		file.open();
		unsigned char buf[2];
		int a;
		checkEqual("test 4", file.read(buf, 2), 2);
		checkEqual("test 5", buf[0], 0x49);
		checkEqual("test 6", buf[1], 0x49);
		file.seek(10);
		file.read(buf, 1);
		checkEqual("test 7", buf[0], 0xff);
		file.seekForward(2);
		file.read(buf, 1);
		checkEqual("test 8", buf[0], 0xff);
		file.close();
	
		SpFile f;
		f.setPath("test/templateImages/8x8.tiff");
		checkEqual("test 9", f.path().fullName(), "test/templateImages/8x8.tiff");
		f.open();
		f.setPath("test/templateImages/4x4.tiff");
		checkEqual("test 10", f.path().fullName(), "test/templateImages/8x8.tiff");
		f.close();
		f.setPath("test/templateImages/2x2.tiff");	
		checkEqual("test 11", f.path().fullName(), "test/templateImages/2x2.tiff");
	}
};

class testSpImage : public SpTester
{
public:
	testSpImage() : SpTester("SpImage") { test(); };
	void test() {
		SpImage *image1 = SpImage::construct("test/templateImages/8x8.sgi");
		if (checkNotNULL("test 0", image1)) {
			checkEqual("test 1", image1->path().fullName(),
				"test/templateImages/8x8.sgi");
			checkEqual("test 2", image1->size().kbytes(), 0.89);
			checkEqual("test 3", image1->formatString(), "SGI");
			checkEqual("test 4", image1->dim().width(), 8);
			checkEqual("test 5", image1->dim().height(), 8);
			delete image1;
		}
	
		SpImage *image2 = SpImage::construct("test/templateImages/8x8.tiff");
		if (checkNotNULL("test 5b", image2)) {
			checkEqual("test 6", image2->path().fullName(),
				"test/templateImages/8x8.tiff");
			checkEqual("test 7", image2->size().kbytes(), 0.39);
			checkEqual("test 8", image2->formatString(), "TIFF");
			checkEqual("test 9", image2->dim().width(), 8);
			checkEqual("test 10", image2->dim().height(), 8);
			delete image2;
		}
		
		// *** FIT File format currently untested ****
		// *** PRMANZ File format currently untested ****
		// *** PRTEX File format currently untested ****
		// *** CINEON File format currently untested ****
		// *** IFF File format currently untested ****
	
		SpImage *image3 = SpImage::construct("test/templateImages/8x8.gif");
		if (checkNotNULL("test 10b", image3)) {
			checkEqual("test 11", image3->path().fullName(),
				"test/templateImages/8x8.gif");
			checkEqual("test 12", image3->size().kbytes(), 0.83);
			checkEqual("test 13", image3->formatString(), "GIF");
			checkEqual("test 14", image3->dim().width(), 8);
			checkEqual("test 15", image3->dim().height(), 8);
			delete image3;
		}
	}
};



class testSpUid : public SpTester
{
public:
	testSpUid() : SpTester("SpUid") { test(); };
	void test() {
		// Have to think of some way of testing this class
	}
};

class testSpFsObject : public SpTester
{
public:
	testSpFsObject() : SpTester("SpFsObject") { test(); };
	void test() {
		SpFsObject *file = SpFsObject::construct("test/templateImages/8x8.tiff");
		checkEqual("test 1", file->path().fullName(),
			"test/templateImages/8x8.tiff");
		SpUid u;
		u.setCurrent();
		SpGid g;
		g.setCurrent();
		checkEqual("test 2", file->uid().name(), u.name());
		checkEqual("test 3", file->gid().name(), g.name());
		checkNotNULL("test 4", dynamic_cast<SpFile *>(file));
		checkNULL("test 5", dynamic_cast<SpDir *>(file));
		SpFsObject *file2 = SpFsObject::construct("test/templateImages/");
		checkEqual("test 6", file2->path().fullName(), "test/templateImages");
		// Find some way to test access, modification and change times
		checkNULL("test 7", dynamic_cast<SpFile *>(file2));
		checkNotNULL("test 8", dynamic_cast<SpDir *>(file2));
		delete file;
		delete file2;
	}
};

class testSpDir : public SpTester
{
public:
	testSpDir() : SpTester("SpDir") { test(); };
	void test() {
		SpDir dir("test/templateImages/");
		checkEqual("test 1", dir.path().fullName(),
			"test/templateImages");
		// Think of some way to test the modification dates automatically
		// Check that this user owns the files
		SpUid u;
		u.setCurrent();
		checkEqual("test 2", dir.uid().name(), u.name());
		SpGid g;
		g.setCurrent();
		checkEqual("test 3", dir.gid().name(), g.name());
		checkEqual("test 4", dir.valid(), true);
		vector<SpFsObject *> ls = dir.lsSortedByPath();
		if (checkEqual("ls test 0", ls.size(), 13)) {
			vector<SpFsObject *>::iterator a = ls.begin();
			checkImage("ls test 1", *(a++), "test/templateImages/2x2.gif", "GIF");
			checkNotImage("ls test 2", *(a++), "test/templateImages/2x2.jpg");
			checkImage("ls test 3", *(a++), "test/templateImages/2x2.sgi", "SGI");
			checkImage("ls test 4", *(a++), "test/templateImages/2x2.tiff", "TIFF");
			checkImage("ls test 5", *(a++), "test/templateImages/4x4.gif", "GIF");		
			checkNotImage("ls test 6", *(a++), "test/templateImages/4x4.jpg");						
			checkImage("ls test 7", *(a++), "test/templateImages/4x4.sgi", "SGI");		
			checkImage("ls test 8", *(a++), "test/templateImages/4x4.tiff", "TIFF");		
			checkImage("ls test 9", *(a++), "test/templateImages/8x8.gif", "GIF");		
			checkNotImage("ls test 10", *(a++), "test/templateImages/8x8.jpg");		
			checkImage("ls test 11", *(a++), "test/templateImages/8x8.sgi", "SGI");		
			checkImage("ls test 12", *(a++), "test/templateImages/8x8.tiff", "TIFF");		
			checkDir("ls test 13", *(a++), "test/templateImages/CVS");		
		}
		// Try doing an ls on a non-existant directory
		SpDir dirNotExist("test/whatASillyFella");
		checkEqual("non-existant test 1", dirNotExist.valid(), false);
		vector<SpFsObject *> lsNotExist = dirNotExist.ls();
		checkEqual("non-existant test 2", lsNotExist.size(), 0);
	}
	void checkImage(string n, SpFsObject *o, string fileName, string formatString) {
		checkEqual(n + "a",  o->path().fullName(), fileName);
		SpImage *i = dynamic_cast<SpImage *>(o);
		if (SpTester::checkNotNULL(n + "b", i))
			checkEqual(n + "c",  i->formatString(), formatString);		
	}
	void checkNotImage(string n, SpFsObject *o, string fileName) {
		checkEqual(n + "a",  o->path().fullName(), fileName);
		checkNULL(n + "b",  dynamic_cast<SpImage *>(o));
	}
	void checkDir(string n, SpFsObject *o, string fileName) {
		checkEqual(n + "a",  o->path().fullName(), fileName);
		checkNotNULL(n + "b",  dynamic_cast<SpDir *>(o));
	}
};

class testSpPath : public SpTester
{
public:
	testSpPath() : SpTester("SpPath") { test(); };
	void test() {
		SpPath p("/home/blah/foo.tif");
		checkEqual("test 1", p.fullName(), "/home/blah/foo.tif");
		checkEqual("test 2", p.root(),     "/home/blah/");
		checkEqual("test 3", p.relative(), "foo.tif");
		SpPath p2("/home/blah/");
		checkEqual("test 4", p2.fullName(), "/home/blah");
		checkEqual("test 5", p2.root(),     "/home/");
		checkEqual("test 6", p2.relative(), "blah");
		SpPath p3("blah");
		checkEqual("test 7", p3.fullName(), "blah");
		checkEqual("test 8", p3.root(),     "");
		checkEqual("test 9", p3.relative(), "blah");
		SpPath p4("/home/blah///");
		checkEqual("test 10", p4.fullName(), "/home/blah");
		checkEqual("test 11", p4.root(),     "/home/");
		checkEqual("test 12", p4.relative(), "blah");
		SpPath p5("/blah");
		checkEqual("test 13", p5.fullName(), "/blah");
		checkEqual("test 14", p5.root(),     "/");
		checkEqual("test 15", p5.relative(), "blah");
		// Check that paths can be ordered alphabetically
		SpPath p6("alpha");
		SpPath p7("beta");
		SpPath p8("gamma");
		SpPath p9("gammb");
		SpPath p10("gammb");
		check("test 16", p6 < p7);
		check("test 17", p6 < p8);
		check("test 18", p6 < p9);
		check("test 19", p7 < p8);
		check("test 20", p7 < p9);
		check("test 21", p8 < p9);
		// The reverse
		check("test 16", !(p6 > p7));
		check("test 17", !(p6 > p8));
		check("test 18", !(p6 > p9));
		check("test 19", !(p7 > p8));
		check("test 20", !(p7 > p9));
		check("test 21", !(p8 > p9));
		// Equality
		check("test 22", p9 == p10);
		check("test 23", p6 == p6);
		check("test 24", p6 != p7);
	}
};

class testSpFsMonitor : public SpTester
{
public:
	testSpFsMonitor() : SpTester("SpFsMonitor") { test(); };
	void test() {
		// First create a directory with some test files
		system ("rm -fr test/FsMonitor");
		system ("mkdir test/FsMonitor");
		system ("cp test/templateImages/2x2.gif test/FsMonitor/test.0001.gif");
		system ("cp test/templateImages/2x2.gif test/FsMonitor/test.0002.gif");
		system ("cp test/templateImages/2x2.gif test/FsMonitor/test.0003.gif");
		system ("cp test/templateImages/2x2.gif test/FsMonitor/test.0004.gif");
		SpFsMonitor m;
		m.addMonitor(SpDir("test/FsMonitor"));
		system ("rm -fr test/FsMonitor");
	}
};

main()
{
	// Register the plugins
	SpImageFormat::registerPlugins();
	// Configure the tester
	SpTester::setVerbose(true);
	SpTester::setFloatDelta(0.1);
	
	testSpSize();
	testSpTime();
	testSpUid();
	testSpFile();
	testSpImage();
	testSpFsObject();
	testSpDir();
	testSpPath();
	testSpFsMonitor();
	
	SpTester::finish();
	SpImageFormat::deRegisterPlugins();
}


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
		float temp = SpTester::getFloatDelta();
		setFloatDelta(10e5);
		checkEqual("test 8", s.bytes(), 1.073741e10);
		setFloatDelta(temp);
	
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
		checkEqual("test 1", file.path().fullName(),
			"test/templateImages/8x8.tiff");
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
		checkEqual("test 9", f.path().fullName(),
			"test/templateImages/8x8.tiff");
		f.open();
		f.setPath("test/templateImages/4x4.tiff");
		checkEqual("test 10", f.path().fullName(),
			"test/templateImages/8x8.tiff");
		f.close();
		f.setPath("test/templateImages/2x2.tiff");	
		checkEqual("test 11", f.path().fullName(),
			"test/templateImages/2x2.tiff");
	}
};

class testSpImage : public SpTester
{
public:
	testSpImage() : SpTester("SpImage") { test(); };
	void test() {
		SpImage *image1 = SpImage::construct("test/templateImages/8x8.sgi");
		if (image1 != NULL) {
			checkEqual("test 1", image1->path().fullName(),
				"test/templateImages/8x8.sgi");
			checkEqual("test 2", image1->size().kbytes(), 0.89);
			checkEqual("test 3", image1->formatString(), "SGI");
			checkEqual("test 4", image1->dim().width(), 8);
			checkEqual("test 5", image1->dim().height(), 8);
			delete image1;
		}
		else
			cout << "Unrecognised image type " << endl;
	
		SpImage *image2 = SpImage::construct("test/templateImages/8x8.tiff");
		if (image2 != NULL) {
			checkEqual("test 6", image2->path().fullName(),
				"test/templateImages/8x8.tiff");
			checkEqual("test 7", image2->size().kbytes(), 0.39);
			checkEqual("test 8", image2->formatString(), "TIFF");
			checkEqual("test 9", image2->dim().width(), 8);
			checkEqual("test 10", image2->dim().height(), 8);
			delete image2;
		}
		else
			cout << "Unrecognised image type " << endl;
		
		// *** FIT File format currently untested ****
		// *** PRMANZ File format currently untested ****
		// *** PRTEX File format currently untested ****
		// *** CINEON File format currently untested ****
		// *** IFF File format currently untested ****
	
		SpImage *image3 = SpImage::construct("test/templateImages/8x8.gif");
		if (image3 != NULL) {
			checkEqual("test 11", image3->path().fullName(),
				"test/templateImages/8x8.gif");
			checkEqual("test 12", image3->size().kbytes(), 0.83);
			checkEqual("test 13", image3->formatString(), "GIF");
			checkEqual("test 14", image3->dim().width(), 8);
			checkEqual("test 15", image3->dim().height(), 8);
			delete image3;
		}
		else
			cout << "Unrecognised image type " << endl;
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
		//checkEqual("test 4", file->isFile(), true);
		//checkEqual("test 5", file->isDir(), false);
		SpFsObject *file2 = SpFsObject::construct("test/templateImages/");
		checkEqual("test 6", file2->path().fullName(),
			"test/templateImages");
		// Find some way to test access, modification and change times
		//checkEqual("test 7", file2->isFile(), false);
		//checkEqual("test 8", file2->isDir(), true);
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
		checkEqual("ls test 0", ls.size(), 13);
		// Don't even attempt the next ones if the above test failed
		if (ls.size() == 13) {
			SpImage *i;
			vector<SpFsObject *>::iterator a = ls.begin();
			checkEqual("ls test 1a",  (*a)->path().fullName(),
				"test/templateImages/2x2.gif");
			i = dynamic_cast<SpImage *>(*a);
			SpTester::check("ls test 1b", i);
			checkEqual("ls test 1c",  i->formatString(), "GIF");
			delete i;
			a++;
			
			checkEqual("ls test 2a",  (*a)->path().fullName(),
				"test/templateImages/2x2.jpg");
			i = dynamic_cast<SpImage *>(*a);
			checkEqual("ls test 2c",  i, NULL);
			a++;
	
			checkEqual("ls test 3a",  (*a)->path().fullName(),
				"test/templateImages/2x2.sgi");
			i = dynamic_cast<SpImage *>(*a);
			SpTester::check("ls test 3b", i);
			checkEqual("ls test 3c",  i->formatString(), "SGI");
			delete i;
			a++;
			
			checkEqual("ls test 4a",  (*a)->path().fullName(),
				"test/templateImages/2x2.tiff");
			i = dynamic_cast<SpImage *>(*a);
			SpTester::check("ls test 4b", i);
			checkEqual("ls test 4c",  i->formatString(), "TIFF");
			delete i;
			a++;
			
			checkEqual("ls test 5a",  (*a)->path().fullName(),
				"test/templateImages/4x4.gif");
			i = dynamic_cast<SpImage *>(*a);
			SpTester::check("ls test 5b", i);
			checkEqual("ls test 5c",  i->formatString(), "GIF");
			delete i;
			a++;
			
			checkEqual("ls test 6a",  (*a)->path().fullName(),
				"test/templateImages/4x4.jpg");
			i = dynamic_cast<SpImage *>(*a);
			checkEqual("ls test 6c",  i, NULL);
			a++;
			
			checkEqual("ls test 7a",  (*a)->path().fullName(),
				"test/templateImages/4x4.sgi");
			i = dynamic_cast<SpImage *>(*a);
			SpTester::check("ls test 7b", i);
			checkEqual("ls test 7c",  i->formatString(), "SGI");
			delete i;
			a++;
			
			checkEqual("ls test 8a",  (*a)->path().fullName(),
				"test/templateImages/4x4.tiff");
			i = dynamic_cast<SpImage *>(*a);
			SpTester::check("ls test 8b", i);
			checkEqual("ls test 8c",  i->formatString(), "TIFF");
			delete i;
			a++;
			
			checkEqual("ls test 9a",  (*a)->path().fullName(),
				"test/templateImages/8x8.gif");
			i = dynamic_cast<SpImage *>(*a);
			SpTester::check("ls test 9b", i);
			checkEqual("ls test 9c",  i->formatString(), "GIF");
			delete i;
			a++;
			
			checkEqual("ls test 10a",  (*a)->path().fullName(),
				"test/templateImages/8x8.jpg");
			i = dynamic_cast<SpImage *>(*a);
			checkEqual("ls test 10c",  i, NULL);
			a++;
			
			checkEqual("ls test 11a", (*a)->path().fullName(),
				"test/templateImages/8x8.sgi");
			i = dynamic_cast<SpImage *>(*a);
			SpTester::check("ls test 11b", i);
			checkEqual("ls test 11c", i->formatString(), "SGI");
			delete i;
			a++;
			
			checkEqual("ls test 12a", (*a)->path().fullName(),
				"test/templateImages/8x8.tiff");
			i = dynamic_cast<SpImage *>(*a);
			SpTester::check("ls test 12b", i);
			checkEqual("ls test 12c", i->formatString(), "TIFF");
			a++;
			
			checkEqual("ls test 13a", (*a)->path().fullName(),
				"test/templateImages/CVS");
			check("ls test 13b", dynamic_cast<SpDir *>(*a));
		}
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

main()
{
	// Register the plugins
	SpImageFormat::registerPlugins();
	// Configure the tester
	SpTester::setVerbose(false);
	SpTester::setFloatDelta(0.1);
	
	testSpSize();
	testSpTime();
	testSpUid();
	testSpFile();
	testSpImage();
	testSpFsObject();
	testSpDir();
	testSpPath();
	
	SpTester::finish();
	SpImageFormat::deRegisterPlugins();
}


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

void testSpSize()
{
	cout << endl << "Testing SpSize: ";
	SpSize s;
	s.setBytes(4097);
	SpTester::checkEqual("SpSize test 1", s.bytes(), 4097.0);
	SpTester::checkEqual("SpSize test 2", s.kbytes(), 4.0);
	SpTester::checkEqual("SpSize test 3", s.mbytes(), 0.0);
	SpTester::checkEqual("SpSize test 4", s.gbytes(), 0.0);

	s.setGBytes(10);
	SpTester::checkEqual("SpSize test 5", s.gbytes(), 10.0);
	SpTester::checkEqual("SpSize test 6", s.mbytes(), 10240.0);
	SpTester::checkEqual("SpSize test 7", s.kbytes(), 10485760.0);
	float temp = SpTester::floatDelta;
	SpTester::floatDelta = 10e5;
	SpTester::checkEqual("SpSize test 8", s.bytes(), 1.073741e10);
	SpTester::floatDelta = temp;
	
	s.setBytes(0);
	SpTester::checkEqual("SpSize test 9", s.bytes(), 0.0);
	SpTester::checkEqual("SpSize test 10", s.kbytes(), 0.0);
	SpTester::checkEqual("SpSize test 11", s.mbytes(), 0.0);
	SpTester::checkEqual("SpSize test 12", s.gbytes(), 0.0);
	
}

void testSpTime()
{
	cout << endl << "Testing SpTime: ";
	SpTime t;
	t.setUnixTime(0);
	SpTester::checkEqual("SpTime test 1", t.timeAndDateString(),
		"Wed Dec 31 16:00:00 1969");
	SpTester::checkEqual("SpTime test 2", t.year(), 1969);
	SpTester::checkEqual("SpTime test 3", t.hour(), 16);
	SpTester::checkEqual("SpTime test 4", t.minute(), 0);
	SpTester::checkEqual("SpTime test 5", t.second(), 0);
	SpTester::checkEqual("SpTime test 6", t.dayOfWeek(), 3);
	SpTester::checkEqual("SpTime test 7", t.dayOfMonth(), 31);
	SpTester::checkEqual("SpTime test 8", t.month(), 12);
	SpTester::checkEqual("SpTime test 9", t.monthStringShort(), "Dec");
	SpTester::checkEqual("SpTime test 10", t.monthString(), "December");
	SpTester::checkEqual("SpTime test 11", t.dayOfWeekStringShort(), "Wed");
	SpTester::checkEqual("SpTime test 12", t.dayOfWeekString(), "Wednesday");
	SpTester::checkEqual("SpTime test 13", t.timeString(), "16:00:00");
}

void testSpFile()
{
	cout << endl << "Testing SpFile: ";
	SpFile file("test/templateImages/8x8.tiff");
	SpTester::checkEqual("SpFile test 1", file.path().fullName(),
		"test/templateImages/8x8.tiff");
	SpTester::checkEqual("SpFile test 2", file.size().bytes(), 396.0);
	SpTester::checkEqual("SpFile test 3", file.size().kbytes(), 0.39);
	file.open();
	unsigned char buf[2];
	int a;
	SpTester::checkEqual("SpFile test 4", file.read(buf, 2), 2);
	SpTester::checkEqual("SpFile test 5", buf[0], 0x49);
	SpTester::checkEqual("SpFile test 6", buf[1], 0x49);
	file.seek(10);
	file.read(buf, 1);
	SpTester::checkEqual("SpFile test 7", buf[0], 0xff);
	file.seekForward(2);
	file.read(buf, 1);
	SpTester::checkEqual("SpFile test 8", buf[0], 0xff);
	file.close();
	
	SpFile f;
	f.setPath("test/templateImages/8x8.tiff");
	SpTester::checkEqual("SpFile test 9", f.path().fullName(),
		"test/templateImages/8x8.tiff");
	f.open();
	f.setPath("test/templateImages/4x4.tiff");
	SpTester::checkEqual("SpFile test 10", f.path().fullName(),
		"test/templateImages/8x8.tiff");
	f.close();
	f.setPath("test/templateImages/2x2.tiff");	
	SpTester::checkEqual("SpFile test 11", f.path().fullName(),
		"test/templateImages/2x2.tiff");
}

void testSpImage()
{
	cout << endl << "Testing SpImage: ";
	SpImage *image1 = SpImage::construct("test/templateImages/8x8.sgi");
	if (image1 != NULL) {
		SpTester::checkEqual("SpImage test 1", image1->path().fullName(),
			"test/templateImages/8x8.sgi");
		SpTester::checkEqual("SpImage test 2", image1->size().kbytes(), 0.89);
		SpTester::checkEqual("SpImage test 3", image1->formatString(), "SGI");
		SpTester::checkEqual("SpImage test 4", image1->dim().width(), 8);
		SpTester::checkEqual("SpImage test 5", image1->dim().height(), 8);
		delete image1;
	}
	else
		cout << "Unrecognised image type " << endl;

	SpImage *image2 = SpImage::construct("test/templateImages/8x8.tiff");
	if (image2 != NULL) {
		SpTester::checkEqual("SpImage test 6", image2->path().fullName(),
			"test/templateImages/8x8.tiff");
		SpTester::checkEqual("SpImage test 7", image2->size().kbytes(), 0.39);
		SpTester::checkEqual("SpImage test 8", image2->formatString(), "TIFF");
		SpTester::checkEqual("SpImage test 9", image2->dim().width(), 8);
		SpTester::checkEqual("SpImage test 10", image2->dim().height(), 8);
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
		SpTester::checkEqual("SpImage test 11", image3->path().fullName(),
			"test/templateImages/8x8.gif");
		SpTester::checkEqual("SpImage test 12", image3->size().kbytes(), 0.83);
		SpTester::checkEqual("SpImage test 13", image3->formatString(), "GIF");
		SpTester::checkEqual("SpImage test 14", image3->dim().width(), 8);
		SpTester::checkEqual("SpImage test 15", image3->dim().height(), 8);
		delete image3;
	}
	else
		cout << "Unrecognised image type " << endl;
}

void testSpUid()
{
	cout << endl << "Testing SpUid: ";
	// Have to think of some way of testing this class
}

void testSpFsObject()
{
	cout << endl << "Testing SpFsObject: ";
	SpFsObject file("test/templateImages/8x8.tiff");
	SpTester::checkEqual("SpFsObject test 1", file.path().fullName(),
		"test/templateImages/8x8.tiff");
	SpTester::checkEqual("SpFsObject test 2", file.size().kbytes(), 0.39);
	SpUid u;
	u.setCurrent();
	SpGid g;
	g.setCurrent();
	SpTester::checkEqual("SpFsObject test 3", file.uid().name(), u.name());
	SpTester::checkEqual("SpFsObject test 4", file.gid().name(), g.name());
	SpTester::checkEqual("SpFsObject test 5", file.isFile(), true);
	SpTester::checkEqual("SpFsObject test 6", file.isDir(), false);
	SpFsObject file2("test/templateImages/");
	SpTester::checkEqual("SpFsObject test 7", file2.path().fullName(),
		"test/templateImages");
	SpTester::checkEqual("SpFsObject test 8", file2.size().kbytes(), 1.0);
	// Find some way to test access, modification and change times
	SpTester::checkEqual("SpFsObject test 9", file2.isFile(), false);
	SpTester::checkEqual("SpFsObject test 10", file2.isDir(), true);
}

void testSpDir()
{
	cout << endl << "Testing SpDir: ";
	SpDir dir("test/templateImages/");
	SpTester::checkEqual("SpDir test 1", dir.path().fullName(),
		"test/templateImages");
	SpTester::checkEqual("SpDir test 2", dir.size().kbytes(), 1.0);
	// Think of some way to test the modification dates automatically
	// Check that this user owns the files
	SpUid u;
	u.setCurrent();
	SpTester::checkEqual("SpDir test 6", dir.uid().name(), u.name());
	SpGid g;
	g.setCurrent();
	SpTester::checkEqual("SpDir test 7", dir.gid().name(), g.name());
	SpTester::checkEqual("SpDir test 8", dir.isFile(), false);
	SpTester::checkEqual("SpDir test 9", dir.isDir(), true);
	list<SpFsObject *> ls = dir.ls();
	// Create a vector of just the filenames
	vector<string> names;
	for (list<SpFsObject *>::iterator a = ls.begin(); a != ls.end(); ++a) {
		names.push_back((*a)->path().fullName());
	}
	sort(names.begin(), names.end());
	vector<string>::iterator a = names.begin();
	SpTester::checkEqual("SpDir ls test 1",  (*a++),
		"test/templateImages/2x2.gif");
	SpTester::checkEqual("SpDir ls test 2",  (*a++),
		"test/templateImages/2x2.jpg");
	SpTester::checkEqual("SpDir ls test 3",  (*a++),
		"test/templateImages/2x2.sgi");
	SpTester::checkEqual("SpDir ls test 4",  (*a++),
		"test/templateImages/2x2.tiff");
	SpTester::checkEqual("SpDir ls test 5",  (*a++),
		"test/templateImages/4x4.gif");
	SpTester::checkEqual("SpDir ls test 6",  (*a++),
		"test/templateImages/4x4.jpg");
	SpTester::checkEqual("SpDir ls test 7",  (*a++),
		"test/templateImages/4x4.sgi");
	SpTester::checkEqual("SpDir ls test 8",  (*a++),
		"test/templateImages/4x4.tiff");
	SpTester::checkEqual("SpDir ls test 9",  (*a++),
		"test/templateImages/8x8.gif");
	SpTester::checkEqual("SpDir ls test 10", (*a++),
		"test/templateImages/8x8.jpg");
	SpTester::checkEqual("SpDir ls test 11", (*a++),
		"test/templateImages/8x8.sgi");
	SpTester::checkEqual("SpDir ls test 12", (*a++),
		"test/templateImages/8x8.tiff");
	SpTester::checkEqual("SpDir ls test 13", (*a++),
		"test/templateImages/CVS");
}

void testSpPath()
{
	cout << endl << "Testing SpPath: ";
	SpPath p("/home/blah/foo.tif");
	SpTester::checkEqual("SpPath test 1", p.fullName(), "/home/blah/foo.tif");
	SpTester::checkEqual("SpPath test 2", p.root(),     "/home/blah/");
	SpTester::checkEqual("SpPath test 3", p.relative(), "foo.tif");
	SpPath p2("/home/blah/");
	SpTester::checkEqual("SpPath test 4", p2.fullName(), "/home/blah");
	SpTester::checkEqual("SpPath test 5", p2.root(),     "/home/");
	SpTester::checkEqual("SpPath test 6", p2.relative(), "blah");
	SpPath p3("blah");
	SpTester::checkEqual("SpPath test 7", p3.fullName(), "blah");
	SpTester::checkEqual("SpPath test 8", p3.root(),     "");
	SpTester::checkEqual("SpPath test 9", p3.relative(), "blah");
	SpPath p4("/home/blah///");
	SpTester::checkEqual("SpPath test 10", p4.fullName(), "/home/blah");
	SpTester::checkEqual("SpPath test 11", p4.root(),     "/home/");
	SpTester::checkEqual("SpPath test 12", p4.relative(), "blah");
	SpPath p5("/blah");
	SpTester::checkEqual("SpPath test 13", p5.fullName(), "/blah");
	SpTester::checkEqual("SpPath test 14", p5.root(),     "/");
	SpTester::checkEqual("SpPath test 15", p5.relative(), "blah");
}

main()
{
	// Register the plugins
	SpImage::registerPlugins();
	
	SpTester::verbose = false;
	SpTester::floatDelta = 0.1;
	testSpSize();
	testSpTime();
	testSpUid();
	testSpFile();
	testSpImage();
	testSpFsObject();
	testSpDir();
	testSpPath();
	
	SpTester::finish();
	
	SpImage::deRegisterPlugins();
}


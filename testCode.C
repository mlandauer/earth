// $Id$
// Some very simple test code

#include <stream.h>
#include <algorithm>
#include <vector>

#include "SpFile.h"
#include "SpImage.h"
#include "SpFsObject.h"
#include "SpDir.h"

int noErrors = 0;

void checkEqual(string testName, string a, string b)
{
	if (a != b) {
		cout << endl << "FAILED " << testName << ": Expected " << b
			<< " but got " << a << endl;
		noErrors++;
	}
	else
		cout << ".";
}

void checkEqual(string testName, bool a, bool b)
{
	if (a != b) {
		cout << endl << "FAILED " << testName << ": Expected " << b
			<< " but got " << a << endl;
		noErrors++;
	}
	else
		cout << ".";
}

void checkEqual(string testName, int a, int b)
{
	if (a != b) {
		cout << endl << "FAILED " << testName << ": Expected " << b
			<< " but got " << a << endl;
		noErrors++;
	}
	else
		cout << ".";
}

void testSpSize()
{
	SpSize s;
	s.setBytes(4097);
	cout << s.bytes()  << " bytes = " <<
	        s.kbytes() << " Kb = " <<
	        s.mbytes() << " Mb = " <<
	        s.gbytes() << " Gb" << endl;

	// This will overflow the bytes return
	s.setGBytes(10);
	cout << s.bytes()  << " bytes = " <<
	        s.kbytes() << " Kb = " <<
	        s.mbytes() << " Mb = " <<
	        s.gbytes() << " Gb" << endl;
}

void testSpTime()
{
	SpTime t;
	t.setCurrentTime();
	cout << "Current time and date = " << t.timeAndDateString() << endl;
	cout << "Year = " << t.year() << endl;
	cout << "Hour = " << t.hour() << endl;
	cout << "Minute = " << t.minute() << endl;
	cout << "Second = " << t.second() << endl;
	cout << "Day of the week = " << t.dayOfWeek() << endl;
	cout << "Day of the month = " << t.dayOfMonth() << endl;
	cout << "month = " << t.month() << endl;
	cout << "monthStringShort = " << t.monthStringShort() << endl;
	cout << "monthString = " << t.monthString() << endl;
	cout << "dayOfWeekStringShort = " << t.dayOfWeekStringShort() << endl;
	cout << "time = " << t.timeString() << endl;
}

void testSpFile()
{
	SpFile file("test/templateImages/8x8.tiff");
	cout << "filename = " << file.path().fullName() << endl;
	cout << "size = " << file.size().bytes() << " bytes" << endl;
	cout << "size = " << file.size().kbytes() << " Kbytes" << endl;
	cout << "last access = " << file.lastAccess().timeAndDateString() << endl;
	cout << "last modification = " << file.lastModification().timeAndDateString() << endl;
	cout << "last change = " << file.lastChange().timeAndDateString() << endl;
	cout << "owner = " << file.uid().name() << endl;
	cout << "group owner = " << file.gid().name() << endl;
	file.open();
	cout << "File opened" << endl;
	unsigned char buf[2];
	unsigned long int a = file.read(buf, 2);
	cout << "Read in " << a << " characters" << endl;
	a = buf[0];
	cout << "First value in file = " << a << endl;
	a = buf[1];
	cout << "Second value in file = " << a << endl;
	file.seek(10);
	file.read(buf, 1);
	a = buf[0];
	cout << "Value at position 10 = " << a << endl;
	file.seekForward(2);
	cout << "Seek forward another 2" << endl;
	file.read(buf, 1);
	a = buf[0];
	cout << "Value here = " << a << endl;
	file.close();
	cout << "File closed" << endl;
	
	cout << "Testing setPath checking mechanism" << endl;
	SpFile f;
	cout << "setPath..." << endl;
	f.setPath("test/templateImages/8x8.tiff");
	cout << "open..." << endl;
	f.open();
	cout << "setPath..." << endl;
	f.setPath("test/templateImages/8x8.tiff");
	cout << "close..." << endl;
	f.close();
	cout << "setPath..." << endl;
	f.setPath("test/templateImages/8x8.tiff");	
}

void testSpImage()
{
	SpImage *image1 = SpImage::construct("test/templateImages/8x8.sgi");
	if (image1 != NULL) {
		cout << "Opened image " << image1->path().fullName() << endl;
		cout << "Image Filesize = " << image1->size().kbytes() << " Kbytes" << endl;
		cout << "Last modification = " << image1->lastModification().timeAndDateString() << endl;
		cout << "Image format = " << image1->formatString() << endl;
		cout << "Image width = " << image1->dim().width() << endl;
		cout << "Image height = " << image1->dim().height() << endl;
		delete image1;
	}
	else
		cout << "Unrecognised image type " << endl;

	SpImage *image2 = SpImage::construct("test/templateImages/8x8.tiff");
	if (image2 != NULL) {
		cout << "Opened image " << image2->path().fullName() << endl;
		cout << "Image Filesize = " << image2->size().kbytes() << " Kbytes" << endl;
		cout << "Last modification = " << image2->lastModification().timeAndDateString() << endl;
		cout << "Image format = " << image2->formatString() << endl;
		cout << "Image width = " << image2->dim().width() << endl;
		cout << "Image height = " << image2->dim().height() << endl;
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
		cout << "Opened image " << image3->path().fullName() << endl;
		cout << "Image Filesize = " << image3->size().kbytes() << " Kbytes" << endl;
		cout << "Last modification = " << image3->lastModification().timeAndDateString() << endl;
		cout << "Image format = " << image3->formatString() << endl;
		cout << "Image width = " << image3->dim().width() << endl;
		cout << "Image height = " << image3->dim().height() << endl;
		delete image3;
	}
	else
		cout << "Unrecognised image type " << endl;
}

void space()
{
	cout << "=========================" << endl;
}

void testSpUid()
{
	SpUid u;
	SpGid g;
	u.setCurrent();
	g.setCurrent();
	cout << "current user = " << u.name() << endl;
	cout << "current group = " << g.name() << endl;
}

void testSpFsObject()
{
	cout << "Test Filesystem Object" << endl;
	SpFsObject file("test/templateImages/8x8.tiff");
	cout << "path = " << file.path().fullName() << endl;
	cout << "size = " << file.size().kbytes() << " Kbytes" << endl;
	cout << "last access = " << file.lastAccess().timeAndDateString() << endl;
	cout << "last modification = " << file.lastModification().timeAndDateString() << endl;
	cout << "last change = " << file.lastChange().timeAndDateString() << endl;
	cout << "owner = " << file.uid().name() << endl;
	cout << "group owner = " << file.gid().name() << endl;
	cout << "is a file? = " << file.isFile() << endl;
	cout << "is a directory? = " << file.isDir() << endl;
	SpFsObject file2("test/templateImages/");
	cout << "path = " << file2.path().fullName() << endl;
	cout << "size = " << file2.size().kbytes() << " Kbytes" << endl;
	cout << "last access = " << file2.lastAccess().timeAndDateString() << endl;
	cout << "last modification = " << file2.lastModification().timeAndDateString() << endl;
	cout << "last change = " << file2.lastChange().timeAndDateString() << endl;
	cout << "owner = " << file2.uid().name() << endl;
	cout << "group owner = " << file2.gid().name() << endl;
	cout << "is a file? = " << file2.isFile() << endl;
	cout << "is a directory? = " << file2.isDir() << endl;
}

void testSpDir()
{
	SpDir dir("test/templateImages/");
	checkEqual("SpDir test 1", dir.path().fullName(), "test/templateImages");
	checkEqual("SpDir test 2", dir.size().kbytes(), 1);
	// Think of some way to test the modification dates automatically
	// Check that this user owns the files
	SpUid u;
	u.setCurrent();
	checkEqual("SpDir test 6", dir.uid().name(), u.name());
	SpGid g;
	g.setCurrent();
	checkEqual("SpDir test 7", dir.gid().name(), g.name());
	checkEqual("SpDir test 8", dir.isFile(), false);
	checkEqual("SpDir test 9", dir.isDir(), true);
	list<SpFsObject *> ls = dir.ls();
	// Create a vector of just the filenames
	vector<string> names;
	for (list<SpFsObject *>::iterator a = ls.begin(); a != ls.end(); ++a) {
		names.push_back((*a)->path().fullName());
	}
	sort(names.begin(), names.end());
	vector<string>::iterator a = names.begin();
	checkEqual("SpDir ls test 1",  (*a++), "test/templateImages/2x2.gif");
	checkEqual("SpDir ls test 2",  (*a++), "test/templateImages/2x2.jpg");
	checkEqual("SpDir ls test 3",  (*a++), "test/templateImages/2x2.sgi");
	checkEqual("SpDir ls test 4",  (*a++), "test/templateImages/2x2.tiff");
	checkEqual("SpDir ls test 5",  (*a++), "test/templateImages/4x4.gif");
	checkEqual("SpDir ls test 6",  (*a++), "test/templateImages/4x4.jpg");
	checkEqual("SpDir ls test 7",  (*a++), "test/templateImages/4x4.sgi");
	checkEqual("SpDir ls test 8",  (*a++), "test/templateImages/4x4.tiff");
	checkEqual("SpDir ls test 9",  (*a++), "test/templateImages/8x8.gif");
	checkEqual("SpDir ls test 10", (*a++), "test/templateImages/8x8.jpg");
	checkEqual("SpDir ls test 11", (*a++), "test/templateImages/8x8.sgi");
	checkEqual("SpDir ls test 12", (*a++), "test/templateImages/8x8.tiff");
	checkEqual("SpDir ls test 13", (*a++), "test/templateImages/CVS");
}

void testSpPath()
{
	SpPath p("/home/blah/foo.tif");
	checkEqual("SpPath test 1", p.fullName(), "/home/blah/foo.tif");
	checkEqual("SpPath test 2", p.root(),     "/home/blah/");
	checkEqual("SpPath test 3", p.relative(), "foo.tif");
	SpPath p2("/home/blah/");
	checkEqual("SpPath test 4", p2.fullName(), "/home/blah");
	checkEqual("SpPath test 5", p2.root(),     "/home/");
	checkEqual("SpPath test 6", p2.relative(), "blah");
	SpPath p3("blah");
	checkEqual("SpPath test 7", p3.fullName(), "blah");
	checkEqual("SpPath test 8", p3.root(),     "");
	checkEqual("SpPath test 9", p3.relative(), "blah");
	SpPath p4("/home/blah///");
	checkEqual("SpPath test 10", p4.fullName(), "/home/blah");
	checkEqual("SpPath test 11", p4.root(),     "/home/");
	checkEqual("SpPath test 12", p4.relative(), "blah");
	SpPath p5("/blah");
	checkEqual("SpPath test 13", p5.fullName(), "/blah");
	checkEqual("SpPath test 14", p5.root(),     "/");
	checkEqual("SpPath test 15", p5.relative(), "blah");
}

main()
{
	// Register the plugins
	SpImage::registerPlugins();
	
	testSpSize();
	space();
	testSpTime();
	space();
	testSpUid();
	space();
	testSpFile();
	space();
	testSpImage();
	space();
	testSpFsObject();
	testSpDir();
	testSpPath();
	
	if (noErrors == 0)
		cout << endl << "All tests passed" << endl;
	
	SpImage::deRegisterPlugins();
}


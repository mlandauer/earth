// $Id$
// Some very simple test code

#include <stream.h>

#include "SpFile.h"
#include "SpImage.h"
#include "SpFsObject.h"
#include "SpDir.h"

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
	SpFile file("/home/matthew/images/blah1.tiff");
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
	f.setPath("/home/matthew/images/blah1.tiff");
	cout << "open..." << endl;
	f.open();
	cout << "setPath..." << endl;
	f.setPath("/home/matthew/images/blah1.tiff");
	cout << "close..." << endl;
	f.close();
	cout << "setPath..." << endl;
	f.setPath("/home/matthew/images/blah1.tiff");	
}

void testSpImage()
{
	SpImage *image1 = SpImage::construct("/home/matthew/images/dibble1.sgi");
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

	SpImage *image2 = SpImage::construct("/home/matthew/images/blah1.tiff");
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

	SpImage *image3 = SpImage::construct("/home/matthew/images/foo1.gif");
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
	SpFsObject file("/home/matthew/images/blah1.tiff");
	cout << "path = " << file.path().fullName() << endl;
	cout << "size = " << file.size().kbytes() << " Kbytes" << endl;
	cout << "last access = " << file.lastAccess().timeAndDateString() << endl;
	cout << "last modification = " << file.lastModification().timeAndDateString() << endl;
	cout << "last change = " << file.lastChange().timeAndDateString() << endl;
	cout << "owner = " << file.uid().name() << endl;
	cout << "group owner = " << file.gid().name() << endl;
	cout << "is a file? = " << file.isFile() << endl;
	cout << "is a directory? = " << file.isDir() << endl;
	SpFsObject file2("/home/matthew/images/");
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
	cout << "Test Directory Class" << endl;
	SpDir dir("/home/matthew/images/");
	cout << "path = " << dir.path().fullName() << endl;
	cout << "size = " << dir.size().kbytes() << " Kbytes" << endl;
	cout << "last access = " << dir.lastAccess().timeAndDateString() << endl;
	cout << "last modification = " << dir.lastModification().timeAndDateString() << endl;
	cout << "last change = " << dir.lastChange().timeAndDateString() << endl;
	cout << "owner = " << dir.uid().name() << endl;
	cout << "group owner = " << dir.gid().name() << endl;
	cout << "is a file? = " << dir.isFile() << endl;
	cout << "is a directory? = " << dir.isDir() << endl;
	list<SpFsObject *> ls = dir.ls();
	// Just print out the names
	cout << "Contents of directory " << dir.path().fullName() << ":" << endl;
	for (list<SpFsObject *>::iterator a = ls.begin(); a != ls.end(); ++a) {
		cout << (*a)->path().fullName() << endl;
	}
}

void testSpPath()
{
	cout << "*** Testing SpPath" << endl;
	SpPath p("/home/blah/foo.tif");
	cout << "/home/blah/foo.tif --> " << p.fullName() << endl;
	cout << "root = " << p.root() << endl;
	cout << "relative = " << p.relative() << endl;
	SpPath p2("/home/blah/");
	cout << "/home/blah/ --> " << p2.fullName() << endl;
	cout << "root = " << p2.root() << endl;
	cout << "relative = " << p2.relative() << endl;
	SpPath p3("blah");
	cout << "blah --> " << p3.fullName() << endl;
	cout << "root = " << p3.root() << endl;
	cout << "relative = " << p3.relative() << endl;
	SpPath p4("/home/blah///");
	cout << "/home/blah/// --> " << p4.fullName() << endl;
	cout << "root = " << p4.root() << endl;
	cout << "relative = " << p4.relative() << endl;
	SpPath p5("/blah");
	cout << "/blah --> " << p5.fullName() << endl;
	cout << "root = " << p5.root() << endl;
	cout << "relative = " << p5.relative() << endl;	
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
	space();
	testSpDir();
	space();
	testSpPath();
	
	SpImage::deRegisterPlugins();
}


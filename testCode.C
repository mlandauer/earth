// $Id$
// Some very simple test code

#include <stream.h>

#include "SpFile.h"
#include "SpImage.h"
#include "SpFsObject.h"

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
}

void testSpImage()
{
	SpImage *image1 = SpImage::construct("/home/matthew/images/dibble1.sgi");
	cout << "Opened image " << image1->path().fullName() << endl;
	cout << "Image Filesize = " << image1->size().kbytes() << " Kbytes" << endl;
	cout << "Last modification = " << image1->lastModification().timeAndDateString() << endl;
	cout << "Image format = " << image1->formatString() << endl;
	cout << "Image width = " << image1->dim().width() << endl;
	cout << "Image height = " << image1->dim().height() << endl;
	delete image1;

	SpImage *image2 = SpImage::construct("/home/matthew/images/blah1.tiff");
	cout << "Opened image " << image2->path().fullName() << endl;
	cout << "Image Filesize = " << image2->size().kbytes() << " Kbytes" << endl;
	cout << "Last modification = " << image2->lastModification().timeAndDateString() << endl;
	cout << "Image format = " << image2->formatString() << endl;
	cout << "Image width = " << image2->dim().width() << endl;
	cout << "Image height = " << image2->dim().height() << endl;
	delete image2;
	
	// *** FIT File format currently untested ****
	// *** PRMANZ File format currently untested ****

	SpImage *image3 = SpImage::construct("/home/matthew/images/foo1.gif");
	cout << "Opened image " << image3->path().fullName() << endl;
	cout << "Image Filesize = " << image3->size().kbytes() << " Kbytes" << endl;
	cout << "Last modification = " << image3->lastModification().timeAndDateString() << endl;
	cout << "Image format = " << image3->formatString() << endl;
	cout << "Image width = " << image3->dim().width() << endl;
	cout << "Image height = " << image3->dim().height() << endl;
	delete image3;
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
	cout << "last access = " << file.lastAccess().timeAndDateString() << endl;
	cout << "last modification = " << file.lastModification().timeAndDateString() << endl;
	cout << "last change = " << file.lastChange().timeAndDateString() << endl;
	cout << "owner = " << file.uid().name() << endl;
	cout << "group owner = " << file.gid().name() << endl;
	SpFsObject file2("/home/matthew/images/");
	cout << "path = " << file2.path().fullName() << endl;
	cout << "last access = " << file2.lastAccess().timeAndDateString() << endl;
	cout << "last modification = " << file2.lastModification().timeAndDateString() << endl;
	cout << "last change = " << file2.lastChange().timeAndDateString() << endl;
	cout << "owner = " << file2.uid().name() << endl;
	cout << "group owner = " << file2.gid().name() << endl;
}





main()
{
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
}


// $Id$
// Some very simple test code

#include <stream.h>

#include "SpFile.h"
#include "SpImage.h"

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
	cout << "Current time and date = " << t.string() << endl;
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
	cout << "last access = " << file.lastAccess().string() << endl;
	cout << "last modification = " << file.lastModification().string() << endl;
	cout << "last change = " << file.lastChange().string() << endl;
	cout << "owner = " << file.uid().string() << endl;
	cout << "group owner = " << file.gid().string() << endl;
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
	
	SpFile file2("/home/matthew/images/dibble1.sgi");
	SpImage *image = SpImage::open(file2);
	cout << "Opened image " << file2.path().fullName() << endl;
	cout << "Image format = " << image->formatString() << endl;
	cout << "Image width = " << image->width() << endl;
	cout << "Image height = " << image->height() << endl;
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
	cout << "current user = " << u.string() << endl;
	cout << "current group = " << g.string() << endl;
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
}


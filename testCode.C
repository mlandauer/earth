// $Id$
// Some very simple test code

#include <stream.h>

#include "SpMisc.h"
#include "SpFile.h"
#include "SpTime.h"

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

void testSpFile()
{
	SpFile file("/home/matthew/images/blah1.tiff");
	cout << "filename = " << file.path().fullName() << endl;
	cout << "size = " << file.size().bytes() << " bytes" << endl;
	cout << "size = " << file.size().kbytes() << " Kbytes" << endl;
}

void testSpTime()
{
	SpTime t;
	t.setCurrentTime();
	cout << "Current time and date = " << t.string() << endl;
}

void space()
{
	cout << "=========================" << endl;
}

main()
{
	testSpSize();
	space();
	testSpFile();
	space();
	testSpTime();
}


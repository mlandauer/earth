// $Id$
// Some very simple test code

#include <stream.h>

#include "SpMisc.h"
#include "SpFile.h"

void testSpSize()
{
	SpSize s;
	s.setBytes(4097);
	cout << s.getBytes()  << " bytes = " <<
	        s.getKBytes() << " Kb = " <<
	        s.getMBytes() << " Mb = " <<
	        s.getGBytes() << " Gb" << endl;

	// This will overflow the bytes return
	s.setGBytes(10);
	cout << s.getBytes()  << " bytes = " <<
	        s.getKBytes() << " Kb = " <<
	        s.getMBytes() << " Mb = " <<
	        s.getGBytes() << " Gb" << endl;
}

void testSpFile()
{
	SpFile file("/home/matthew/images/blah1.tiff");
	//cout << "filename = " << getName() << endl;
	//cout << "Full Path = " << getFullName() << endl;
}

main()
{
	testSpSize();
	testSpFile();
}


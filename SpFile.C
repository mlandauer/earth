// $Id$

#include <stream.h>

#include "SpFile.h"
#include "SpMisc.h"

SpFile::SpFile(SpString path)
{
	cout << "Creating SpFile with path = " << path << endl;
	fullName = path;
}

SpFile::~SpFile()
{
}


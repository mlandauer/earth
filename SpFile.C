// $Id$

#include <sys/stat.h>
#include <unistd.h>
#include <fcntl.h>

#include <stream.h>

#include "SpFile.h"
#include "SpPathString.h"

SpFile::SpFile()
{
}

SpFile::SpFile(const string &path)
{
	setPath(path);
}

SpFile::~SpFile()
{
}

SpSize SpFile::size() const
{
	struct stat fileStat;
	SpSize s;
	lstat(path().fullName().c_str(), &fileStat);
	s.setBytes(fileStat.st_size);
	return (s);
}

// Opens for read only at the moment
void SpFile::open()
{
	fd = std::open(path().fullName().c_str(), O_RDONLY);
	// TEMPORARY HACK
	if (fd == -1)
		cerr << "Error opening file " << path().fullName().c_str() << endl;
}

void SpFile::close()
{
	std::close(fd);
}

unsigned long int SpFile::read(void *buf, unsigned long int count) const
{
	return (std::read(fd, buf, count));
}

void SpFile::seek(unsigned long int pos) const
{
	lseek(fd, pos, SEEK_SET);
}

void SpFile::seekForward(unsigned long int pos) const
{
	lseek(fd, pos, SEEK_CUR);
}

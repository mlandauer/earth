// $Id$

#include <unistd.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <unistd.h>

#include "SpFile.h"

SpFile::SpFile(const SpPath &path) : fileOpen(false), SpFsObject(path)
{
}

bool SpFile::valid() const
{
	struct stat fileStat;
	lstat(path().fullName().c_str(), &fileStat);
	return(S_ISREG(fileStat.st_mode));
}

void SpFile::setPath(const SpPath &path)
{
	if (!fileOpen)
		SpFsObject::setPath(path);
	//else 
	//	cerr << "Cannot setPath for file when it is open!" << endl;
}

// Opens for read only at the moment
void SpFile::open()
{
	fd = std::open(path().fullName().c_str(), O_RDONLY);
	// TEMPORARY HACK
	if (fd == -1)
		cerr << "Error opening file " << path().fullName().c_str() << endl;
	else
		fileOpen = true;
}

SpSize SpFile::size() const
{
	struct stat fileStat;
	SpSize s;
	lstat(path().fullName().c_str(), &fileStat);
	s.setBytes(fileStat.st_size);
	return (s);
}

void SpFile::close()
{
	std::close(fd);
	fileOpen = false;
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

unsigned char SpFile::readChar() const
{
	unsigned char value;
	read(&value, 1);
	return (value);
}

unsigned short SpFile::readShort(const int &endian) const
{
	unsigned short value;
	unsigned char temp[2];
	read(temp, 2);

	// If small endian
	if (endian == 0)
		value = (temp[0]<<0) + (temp[1]<<8);
	else
		value = (temp[0]<<8) + (temp[1]<<0);
	return (value);
}

unsigned long SpFile::readLong(const int &endian) const
{
	unsigned char temp[4];
	read(temp, 4);

	unsigned long value;
	if (endian == 0)
		value = (temp[0]<<0) + (temp[1]<<8) + (temp[2]<<16) + (temp[3]<<24);
	else
		value = (temp[0]<<24) + (temp[1]<<16) + (temp[2]<<8) + (temp[3]<<0);
	return (value);
}

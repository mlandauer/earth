//  Copyright (C) 2001 Matthew Landauer. All Rights Reserved.
//  
//  This program is free software; you can redistribute it and/or modify it
//  under the terms of version 2 of the GNU General Public License as
//  published by the Free Software Foundation.
//
//  This program is distributed in the hope that it would be useful, but
//  WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  Further, any
//  license provided herein, whether implied or otherwise, is limited to
//  this program in accordance with the express provisions of the GNU
//  General Public License.  Patent licenses, if any, provided herein do not
//  apply to combinations of this program with other product or programs, or
//  any other product whatsoever.  This program is distributed without any
//  warranty that the program is delivered free of the rightful claim of any
//  third person by way of infringement or the like.  See the GNU General
//  Public License for more details.
//
//  You should have received a copy of the GNU General Public License along
//  with this program; if not, write the Free Software Foundation, Inc., 59
//  Temple Place - Suite 330, Boston MA 02111-1307, USA.
//
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
#include "SpDirMonitor.h"
#include "SpImageSequence.h"

class testSpSize : public SpTester
{
public:
	testSpSize() : SpTester("SpSize") { test(); };
	void test() {
		SpSize s;
		s.setBytes(4097);
		checkEqual("test 1", s.bytes(), 4097.0);
		checkEqual("test 2", s.kbytes(), 4.0);
		checkEqual("test 3", s.mbytes(), 0.0);
		checkEqual("test 4", s.gbytes(), 0.0);

		s.setGBytes(10);
		checkEqual("test 5", s.gbytes(), 10.0);
		checkEqual("test 6", s.mbytes(), 10240.0);
		checkEqual("test 7", s.kbytes(), 10485760.0);
		checkEqual("test 8", s.bytes(), 1.073741e10, 10e5);
	
		s.setBytes(0);
		checkEqual("test 9", s.bytes(), 0.0);
		checkEqual("test 10", s.kbytes(), 0.0);
		checkEqual("test 11", s.mbytes(), 0.0);
		checkEqual("test 12", s.gbytes(), 0.0);
	}
};

class testSpTime : public SpTester
{
public:
	testSpTime() : SpTester("SpTime") { test(); };
	void test() {
		SpTime t1;
		t1.setUnixTime(0);
		checkEqual("test 1", t1.timeAndDateString(), "Wed Dec 31 16:00:00 1969");
		checkEqual("test 2", t1.year(), 1969);
		checkEqual("test 3", t1.hour(), 16);
		checkEqual("test 4", t1.minute(), 0);
		checkEqual("test 5", t1.second(), 0);
		checkEqual("test 6", t1.dayOfWeek(), 3);
		checkEqual("test 7", t1.dayOfMonth(), 31);
		checkEqual("test 8", t1.month(), 12);
		checkEqual("test 9", t1.monthStringShort(), "Dec");
		checkEqual("test 10", t1.monthString(), "December");
		checkEqual("test 11", t1.dayOfWeekStringShort(), "Wed");
		checkEqual("test 12", t1.dayOfWeekString(), "Wednesday");
		checkEqual("test 13", t1.timeString(), "16:00:00");
		SpTime t2;
		t2.setUnixTime(100);
		SpTime t0;
		check("test 14",    t0 == t1);
		check("test 15a",   t0 <  t2);
		check("test 15b", !(t0 >  t2));
		check("test 15c",   t0 != t2);
		check("test 16a",   t1 <  t2);
		check("test 16b", !(t1 >  t2));
		check("test 16c",   t1 != t2);
	}
};

class testSpFile : public SpTester
{
public:
	testSpFile() : SpTester("SpFile") { test(); };
	void test() {
		SpFile file("test/templateImages/8x8.tiff");
		checkEqualBool("test 0", file.valid(), true);
		checkEqual("test 1", file.path().fullName(), "test/templateImages/8x8.tiff");
		checkEqual("test 2", file.size().bytes(), 396.0);
		checkEqual("test 3", file.size().kbytes(), 0.39);
		file.open();
		unsigned char buf[2];
		int a;
		checkEqual("test 4", file.read(buf, 2), 2);
		checkEqual("test 5", buf[0], 0x49);
		checkEqual("test 6", buf[1], 0x49);
		file.seek(10);
		file.read(buf, 1);
		checkEqual("test 7", buf[0], 0xff);
		file.seekForward(2);
		file.read(buf, 1);
		checkEqual("test 8", buf[0], 0xff);
		file.close();
	}
};

class testSpImage : public SpTester
{
public:
	testSpImage() : SpTester("SpImage") { test(); };
	void test() {
		SpImage *image1 = SpImage::construct("test/templateImages/8x8.sgi");
		if (checkNotNULL("test 0", image1)) {
			checkEqual("test 1", image1->path().fullName(),
				"test/templateImages/8x8.sgi");
			checkEqual("test 2", image1->size().kbytes(), 0.89);
			checkEqual("test 3", image1->formatString(), "SGI");
			checkEqual("test 4", image1->dim().width(), 8);
			checkEqual("test 5", image1->dim().height(), 8);
			delete image1;
		}
	
		SpImage *image2 = SpImage::construct("test/templateImages/8x8.tiff");
		if (checkNotNULL("test 5b", image2)) {
			checkEqual("test 6", image2->path().fullName(),
				"test/templateImages/8x8.tiff");
			checkEqual("test 7", image2->size().kbytes(), 0.39);
			checkEqual("test 8", image2->formatString(), "TIFF");
			checkEqual("test 9", image2->dim().width(), 8);
			checkEqual("test 10", image2->dim().height(), 8);
			delete image2;
		}
		
		// *** FIT File format currently untested ****
		// *** PRMANZ File format currently untested ****
		// *** PRTEX File format currently untested ****
		// *** CINEON File format currently untested ****
		// *** IFF File format currently untested ****
	
		SpImage *image3 = SpImage::construct("test/templateImages/8x8.gif");
		if (checkNotNULL("test 10b", image3)) {
			checkEqual("test 11", image3->path().fullName(),
				"test/templateImages/8x8.gif");
			checkEqual("test 12", image3->size().kbytes(), 0.83);
			checkEqual("test 13", image3->formatString(), "GIF");
			checkEqual("test 14", image3->dim().width(), 8);
			checkEqual("test 15", image3->dim().height(), 8);
			delete image3;
		}
	}
};



class testSpUid : public SpTester
{
public:
	testSpUid() : SpTester("SpUid") { test(); };
	void test() {
		// Have to think of some way of testing this class
	}
};

class testSpFsObject : public SpTester
{
public:
	testSpFsObject() : SpTester("SpFsObject") { test(); };
	void test() {
		SpFsObject *file = SpFsObject::construct("test/templateImages/8x8.tiff");
		checkEqual("test 1", file->path().fullName(),
			"test/templateImages/8x8.tiff");
		SpUid u;
		u.setCurrent();
		SpGid g;
		g.setCurrent();
		checkEqual("test 2", file->uid().name(), u.name());
		checkEqual("test 3", file->gid().name(), g.name());
		checkNotNULL("test 4", dynamic_cast<SpFile *>(file));
		checkNULL("test 5", dynamic_cast<SpDir *>(file));
		delete file;
		SpFsObject *file2 = SpFsObject::construct("test/templateImages/");
		checkEqual("test 6", file2->path().fullName(), "test/templateImages");
		// Find some way to test access, modification and change times
		checkNULL("test 7", dynamic_cast<SpFile *>(file2));
		checkNotNULL("test 8", dynamic_cast<SpDir *>(file2));
		delete file2;
		// Test opening a non-existing file or directory
		SpFsObject *notExist = SpFsObject::construct("test/templateImages/no");
		checkNULL("test 9", notExist);
	}
};

class testSpDir : public SpTester
{
public:
	testSpDir() : SpTester("SpDir") { test(); };
	void test() {
		SpDir dir("test/templateImages/");
		checkEqual("test 1", dir.path().fullName(),
			"test/templateImages");
		// Think of some way to test the modification dates automatically
		// Check that this user owns the files
		SpUid u;
		u.setCurrent();
		checkEqual("test 2", dir.uid().name(), u.name());
		SpGid g;
		g.setCurrent();
		checkEqual("test 3", dir.gid().name(), g.name());
		checkEqualBool("test 4", dir.valid(), true);
		vector<SpFsObject *> ls = dir.ls();
		if (checkEqual("ls test 0", ls.size(), 13)) {
			vector<SpFsObject *>::iterator a = ls.begin();
			checkImage("ls test 1", *(a++), "test/templateImages/2x2.gif", "GIF");
			checkNotImage("ls test 2", *(a++), "test/templateImages/2x2.jpg");
			checkImage("ls test 3", *(a++), "test/templateImages/2x2.sgi", "SGI");
			checkImage("ls test 4", *(a++), "test/templateImages/2x2.tiff", "TIFF");
			checkImage("ls test 5", *(a++), "test/templateImages/4x4.gif", "GIF");		
			checkNotImage("ls test 6", *(a++), "test/templateImages/4x4.jpg");						
			checkImage("ls test 7", *(a++), "test/templateImages/4x4.sgi", "SGI");		
			checkImage("ls test 8", *(a++), "test/templateImages/4x4.tiff", "TIFF");		
			checkImage("ls test 9", *(a++), "test/templateImages/8x8.gif", "GIF");		
			checkNotImage("ls test 10", *(a++), "test/templateImages/8x8.jpg");		
			checkImage("ls test 11", *(a++), "test/templateImages/8x8.sgi", "SGI");		
			checkImage("ls test 12", *(a++), "test/templateImages/8x8.tiff", "TIFF");		
			checkDir("ls test 13", *(a++), "test/templateImages/CVS");		
		}
		for (vector<SpFsObject *>::iterator a=ls.begin(); a!=ls.end(); ++a)
			delete *a;
		// Try doing an ls on a non-existant directory
		SpDir dirNotExist("test/whatASillyFella");
		checkEqualBool("non-existant test 1", dirNotExist.valid(), false);
		vector<SpFsObject *> lsNotExist = dirNotExist.ls();
		checkEqual("non-existant test 2", lsNotExist.size(), 0);
	}
	void checkImage(string n, SpFsObject *o, string fileName, string formatString) {
		checkEqual(n + "a",  o->path().fullName(), fileName);
		SpImage *i = dynamic_cast<SpImage *>(o);
		if (SpTester::checkNotNULL(n + "b", i))
			checkEqual(n + "c",  i->formatString(), formatString);		
	}
	void checkNotImage(string n, SpFsObject *o, string fileName) {
		checkEqual(n + "a",  o->path().fullName(), fileName);
		checkNULL(n + "b",  dynamic_cast<SpImage *>(o));
	}
	void checkDir(string n, SpFsObject *o, string fileName) {
		checkEqual(n + "a",  o->path().fullName(), fileName);
		checkNotNULL(n + "b",  dynamic_cast<SpDir *>(o));
	}
};

class testSpPath : public SpTester
{
public:
	testSpPath() : SpTester("SpPath") { test(); };
	void test() {
		SpPath p("/home/blah/foo.tif");
		checkEqual("test 1", p.fullName(), "/home/blah/foo.tif");
		checkEqual("test 2", p.root(),     "/home/blah/");
		checkEqual("test 3", p.relative(), "foo.tif");
		SpPath p2("/home/blah/");
		checkEqual("test 4", p2.fullName(), "/home/blah");
		checkEqual("test 5", p2.root(),     "/home/");
		checkEqual("test 6", p2.relative(), "blah");
		SpPath p3("blah");
		checkEqual("test 7", p3.fullName(), "blah");
		checkEqual("test 8", p3.root(),     "");
		checkEqual("test 9", p3.relative(), "blah");
		SpPath p4("/home/blah///");
		checkEqual("test 10", p4.fullName(), "/home/blah");
		checkEqual("test 11", p4.root(),     "/home/");
		checkEqual("test 12", p4.relative(), "blah");
		SpPath p5("/blah");
		checkEqual("test 13", p5.fullName(), "/blah");
		checkEqual("test 14", p5.root(),     "/");
		checkEqual("test 15", p5.relative(), "blah");
		// Check that paths can be ordered alphabetically
		SpPath p6("alpha");
		SpPath p7("beta");
		SpPath p8("gamma");
		SpPath p9("gammb");
		SpPath p10("gammb");
		check("test 16", p6 < p7);
		check("test 17", p6 < p8);
		check("test 18", p6 < p9);
		check("test 19", p7 < p8);
		check("test 20", p7 < p9);
		check("test 21", p8 < p9);
		// The reverse
		check("test 16", !(p6 > p7));
		check("test 17", !(p6 > p8));
		check("test 18", !(p6 > p9));
		check("test 19", !(p7 > p8));
		check("test 20", !(p7 > p9));
		check("test 21", !(p8 > p9));
		// Equality
		check("test 22", p9 == p10);
		check("test 23", p6 == p6);
		check("test 24", p6 != p7);
	}
};

class testSpDirMonitor : public SpTester
{
public:
	testSpDirMonitor() : SpTester("SpDirMonitor") { test(); };
	void checkNextEvent(string testName, SpDirMonitor *m, int code, string pathName) {
		SpDirMonitorEvent e = m->getNextEvent();
		checkEqual(testName + "a", e.getCode(), code);
		checkEqual(testName + "b", e.getPath().fullName(), pathName);
	}
	void test() {
		SpDirMonitorEvent e;
		cout << "Note: the following tests will take about 20 seconds" << endl;
		// First create a directory with some test files
		system ("rm -fr test/FsMonitor");
		system ("mkdir test/FsMonitor");
		system ("cp test/templateImages/2x2.gif test/FsMonitor/test.0001.gif");
		system ("cp test/templateImages/2x2.gif test/FsMonitor/test.0002.gif");
		system ("cp test/templateImages/2x2.gif test/FsMonitor/test.0003.gif");
		system ("cp test/templateImages/2x2.gif test/FsMonitor/test.0004.gif");
		SpDirMonitor *m = SpDirMonitor::construct(SpDir("test/FsMonitor"));
		if (checkNotNULL("test 0", m)) {
			checkEqualBool("test 1", m->pendingEvent(), true);
			checkNextEvent("test 2", m, SpDirMonitorEvent::added, "test/FsMonitor/test.0001.gif");
			checkNextEvent("test 3", m, SpDirMonitorEvent::added, "test/FsMonitor/test.0002.gif");
			checkNextEvent("test 4", m, SpDirMonitorEvent::added, "test/FsMonitor/test.0003.gif");
			checkNextEvent("test 5", m, SpDirMonitorEvent::added, "test/FsMonitor/test.0004.gif");
			checkEqualBool("test 1j", m->pendingEvent(), false);
			
			system ("rm test/FsMonitor/test.0001.gif");
			system ("cp test/templateImages/2x2.gif test/FsMonitor/test.0005.gif");
			system ("mkdir test/FsMonitor/subdirectory");
			SpTime::sleep(6);
			checkEqualBool("test 6", m->pendingEvent(), true);
			checkNextEvent("test 7", m, SpDirMonitorEvent::added, "test/FsMonitor/test.0005.gif");
			checkNextEvent("test 8", m, SpDirMonitorEvent::added, "test/FsMonitor/subdirectory");
			checkNextEvent("test 9", m, SpDirMonitorEvent::deleted, "test/FsMonitor/test.0001.gif");
			checkEqualBool("test 10", m->pendingEvent(), false);

			system ("rm -fr test/FsMonitor");
			SpTime::sleep(6);
			checkEqualBool("test 11", m->pendingEvent(), true);
			checkNextEvent("test 12", m, SpDirMonitorEvent::deleted, "test/FsMonitor/test.0005.gif");
			checkNextEvent("test 13", m, SpDirMonitorEvent::deleted, "test/FsMonitor/test.0002.gif");
			checkNextEvent("test 14", m, SpDirMonitorEvent::deleted, "test/FsMonitor/test.0003.gif");
			checkNextEvent("test 15", m, SpDirMonitorEvent::deleted, "test/FsMonitor/test.0004.gif");
			checkNextEvent("test 16", m, SpDirMonitorEvent::deleted, "test/FsMonitor/subdirectory");
			checkEqualBool("test 17", m->pendingEvent(), false);
			delete m;
		}
	}
};

class testSpImageSequence : public SpTester
{
public:
	testSpImageSequence() : SpTester("SpImageSequence") { test(); };
	void test() {
		system ("rm -rf test/seq");
		SpPath path1a("test/seq/test1.0001.gif");
		SpPath path1b("test/seq/test1.0002.gif");
		SpPath path1c("test/seq/test1.0003.gif");
		SpPath path1d("test/seq/test1.0004.gif");
		SpPath path2a("test/seq/test2.8.gif");		
		SpPath path3a("test/seq/test2.000123.gif");		
		SpPath path4a("test/seq/120.gif");		
		SpPath path5a("test/seq/110.gif");
		makeDirectory("test/seq");
		copyFile("test/templateImages/2x2.gif", path1a);
		copyFile("test/templateImages/2x2.gif", path1b);
		copyFile("test/templateImages/2x2.gif", path1c);
		copyFile("test/templateImages/2x2.gif", path1d);
		copyFile("test/templateImages/2x2.gif", path2a);
		copyFile("test/templateImages/2x2.gif", path3a);
		copyFile("test/templateImages/2x2.gif", path4a);
		copyFile("test/templateImages/4x4.tiff", path5a);
		SpImage *i1 = SpImage::construct(path1a);
		SpImage *i2 = SpImage::construct(path1b);
		SpImage *i3 = SpImage::construct(path1c);
		SpImage *i4 = SpImage::construct(path1d);
		SpImage *i5 = SpImage::construct(path2a);
		SpImage *i6 = SpImage::construct(path3a);
		SpImage *i7 = SpImage::construct(path4a);
		SpImage *i8 = SpImage::construct(path5a);
		
		if (checkNotNULL("test 1a", i1)) {
			SpImageSequence seq(i1);
			checkSequence("test 1", seq, "test/seq/test1.#.gif", "1", 2, 2, "GIF");
			if (checkNotNULL("test 2a", i2)) {
				seq.addImage(i2);
				checkSequence("test 2", seq, "test/seq/test1.#.gif", "1-2", 2, 2, "GIF");
			}
			if (checkNotNULL("test 3a", i4)) {
				seq.addImage(i4);
				checkSequence("test 3", seq, "test/seq/test1.#.gif", "1-2,4", 2, 2, "GIF");
			}
			if (checkNotNULL("test 4a", i3)) {
				seq.addImage(i3);
				checkSequence("test 4", seq, "test/seq/test1.#.gif", "1-4", 2, 2, "GIF");
			}
			if (checkNotNULL("test 11a", i2)) {
				seq.removeImage(i2);
				checkSequence("test 11", seq, "test/seq/test1.#.gif", "1,3-4", 2, 2, "GIF");
			}
			// If we remove something that's not part of the sequence nothing should change
			if (checkNotNULL("test 12a", i8)) {
				seq.removeImage(i8);
				checkSequence("test 12", seq, "test/seq/test1.#.gif", "1,3-4", 2, 2, "GIF");
			}
			if (checkNotNULL("test 13a", i2)) {
				seq.removeImage(i2);
				checkSequence("test 13", seq, "test/seq/test1.#.gif", "1,3-4", 2, 2, "GIF");
			}
		}
		
		if (checkNotNULL("test 5a", i5)) {
			SpImageSequence seq2(i5);
			checkSequence("test 5", seq2, "test/seq/test2.@.gif", "8", 2, 2, "GIF");
		}
		if (checkNotNULL("test 6a", i6)) {
			SpImageSequence seq3(i6);
			checkSequence("test 6", seq3, "test/seq/test2.@@@@@@.gif", "123", 2, 2, "GIF");
		}
		
		if (checkNotNULL("test 7a", i7)) {
			SpImageSequence seq4(i7);
			checkSequence("test 7", seq4, "test/seq/@@@.gif", "120", 2, 2, "GIF");
			if (checkNotNULL("test 8a", i5)) {
				// Adding in an image with a different name should not work
				seq4.addImage(i5);
				checkSequence("test 8", seq4, "test/seq/@@@.gif", "120", 2, 2, "GIF");
			}
			if (checkNotNULL("test 9a", i8)) {
				// Adding in an image with a correct name but wrong image size should not work
				seq4.addImage(i8);
				checkSequence("test 9", seq4, "test/seq/@@@.gif", "120", 2, 2, "GIF");
			}
		}
		
		if (checkNotNULL("test 10a", i8)) {
			SpImageSequence seq5(i8);
			checkSequence("test 10", seq5, "test/seq/@@@.gif", "110", 4, 4, "TIFF");
		}
			
		system ("rm -rf test/seq");
		delete i1, i2, i3, i4, i5, i6, i7, i8;
	}
	void checkSequence(string testName, const SpImageSequence &seq,
		string name, string frames, int width, int height, string format) {
		checkEqual(testName + "b", seq.path().fullName(), name);
		checkEqual(testName + "c", seq.framesString(), frames);
		checkEqual(testName + "d", seq.dim().width(), width);
		checkEqual(testName + "e", seq.dim().height(), height);
		checkEqual(testName + "f", seq.format()->formatString(), format);		
	}
	void copyFile(const SpPath &path1, const SpPath &path2) {
		string command = "cp " + path1.fullName() + " " + path2.fullName();
		system (command.c_str());
	}
	void makeDirectory(const SpPath &path) {
		string command = "mkdir " + path.fullName();
		system (command.c_str());
	}
};

main()
{
	// Register the plugins
	SpImageFormat::registerPlugins();
	// Configure the tester
	SpTester::setVerbose(false);
	SpTester::setFloatDelta(0.1);
	// To make tests reliable have to ensure that ls() always
	// returns things in alphabetical order.
	SpDir::setSortByPath(true);
	
	testSpDir();
	testSpSize();
	testSpTime();
	testSpUid();
	testSpFile();
	testSpImage();
	testSpFsObject();
	testSpPath();
	testSpImageSequence();
	//testSpDirMonitor();
	
	SpTester::finish();
	SpImageFormat::deRegisterPlugins();
}


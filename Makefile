# $Id$

CC = g++
OPTION = -g
INCLUDE = 

SRCS = SpDir.C SpFsObject.C SpImageFormat.C SpSize.C testCode.C \
       SpDirMon.C SpGid.C SpImageSequence.C SpTester.C \
       SpDirMonFam.C SpImage.C SpLibLoader.C SpTime.C \
       SpFile.C SpImageDim.C SpPath.C SpUid.C    

OBJECTS = SpSize.o SpFile.o SpPath.o SpTime.o SpTester.o SpLibLoader.o \
          SpUid.o SpGid.o SpImage.o SpImageFormat.o SpImageDim.o \
          SpFsObject.o SpDir.o SpDirMon.o SpDirMonFam.o \
		  SpImageSequence.o

all: testCode
	cd imageFormats; make all
	LD_LIBRARY_PATH=/usr/local/lib:imageFormats ./testCode
	
clean:
	cd imageFormats; make clean
	rm -fr *.o *.so testCode

testCode: testCode.o $(OBJECTS)
	$(CC) $(OPTION) -rdynamic -o testCode testCode.o $(OBJECTS) -ldl -lfam
	
depend:
	cd imageFormats; make depend
	makedepend -I/usr/include/g++ -I/usr/local/include -- $(OPTION) -- $(SRCS)

%.o : %.C
	$(CC) $(OPTION) $(INCLUDE) -c $< -o $@
	
# DO NOT DELETE

SpDir.o: SpDir.h /usr/include/g++/vector /usr/include/g++/stl_algobase.h
SpDir.o: /usr/include/g++/stl_config.h /usr/include/_G_config.h
SpDir.o: /usr/include/bits/types.h /usr/include/features.h
SpDir.o: /usr/include/sys/cdefs.h /usr/include/gnu/stubs.h
SpDir.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/stddef.h
SpDir.o: /usr/include/g++/stl_relops.h /usr/include/g++/stl_pair.h
SpDir.o: /usr/include/g++/type_traits.h /usr/include/string.h
SpDir.o: /usr/include/limits.h /usr/include/bits/posix1_lim.h
SpDir.o: /usr/include/bits/local_lim.h /usr/include/linux/limits.h
SpDir.o: /usr/include/bits/posix2_lim.h /usr/include/stdlib.h
SpDir.o: /usr/include/sys/types.h /usr/include/time.h /usr/include/endian.h
SpDir.o: /usr/include/bits/endian.h /usr/include/sys/select.h
SpDir.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
SpDir.o: /usr/include/sys/sysmacros.h /usr/include/alloca.h
SpDir.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/new.h
SpDir.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/new
SpDir.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/exception
SpDir.o: /usr/include/g++/iostream.h /usr/include/g++/streambuf.h
SpDir.o: /usr/include/libio.h
SpDir.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/stdarg.h
SpDir.o: /usr/include/g++/stl_iterator.h /usr/include/g++/stl_alloc.h
SpDir.o: /usr/include/assert.h /usr/include/pthread.h /usr/include/sched.h
SpDir.o: /usr/include/bits/sched.h /usr/include/signal.h
SpDir.o: /usr/include/bits/pthreadtypes.h /usr/include/bits/sigthread.h
SpDir.o: /usr/include/g++/stl_construct.h
SpDir.o: /usr/include/g++/stl_uninitialized.h /usr/include/g++/stl_vector.h
SpDir.o: /usr/include/g++/stl_bvector.h /usr/include/g++/map
SpDir.o: /usr/include/g++/stl_tree.h /usr/include/g++/stl_function.h
SpDir.o: /usr/include/g++/stl_map.h /usr/include/g++/stl_multimap.h
SpDir.o: SpFsObject.h /usr/include/sys/stat.h /usr/include/bits/stat.h
SpDir.o: SpTime.h /usr/include/g++/string /usr/include/g++/std/bastring.h
SpDir.o: /usr/include/g++/cstddef /usr/include/g++/std/straits.h
SpDir.o: /usr/include/g++/cctype /usr/include/ctype.h
SpDir.o: /usr/include/g++/cstring /usr/include/g++/alloc.h
SpDir.o: /usr/include/g++/iterator /usr/include/g++/cassert
SpDir.o: /usr/include/g++/std/bastring.cc SpPath.h SpUid.h SpGid.h SpSize.h
SpDir.o: SpImage.h /usr/include/g++/list /usr/include/g++/stl_list.h SpFile.h
SpDir.o: SpImageDim.h SpImageFormat.h SpLibLoader.h /usr/include/dlfcn.h
SpDir.o: /usr/include/bits/dlfcn.h /usr/include/g++/algorithm
SpDir.o: /usr/include/g++/stl_tempbuf.h /usr/include/g++/stl_algo.h
SpDir.o: /usr/include/g++/stl_heap.h /usr/include/dirent.h
SpDir.o: /usr/include/bits/dirent.h /usr/include/unistd.h
SpDir.o: /usr/include/bits/posix_opt.h /usr/include/bits/confname.h
SpDir.o: /usr/include/getopt.h
SpFsObject.o: /usr/include/sys/stat.h /usr/include/features.h
SpFsObject.o: /usr/include/sys/cdefs.h /usr/include/gnu/stubs.h
SpFsObject.o: /usr/include/bits/types.h
SpFsObject.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/stddef.h
SpFsObject.o: /usr/include/bits/stat.h /usr/include/unistd.h
SpFsObject.o: /usr/include/bits/posix_opt.h /usr/include/bits/confname.h
SpFsObject.o: /usr/include/getopt.h SpFsObject.h SpTime.h /usr/include/time.h
SpFsObject.o: /usr/include/g++/string /usr/include/g++/std/bastring.h
SpFsObject.o: /usr/include/g++/cstddef /usr/include/g++/std/straits.h
SpFsObject.o: /usr/include/g++/cctype /usr/include/ctype.h
SpFsObject.o: /usr/include/endian.h /usr/include/bits/endian.h
SpFsObject.o: /usr/include/g++/cstring /usr/include/string.h
SpFsObject.o: /usr/include/g++/alloc.h /usr/include/g++/iterator
SpFsObject.o: /usr/include/g++/stl_config.h /usr/include/_G_config.h
SpFsObject.o: /usr/include/g++/stl_relops.h /usr/include/g++/iostream.h
SpFsObject.o: /usr/include/g++/streambuf.h /usr/include/libio.h
SpFsObject.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/stdarg.h
SpFsObject.o: /usr/include/g++/stl_iterator.h /usr/include/g++/cassert
SpFsObject.o: /usr/include/assert.h /usr/include/g++/std/bastring.cc SpPath.h
SpFsObject.o: SpUid.h /usr/include/sys/types.h /usr/include/sys/select.h
SpFsObject.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
SpFsObject.o: /usr/include/sys/sysmacros.h SpGid.h SpSize.h SpDir.h
SpFsObject.o: /usr/include/g++/vector /usr/include/g++/stl_algobase.h
SpFsObject.o: /usr/include/g++/stl_pair.h /usr/include/g++/type_traits.h
SpFsObject.o: /usr/include/limits.h /usr/include/bits/posix1_lim.h
SpFsObject.o: /usr/include/bits/local_lim.h /usr/include/linux/limits.h
SpFsObject.o: /usr/include/bits/posix2_lim.h /usr/include/stdlib.h
SpFsObject.o: /usr/include/alloca.h
SpFsObject.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/new.h
SpFsObject.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/new
SpFsObject.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/exception
SpFsObject.o: /usr/include/g++/stl_alloc.h /usr/include/pthread.h
SpFsObject.o: /usr/include/sched.h /usr/include/bits/sched.h
SpFsObject.o: /usr/include/signal.h /usr/include/bits/pthreadtypes.h
SpFsObject.o: /usr/include/bits/sigthread.h /usr/include/g++/stl_construct.h
SpFsObject.o: /usr/include/g++/stl_uninitialized.h
SpFsObject.o: /usr/include/g++/stl_vector.h /usr/include/g++/stl_bvector.h
SpFsObject.o: /usr/include/g++/map /usr/include/g++/stl_tree.h
SpFsObject.o: /usr/include/g++/stl_function.h /usr/include/g++/stl_map.h
SpFsObject.o: /usr/include/g++/stl_multimap.h SpImage.h /usr/include/g++/list
SpFsObject.o: /usr/include/g++/stl_list.h SpFile.h SpImageDim.h
SpFsObject.o: SpImageFormat.h SpLibLoader.h /usr/include/dlfcn.h
SpFsObject.o: /usr/include/bits/dlfcn.h
SpImageFormat.o: /usr/include/g++/fstream /usr/include/g++/fstream.h
SpImageFormat.o: /usr/include/g++/iostream.h /usr/include/g++/streambuf.h
SpImageFormat.o: /usr/include/libio.h /usr/include/_G_config.h
SpImageFormat.o: /usr/include/bits/types.h /usr/include/features.h
SpImageFormat.o: /usr/include/sys/cdefs.h /usr/include/gnu/stubs.h
SpImageFormat.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/stddef.h
SpImageFormat.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/stdarg.h
SpImageFormat.o: SpImageFormat.h /usr/include/g++/string
SpImageFormat.o: /usr/include/g++/std/bastring.h /usr/include/g++/cstddef
SpImageFormat.o: /usr/include/g++/std/straits.h /usr/include/g++/cctype
SpImageFormat.o: /usr/include/ctype.h /usr/include/endian.h
SpImageFormat.o: /usr/include/bits/endian.h /usr/include/g++/cstring
SpImageFormat.o: /usr/include/string.h /usr/include/g++/alloc.h
SpImageFormat.o: /usr/include/g++/iterator /usr/include/g++/stl_config.h
SpImageFormat.o: /usr/include/g++/stl_relops.h
SpImageFormat.o: /usr/include/g++/stl_iterator.h /usr/include/g++/cassert
SpImageFormat.o: /usr/include/assert.h /usr/include/g++/std/bastring.cc
SpImageFormat.o: SpLibLoader.h /usr/include/g++/list
SpImageFormat.o: /usr/include/g++/stl_algobase.h /usr/include/g++/stl_pair.h
SpImageFormat.o: /usr/include/g++/type_traits.h /usr/include/limits.h
SpImageFormat.o: /usr/include/bits/posix1_lim.h /usr/include/bits/local_lim.h
SpImageFormat.o: /usr/include/linux/limits.h /usr/include/bits/posix2_lim.h
SpImageFormat.o: /usr/include/stdlib.h /usr/include/sys/types.h
SpImageFormat.o: /usr/include/time.h /usr/include/sys/select.h
SpImageFormat.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
SpImageFormat.o: /usr/include/sys/sysmacros.h /usr/include/alloca.h
SpImageFormat.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/new.h
SpImageFormat.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/new
SpImageFormat.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/exception
SpImageFormat.o: /usr/include/g++/stl_alloc.h /usr/include/pthread.h
SpImageFormat.o: /usr/include/sched.h /usr/include/bits/sched.h
SpImageFormat.o: /usr/include/signal.h /usr/include/bits/pthreadtypes.h
SpImageFormat.o: /usr/include/bits/sigthread.h
SpImageFormat.o: /usr/include/g++/stl_construct.h
SpImageFormat.o: /usr/include/g++/stl_uninitialized.h
SpImageFormat.o: /usr/include/g++/stl_list.h /usr/include/dlfcn.h
SpImageFormat.o: /usr/include/bits/dlfcn.h SpPath.h SpFile.h SpTime.h
SpImageFormat.o: SpSize.h SpUid.h SpGid.h SpFsObject.h
SpImageFormat.o: /usr/include/sys/stat.h /usr/include/bits/stat.h
SpSize.o: SpSize.h
testCode.o: /usr/include/g++/stream.h /usr/include/g++/iostream.h
testCode.o: /usr/include/g++/streambuf.h /usr/include/libio.h
testCode.o: /usr/include/_G_config.h /usr/include/bits/types.h
testCode.o: /usr/include/features.h /usr/include/sys/cdefs.h
testCode.o: /usr/include/gnu/stubs.h
testCode.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/stddef.h
testCode.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/stdarg.h
testCode.o: /usr/include/g++/algorithm /usr/include/g++/stl_algobase.h
testCode.o: /usr/include/g++/stl_config.h /usr/include/g++/stl_relops.h
testCode.o: /usr/include/g++/stl_pair.h /usr/include/g++/type_traits.h
testCode.o: /usr/include/string.h /usr/include/limits.h
testCode.o: /usr/include/bits/posix1_lim.h /usr/include/bits/local_lim.h
testCode.o: /usr/include/linux/limits.h /usr/include/bits/posix2_lim.h
testCode.o: /usr/include/stdlib.h /usr/include/sys/types.h
testCode.o: /usr/include/time.h /usr/include/endian.h
testCode.o: /usr/include/bits/endian.h /usr/include/sys/select.h
testCode.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
testCode.o: /usr/include/sys/sysmacros.h /usr/include/alloca.h
testCode.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/new.h
testCode.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/new
testCode.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/exception
testCode.o: /usr/include/g++/stl_iterator.h /usr/include/g++/stl_construct.h
testCode.o: /usr/include/g++/stl_tempbuf.h /usr/include/g++/stl_algo.h
testCode.o: /usr/include/g++/stl_heap.h /usr/include/g++/vector
testCode.o: /usr/include/g++/stl_alloc.h /usr/include/assert.h
testCode.o: /usr/include/pthread.h /usr/include/sched.h
testCode.o: /usr/include/bits/sched.h /usr/include/signal.h
testCode.o: /usr/include/bits/pthreadtypes.h /usr/include/bits/sigthread.h
testCode.o: /usr/include/g++/stl_uninitialized.h
testCode.o: /usr/include/g++/stl_vector.h /usr/include/g++/stl_bvector.h
testCode.o: SpFile.h SpPath.h /usr/include/g++/string
testCode.o: /usr/include/g++/std/bastring.h /usr/include/g++/cstddef
testCode.o: /usr/include/g++/std/straits.h /usr/include/g++/cctype
testCode.o: /usr/include/ctype.h /usr/include/g++/cstring
testCode.o: /usr/include/g++/alloc.h /usr/include/g++/iterator
testCode.o: /usr/include/g++/cassert /usr/include/g++/std/bastring.cc
testCode.o: SpTime.h SpSize.h SpUid.h SpGid.h SpFsObject.h
testCode.o: /usr/include/sys/stat.h /usr/include/bits/stat.h SpImage.h
testCode.o: /usr/include/g++/list /usr/include/g++/stl_list.h SpImageDim.h
testCode.o: SpImageFormat.h SpLibLoader.h /usr/include/dlfcn.h
testCode.o: /usr/include/bits/dlfcn.h SpDir.h /usr/include/g++/map
testCode.o: /usr/include/g++/stl_tree.h /usr/include/g++/stl_function.h
testCode.o: /usr/include/g++/stl_map.h /usr/include/g++/stl_multimap.h
testCode.o: SpTester.h SpDirMon.h SpImageSequence.h /usr/include/g++/set
testCode.o: /usr/include/g++/stl_set.h /usr/include/g++/stl_multiset.h
SpDirMon.o: SpDirMon.h SpDir.h /usr/include/g++/vector
SpDirMon.o: /usr/include/g++/stl_algobase.h /usr/include/g++/stl_config.h
SpDirMon.o: /usr/include/_G_config.h /usr/include/bits/types.h
SpDirMon.o: /usr/include/features.h /usr/include/sys/cdefs.h
SpDirMon.o: /usr/include/gnu/stubs.h
SpDirMon.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/stddef.h
SpDirMon.o: /usr/include/g++/stl_relops.h /usr/include/g++/stl_pair.h
SpDirMon.o: /usr/include/g++/type_traits.h /usr/include/string.h
SpDirMon.o: /usr/include/limits.h /usr/include/bits/posix1_lim.h
SpDirMon.o: /usr/include/bits/local_lim.h /usr/include/linux/limits.h
SpDirMon.o: /usr/include/bits/posix2_lim.h /usr/include/stdlib.h
SpDirMon.o: /usr/include/sys/types.h /usr/include/time.h
SpDirMon.o: /usr/include/endian.h /usr/include/bits/endian.h
SpDirMon.o: /usr/include/sys/select.h /usr/include/bits/select.h
SpDirMon.o: /usr/include/bits/sigset.h /usr/include/sys/sysmacros.h
SpDirMon.o: /usr/include/alloca.h
SpDirMon.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/new.h
SpDirMon.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/new
SpDirMon.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/exception
SpDirMon.o: /usr/include/g++/iostream.h /usr/include/g++/streambuf.h
SpDirMon.o: /usr/include/libio.h
SpDirMon.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/stdarg.h
SpDirMon.o: /usr/include/g++/stl_iterator.h /usr/include/g++/stl_alloc.h
SpDirMon.o: /usr/include/assert.h /usr/include/pthread.h /usr/include/sched.h
SpDirMon.o: /usr/include/bits/sched.h /usr/include/signal.h
SpDirMon.o: /usr/include/bits/pthreadtypes.h /usr/include/bits/sigthread.h
SpDirMon.o: /usr/include/g++/stl_construct.h
SpDirMon.o: /usr/include/g++/stl_uninitialized.h
SpDirMon.o: /usr/include/g++/stl_vector.h /usr/include/g++/stl_bvector.h
SpDirMon.o: /usr/include/g++/map /usr/include/g++/stl_tree.h
SpDirMon.o: /usr/include/g++/stl_function.h /usr/include/g++/stl_map.h
SpDirMon.o: /usr/include/g++/stl_multimap.h SpFsObject.h
SpDirMon.o: /usr/include/sys/stat.h /usr/include/bits/stat.h SpTime.h
SpDirMon.o: /usr/include/g++/string /usr/include/g++/std/bastring.h
SpDirMon.o: /usr/include/g++/cstddef /usr/include/g++/std/straits.h
SpDirMon.o: /usr/include/g++/cctype /usr/include/ctype.h
SpDirMon.o: /usr/include/g++/cstring /usr/include/g++/alloc.h
SpDirMon.o: /usr/include/g++/iterator /usr/include/g++/cassert
SpDirMon.o: /usr/include/g++/std/bastring.cc SpPath.h SpUid.h SpGid.h
SpDirMon.o: SpSize.h SpImage.h /usr/include/g++/list
SpDirMon.o: /usr/include/g++/stl_list.h SpFile.h SpImageDim.h SpImageFormat.h
SpDirMon.o: SpLibLoader.h /usr/include/dlfcn.h /usr/include/bits/dlfcn.h
SpDirMon.o: SpDirMonFam.h /usr/local/include/fam.h
SpGid.o: /usr/include/pwd.h /usr/include/features.h /usr/include/sys/cdefs.h
SpGid.o: /usr/include/gnu/stubs.h /usr/include/bits/types.h
SpGid.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/stddef.h
SpGid.o: /usr/include/stdio.h /usr/include/unistd.h
SpGid.o: /usr/include/bits/posix_opt.h /usr/include/bits/confname.h
SpGid.o: /usr/include/getopt.h /usr/include/grp.h SpGid.h
SpGid.o: /usr/include/sys/types.h /usr/include/time.h /usr/include/endian.h
SpGid.o: /usr/include/bits/endian.h /usr/include/sys/select.h
SpGid.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
SpGid.o: /usr/include/sys/sysmacros.h /usr/include/g++/string
SpGid.o: /usr/include/g++/std/bastring.h /usr/include/g++/cstddef
SpGid.o: /usr/include/g++/std/straits.h /usr/include/g++/cctype
SpGid.o: /usr/include/ctype.h /usr/include/g++/cstring /usr/include/string.h
SpGid.o: /usr/include/g++/alloc.h /usr/include/g++/iterator
SpGid.o: /usr/include/g++/stl_config.h /usr/include/_G_config.h
SpGid.o: /usr/include/g++/stl_relops.h /usr/include/g++/iostream.h
SpGid.o: /usr/include/g++/streambuf.h /usr/include/libio.h
SpGid.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/stdarg.h
SpGid.o: /usr/include/g++/stl_iterator.h /usr/include/g++/cassert
SpGid.o: /usr/include/assert.h /usr/include/g++/std/bastring.cc
SpImageSequence.o: /usr/include/stdio.h SpImageSequence.h
SpImageSequence.o: /usr/include/g++/set /usr/include/g++/stl_set.h
SpImageSequence.o: /usr/include/g++/stl_multiset.h SpImage.h
SpImageSequence.o: /usr/include/g++/list /usr/include/g++/stl_algobase.h
SpImageSequence.o: /usr/include/g++/stl_config.h /usr/include/_G_config.h
SpImageSequence.o: /usr/include/bits/types.h /usr/include/features.h
SpImageSequence.o: /usr/include/sys/cdefs.h /usr/include/gnu/stubs.h
SpImageSequence.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/stddef.h
SpImageSequence.o: /usr/include/g++/stl_relops.h /usr/include/g++/stl_pair.h
SpImageSequence.o: /usr/include/g++/type_traits.h /usr/include/string.h
SpImageSequence.o: /usr/include/limits.h /usr/include/bits/posix1_lim.h
SpImageSequence.o: /usr/include/bits/local_lim.h /usr/include/linux/limits.h
SpImageSequence.o: /usr/include/bits/posix2_lim.h /usr/include/stdlib.h
SpImageSequence.o: /usr/include/sys/types.h /usr/include/time.h
SpImageSequence.o: /usr/include/endian.h /usr/include/bits/endian.h
SpImageSequence.o: /usr/include/sys/select.h /usr/include/bits/select.h
SpImageSequence.o: /usr/include/bits/sigset.h /usr/include/sys/sysmacros.h
SpImageSequence.o: /usr/include/alloca.h
SpImageSequence.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/new.h
SpImageSequence.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/new
SpImageSequence.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/exception
SpImageSequence.o: /usr/include/g++/iostream.h /usr/include/g++/streambuf.h
SpImageSequence.o: /usr/include/libio.h
SpImageSequence.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/stdarg.h
SpImageSequence.o: /usr/include/g++/stl_iterator.h
SpImageSequence.o: /usr/include/g++/stl_alloc.h /usr/include/assert.h
SpImageSequence.o: /usr/include/pthread.h /usr/include/sched.h
SpImageSequence.o: /usr/include/bits/sched.h /usr/include/signal.h
SpImageSequence.o: /usr/include/bits/pthreadtypes.h
SpImageSequence.o: /usr/include/bits/sigthread.h
SpImageSequence.o: /usr/include/g++/stl_construct.h
SpImageSequence.o: /usr/include/g++/stl_uninitialized.h
SpImageSequence.o: /usr/include/g++/stl_list.h SpFile.h SpPath.h
SpImageSequence.o: /usr/include/g++/string /usr/include/g++/std/bastring.h
SpImageSequence.o: /usr/include/g++/cstddef /usr/include/g++/std/straits.h
SpImageSequence.o: /usr/include/g++/cctype /usr/include/ctype.h
SpImageSequence.o: /usr/include/g++/cstring /usr/include/g++/alloc.h
SpImageSequence.o: /usr/include/g++/iterator /usr/include/g++/cassert
SpImageSequence.o: /usr/include/g++/std/bastring.cc SpTime.h SpSize.h SpUid.h
SpImageSequence.o: SpGid.h SpFsObject.h /usr/include/sys/stat.h
SpImageSequence.o: /usr/include/bits/stat.h SpImageDim.h SpImageFormat.h
SpImageSequence.o: SpLibLoader.h /usr/include/dlfcn.h
SpImageSequence.o: /usr/include/bits/dlfcn.h
SpTester.o: /usr/include/g++/string /usr/include/g++/std/bastring.h
SpTester.o: /usr/include/g++/cstddef
SpTester.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/stddef.h
SpTester.o: /usr/include/g++/std/straits.h /usr/include/g++/cctype
SpTester.o: /usr/include/ctype.h /usr/include/features.h
SpTester.o: /usr/include/sys/cdefs.h /usr/include/gnu/stubs.h
SpTester.o: /usr/include/bits/types.h /usr/include/endian.h
SpTester.o: /usr/include/bits/endian.h /usr/include/g++/cstring
SpTester.o: /usr/include/string.h /usr/include/g++/alloc.h
SpTester.o: /usr/include/g++/iterator /usr/include/g++/stl_config.h
SpTester.o: /usr/include/_G_config.h /usr/include/g++/stl_relops.h
SpTester.o: /usr/include/g++/iostream.h /usr/include/g++/streambuf.h
SpTester.o: /usr/include/libio.h
SpTester.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/stdarg.h
SpTester.o: /usr/include/g++/stl_iterator.h /usr/include/g++/cassert
SpTester.o: /usr/include/assert.h /usr/include/g++/std/bastring.cc
SpTester.o: /usr/include/stdio.h SpTester.h
SpDirMonFam.o: /usr/local/include/fam.h /usr/include/limits.h
SpDirMonFam.o: /usr/include/features.h /usr/include/sys/cdefs.h
SpDirMonFam.o: /usr/include/gnu/stubs.h /usr/include/bits/posix1_lim.h
SpDirMonFam.o: /usr/include/bits/local_lim.h /usr/include/linux/limits.h
SpDirMonFam.o: /usr/include/bits/posix2_lim.h SpDirMonFam.h SpDirMon.h
SpDirMonFam.o: SpDir.h /usr/include/g++/vector
SpDirMonFam.o: /usr/include/g++/stl_algobase.h /usr/include/g++/stl_config.h
SpDirMonFam.o: /usr/include/_G_config.h /usr/include/bits/types.h
SpDirMonFam.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/stddef.h
SpDirMonFam.o: /usr/include/g++/stl_relops.h /usr/include/g++/stl_pair.h
SpDirMonFam.o: /usr/include/g++/type_traits.h /usr/include/string.h
SpDirMonFam.o: /usr/include/stdlib.h /usr/include/sys/types.h
SpDirMonFam.o: /usr/include/time.h /usr/include/endian.h
SpDirMonFam.o: /usr/include/bits/endian.h /usr/include/sys/select.h
SpDirMonFam.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
SpDirMonFam.o: /usr/include/sys/sysmacros.h /usr/include/alloca.h
SpDirMonFam.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/new.h
SpDirMonFam.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/new
SpDirMonFam.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/exception
SpDirMonFam.o: /usr/include/g++/iostream.h /usr/include/g++/streambuf.h
SpDirMonFam.o: /usr/include/libio.h
SpDirMonFam.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/stdarg.h
SpDirMonFam.o: /usr/include/g++/stl_iterator.h /usr/include/g++/stl_alloc.h
SpDirMonFam.o: /usr/include/assert.h /usr/include/pthread.h
SpDirMonFam.o: /usr/include/sched.h /usr/include/bits/sched.h
SpDirMonFam.o: /usr/include/signal.h /usr/include/bits/pthreadtypes.h
SpDirMonFam.o: /usr/include/bits/sigthread.h /usr/include/g++/stl_construct.h
SpDirMonFam.o: /usr/include/g++/stl_uninitialized.h
SpDirMonFam.o: /usr/include/g++/stl_vector.h /usr/include/g++/stl_bvector.h
SpDirMonFam.o: /usr/include/g++/map /usr/include/g++/stl_tree.h
SpDirMonFam.o: /usr/include/g++/stl_function.h /usr/include/g++/stl_map.h
SpDirMonFam.o: /usr/include/g++/stl_multimap.h SpFsObject.h
SpDirMonFam.o: /usr/include/sys/stat.h /usr/include/bits/stat.h SpTime.h
SpDirMonFam.o: /usr/include/g++/string /usr/include/g++/std/bastring.h
SpDirMonFam.o: /usr/include/g++/cstddef /usr/include/g++/std/straits.h
SpDirMonFam.o: /usr/include/g++/cctype /usr/include/ctype.h
SpDirMonFam.o: /usr/include/g++/cstring /usr/include/g++/alloc.h
SpDirMonFam.o: /usr/include/g++/iterator /usr/include/g++/cassert
SpDirMonFam.o: /usr/include/g++/std/bastring.cc SpPath.h SpUid.h SpGid.h
SpDirMonFam.o: SpSize.h SpImage.h /usr/include/g++/list
SpDirMonFam.o: /usr/include/g++/stl_list.h SpFile.h SpImageDim.h
SpDirMonFam.o: SpImageFormat.h SpLibLoader.h /usr/include/dlfcn.h
SpDirMonFam.o: /usr/include/bits/dlfcn.h
SpImage.o: SpImage.h /usr/include/g++/list /usr/include/g++/stl_algobase.h
SpImage.o: /usr/include/g++/stl_config.h /usr/include/_G_config.h
SpImage.o: /usr/include/bits/types.h /usr/include/features.h
SpImage.o: /usr/include/sys/cdefs.h /usr/include/gnu/stubs.h
SpImage.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/stddef.h
SpImage.o: /usr/include/g++/stl_relops.h /usr/include/g++/stl_pair.h
SpImage.o: /usr/include/g++/type_traits.h /usr/include/string.h
SpImage.o: /usr/include/limits.h /usr/include/bits/posix1_lim.h
SpImage.o: /usr/include/bits/local_lim.h /usr/include/linux/limits.h
SpImage.o: /usr/include/bits/posix2_lim.h /usr/include/stdlib.h
SpImage.o: /usr/include/sys/types.h /usr/include/time.h /usr/include/endian.h
SpImage.o: /usr/include/bits/endian.h /usr/include/sys/select.h
SpImage.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
SpImage.o: /usr/include/sys/sysmacros.h /usr/include/alloca.h
SpImage.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/new.h
SpImage.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/new
SpImage.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/exception
SpImage.o: /usr/include/g++/iostream.h /usr/include/g++/streambuf.h
SpImage.o: /usr/include/libio.h
SpImage.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/stdarg.h
SpImage.o: /usr/include/g++/stl_iterator.h /usr/include/g++/stl_alloc.h
SpImage.o: /usr/include/assert.h /usr/include/pthread.h /usr/include/sched.h
SpImage.o: /usr/include/bits/sched.h /usr/include/signal.h
SpImage.o: /usr/include/bits/pthreadtypes.h /usr/include/bits/sigthread.h
SpImage.o: /usr/include/g++/stl_construct.h
SpImage.o: /usr/include/g++/stl_uninitialized.h /usr/include/g++/stl_list.h
SpImage.o: SpFile.h SpPath.h /usr/include/g++/string
SpImage.o: /usr/include/g++/std/bastring.h /usr/include/g++/cstddef
SpImage.o: /usr/include/g++/std/straits.h /usr/include/g++/cctype
SpImage.o: /usr/include/ctype.h /usr/include/g++/cstring
SpImage.o: /usr/include/g++/alloc.h /usr/include/g++/iterator
SpImage.o: /usr/include/g++/cassert /usr/include/g++/std/bastring.cc SpTime.h
SpImage.o: SpSize.h SpUid.h SpGid.h SpFsObject.h /usr/include/sys/stat.h
SpImage.o: /usr/include/bits/stat.h SpImageDim.h SpImageFormat.h
SpImage.o: SpLibLoader.h /usr/include/dlfcn.h /usr/include/bits/dlfcn.h
SpLibLoader.o: SpLibLoader.h /usr/include/g++/list
SpLibLoader.o: /usr/include/g++/stl_algobase.h /usr/include/g++/stl_config.h
SpLibLoader.o: /usr/include/_G_config.h /usr/include/bits/types.h
SpLibLoader.o: /usr/include/features.h /usr/include/sys/cdefs.h
SpLibLoader.o: /usr/include/gnu/stubs.h
SpLibLoader.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/stddef.h
SpLibLoader.o: /usr/include/g++/stl_relops.h /usr/include/g++/stl_pair.h
SpLibLoader.o: /usr/include/g++/type_traits.h /usr/include/string.h
SpLibLoader.o: /usr/include/limits.h /usr/include/bits/posix1_lim.h
SpLibLoader.o: /usr/include/bits/local_lim.h /usr/include/linux/limits.h
SpLibLoader.o: /usr/include/bits/posix2_lim.h /usr/include/stdlib.h
SpLibLoader.o: /usr/include/sys/types.h /usr/include/time.h
SpLibLoader.o: /usr/include/endian.h /usr/include/bits/endian.h
SpLibLoader.o: /usr/include/sys/select.h /usr/include/bits/select.h
SpLibLoader.o: /usr/include/bits/sigset.h /usr/include/sys/sysmacros.h
SpLibLoader.o: /usr/include/alloca.h
SpLibLoader.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/new.h
SpLibLoader.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/new
SpLibLoader.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/exception
SpLibLoader.o: /usr/include/g++/iostream.h /usr/include/g++/streambuf.h
SpLibLoader.o: /usr/include/libio.h
SpLibLoader.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/stdarg.h
SpLibLoader.o: /usr/include/g++/stl_iterator.h /usr/include/g++/stl_alloc.h
SpLibLoader.o: /usr/include/assert.h /usr/include/pthread.h
SpLibLoader.o: /usr/include/sched.h /usr/include/bits/sched.h
SpLibLoader.o: /usr/include/signal.h /usr/include/bits/pthreadtypes.h
SpLibLoader.o: /usr/include/bits/sigthread.h /usr/include/g++/stl_construct.h
SpLibLoader.o: /usr/include/g++/stl_uninitialized.h
SpLibLoader.o: /usr/include/g++/stl_list.h /usr/include/g++/string
SpLibLoader.o: /usr/include/g++/std/bastring.h /usr/include/g++/cstddef
SpLibLoader.o: /usr/include/g++/std/straits.h /usr/include/g++/cctype
SpLibLoader.o: /usr/include/ctype.h /usr/include/g++/cstring
SpLibLoader.o: /usr/include/g++/alloc.h /usr/include/g++/iterator
SpLibLoader.o: /usr/include/g++/cassert /usr/include/g++/std/bastring.cc
SpLibLoader.o: /usr/include/dlfcn.h /usr/include/bits/dlfcn.h
SpTime.o: /usr/include/g++/string /usr/include/g++/std/bastring.h
SpTime.o: /usr/include/g++/cstddef
SpTime.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/stddef.h
SpTime.o: /usr/include/g++/std/straits.h /usr/include/g++/cctype
SpTime.o: /usr/include/ctype.h /usr/include/features.h
SpTime.o: /usr/include/sys/cdefs.h /usr/include/gnu/stubs.h
SpTime.o: /usr/include/bits/types.h /usr/include/endian.h
SpTime.o: /usr/include/bits/endian.h /usr/include/g++/cstring
SpTime.o: /usr/include/string.h /usr/include/g++/alloc.h
SpTime.o: /usr/include/g++/iterator /usr/include/g++/stl_config.h
SpTime.o: /usr/include/_G_config.h /usr/include/g++/stl_relops.h
SpTime.o: /usr/include/g++/iostream.h /usr/include/g++/streambuf.h
SpTime.o: /usr/include/libio.h
SpTime.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/stdarg.h
SpTime.o: /usr/include/g++/stl_iterator.h /usr/include/g++/cassert
SpTime.o: /usr/include/assert.h /usr/include/g++/std/bastring.cc
SpTime.o: /usr/include/g++/strstream /usr/include/g++/strstream.h
SpTime.o: /usr/include/g++/strfile.h /usr/include/g++/iomanip
SpTime.o: /usr/include/g++/iomanip.h /usr/include/unistd.h
SpTime.o: /usr/include/bits/posix_opt.h /usr/include/bits/confname.h
SpTime.o: /usr/include/getopt.h SpTime.h /usr/include/time.h
SpFile.o: /usr/include/unistd.h /usr/include/features.h
SpFile.o: /usr/include/sys/cdefs.h /usr/include/gnu/stubs.h
SpFile.o: /usr/include/bits/posix_opt.h /usr/include/bits/types.h
SpFile.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/stddef.h
SpFile.o: /usr/include/bits/confname.h /usr/include/getopt.h
SpFile.o: /usr/include/fcntl.h /usr/include/bits/fcntl.h
SpFile.o: /usr/include/sys/types.h /usr/include/time.h /usr/include/endian.h
SpFile.o: /usr/include/bits/endian.h /usr/include/sys/select.h
SpFile.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
SpFile.o: /usr/include/sys/sysmacros.h /usr/include/sys/stat.h
SpFile.o: /usr/include/bits/stat.h SpFile.h SpPath.h /usr/include/g++/string
SpFile.o: /usr/include/g++/std/bastring.h /usr/include/g++/cstddef
SpFile.o: /usr/include/g++/std/straits.h /usr/include/g++/cctype
SpFile.o: /usr/include/ctype.h /usr/include/g++/cstring /usr/include/string.h
SpFile.o: /usr/include/g++/alloc.h /usr/include/g++/iterator
SpFile.o: /usr/include/g++/stl_config.h /usr/include/_G_config.h
SpFile.o: /usr/include/g++/stl_relops.h /usr/include/g++/iostream.h
SpFile.o: /usr/include/g++/streambuf.h /usr/include/libio.h
SpFile.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/stdarg.h
SpFile.o: /usr/include/g++/stl_iterator.h /usr/include/g++/cassert
SpFile.o: /usr/include/assert.h /usr/include/g++/std/bastring.cc SpTime.h
SpFile.o: SpSize.h SpUid.h SpGid.h SpFsObject.h
SpImageDim.o: SpImageDim.h
SpPath.o: /usr/include/unistd.h /usr/include/features.h
SpPath.o: /usr/include/sys/cdefs.h /usr/include/gnu/stubs.h
SpPath.o: /usr/include/bits/posix_opt.h /usr/include/bits/types.h
SpPath.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/stddef.h
SpPath.o: /usr/include/bits/confname.h /usr/include/getopt.h SpPath.h
SpPath.o: /usr/include/g++/string /usr/include/g++/std/bastring.h
SpPath.o: /usr/include/g++/cstddef /usr/include/g++/std/straits.h
SpPath.o: /usr/include/g++/cctype /usr/include/ctype.h /usr/include/endian.h
SpPath.o: /usr/include/bits/endian.h /usr/include/g++/cstring
SpPath.o: /usr/include/string.h /usr/include/g++/alloc.h
SpPath.o: /usr/include/g++/iterator /usr/include/g++/stl_config.h
SpPath.o: /usr/include/_G_config.h /usr/include/g++/stl_relops.h
SpPath.o: /usr/include/g++/iostream.h /usr/include/g++/streambuf.h
SpPath.o: /usr/include/libio.h
SpPath.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/stdarg.h
SpPath.o: /usr/include/g++/stl_iterator.h /usr/include/g++/cassert
SpPath.o: /usr/include/assert.h /usr/include/g++/std/bastring.cc
SpUid.o: /usr/include/pwd.h /usr/include/features.h /usr/include/sys/cdefs.h
SpUid.o: /usr/include/gnu/stubs.h /usr/include/bits/types.h
SpUid.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/stddef.h
SpUid.o: /usr/include/stdio.h /usr/include/unistd.h
SpUid.o: /usr/include/bits/posix_opt.h /usr/include/bits/confname.h
SpUid.o: /usr/include/getopt.h SpUid.h /usr/include/sys/types.h
SpUid.o: /usr/include/time.h /usr/include/endian.h /usr/include/bits/endian.h
SpUid.o: /usr/include/sys/select.h /usr/include/bits/select.h
SpUid.o: /usr/include/bits/sigset.h /usr/include/sys/sysmacros.h
SpUid.o: /usr/include/g++/string /usr/include/g++/std/bastring.h
SpUid.o: /usr/include/g++/cstddef /usr/include/g++/std/straits.h
SpUid.o: /usr/include/g++/cctype /usr/include/ctype.h
SpUid.o: /usr/include/g++/cstring /usr/include/string.h
SpUid.o: /usr/include/g++/alloc.h /usr/include/g++/iterator
SpUid.o: /usr/include/g++/stl_config.h /usr/include/_G_config.h
SpUid.o: /usr/include/g++/stl_relops.h /usr/include/g++/iostream.h
SpUid.o: /usr/include/g++/streambuf.h /usr/include/libio.h
SpUid.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/stdarg.h
SpUid.o: /usr/include/g++/stl_iterator.h /usr/include/g++/cassert
SpUid.o: /usr/include/assert.h /usr/include/g++/std/bastring.cc

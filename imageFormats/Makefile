# $Id$

CC = g++
OPTION = -g
INCLUDE = -I..

SRCS = SpCINEONImage.C SpGIFImage.C SpPRMANZImage.C SpSGIImage.C \
       SpFITImage.C SpIFFImage.C SpPRTEXImage.C SpTIFFImage.C 

SO_OBJECTS = SpTIFFImage.so SpFITImage.so SpPRMANZImage.so SpSGIImage.so\
		  SpGIFImage.so SpCINEONImage.so SpIFFImage.so SpPRTEXImage.so
		  
all: $(SO_OBJECTS)
	
clean:
	rm -fr *.o *.so
	
depend:
	makedepend -I/usr/include/g++ -I.. -- $(OPTION) -- $(SRCS)

%.o : %.C
	$(CC) -fPIC $(OPTION) -c $< $(INCLUDE) -o $@

# Make the shared objects
%.so : %.o
	$(CC) -shared -o $@ $<

# DO NOT DELETE

SpCINEONImage.o: SpCINEONImage.h ../SpImage.h /usr/include/g++/list
SpCINEONImage.o: /usr/include/g++/stl_algobase.h
SpCINEONImage.o: /usr/include/g++/stl_config.h /usr/include/_G_config.h
SpCINEONImage.o: /usr/include/bits/types.h /usr/include/features.h
SpCINEONImage.o: /usr/include/sys/cdefs.h /usr/include/gnu/stubs.h
SpCINEONImage.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/stddef.h
SpCINEONImage.o: /usr/include/g++/stl_relops.h /usr/include/g++/stl_pair.h
SpCINEONImage.o: /usr/include/g++/type_traits.h /usr/include/string.h
SpCINEONImage.o: /usr/include/limits.h /usr/include/bits/posix1_lim.h
SpCINEONImage.o: /usr/include/bits/local_lim.h /usr/include/linux/limits.h
SpCINEONImage.o: /usr/include/bits/posix2_lim.h /usr/include/stdlib.h
SpCINEONImage.o: /usr/include/sys/types.h /usr/include/time.h
SpCINEONImage.o: /usr/include/endian.h /usr/include/bits/endian.h
SpCINEONImage.o: /usr/include/sys/select.h /usr/include/bits/select.h
SpCINEONImage.o: /usr/include/bits/sigset.h /usr/include/sys/sysmacros.h
SpCINEONImage.o: /usr/include/alloca.h
SpCINEONImage.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/new.h
SpCINEONImage.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/new
SpCINEONImage.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/exception
SpCINEONImage.o: /usr/include/g++/iostream.h /usr/include/g++/streambuf.h
SpCINEONImage.o: /usr/include/libio.h
SpCINEONImage.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/stdarg.h
SpCINEONImage.o: /usr/include/g++/stl_iterator.h /usr/include/g++/stl_alloc.h
SpCINEONImage.o: /usr/include/assert.h /usr/include/pthread.h
SpCINEONImage.o: /usr/include/sched.h /usr/include/bits/sched.h
SpCINEONImage.o: /usr/include/signal.h /usr/include/bits/pthreadtypes.h
SpCINEONImage.o: /usr/include/bits/sigthread.h
SpCINEONImage.o: /usr/include/g++/stl_construct.h
SpCINEONImage.o: /usr/include/g++/stl_uninitialized.h
SpCINEONImage.o: /usr/include/g++/stl_list.h ../SpFile.h ../SpPath.h
SpCINEONImage.o: /usr/include/g++/string /usr/include/g++/std/bastring.h
SpCINEONImage.o: /usr/include/g++/cstddef /usr/include/g++/std/straits.h
SpCINEONImage.o: /usr/include/g++/cctype /usr/include/ctype.h
SpCINEONImage.o: /usr/include/g++/cstring /usr/include/g++/alloc.h
SpCINEONImage.o: /usr/include/g++/iterator /usr/include/g++/cassert
SpCINEONImage.o: /usr/include/g++/std/bastring.cc ../SpTime.h ../SpSize.h
SpCINEONImage.o: ../SpUid.h ../SpGid.h ../SpFsObject.h
SpCINEONImage.o: /usr/include/sys/stat.h /usr/include/bits/stat.h
SpCINEONImage.o: ../SpFsObjectHandle.h ../SpImageDim.h ../SpImageFormat.h
SpCINEONImage.o: ../SpLibLoader.h /usr/include/dlfcn.h
SpCINEONImage.o: /usr/include/bits/dlfcn.h
SpGIFImage.o: SpGIFImage.h ../SpImage.h /usr/include/g++/list
SpGIFImage.o: /usr/include/g++/stl_algobase.h /usr/include/g++/stl_config.h
SpGIFImage.o: /usr/include/_G_config.h /usr/include/bits/types.h
SpGIFImage.o: /usr/include/features.h /usr/include/sys/cdefs.h
SpGIFImage.o: /usr/include/gnu/stubs.h
SpGIFImage.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/stddef.h
SpGIFImage.o: /usr/include/g++/stl_relops.h /usr/include/g++/stl_pair.h
SpGIFImage.o: /usr/include/g++/type_traits.h /usr/include/string.h
SpGIFImage.o: /usr/include/limits.h /usr/include/bits/posix1_lim.h
SpGIFImage.o: /usr/include/bits/local_lim.h /usr/include/linux/limits.h
SpGIFImage.o: /usr/include/bits/posix2_lim.h /usr/include/stdlib.h
SpGIFImage.o: /usr/include/sys/types.h /usr/include/time.h
SpGIFImage.o: /usr/include/endian.h /usr/include/bits/endian.h
SpGIFImage.o: /usr/include/sys/select.h /usr/include/bits/select.h
SpGIFImage.o: /usr/include/bits/sigset.h /usr/include/sys/sysmacros.h
SpGIFImage.o: /usr/include/alloca.h
SpGIFImage.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/new.h
SpGIFImage.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/new
SpGIFImage.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/exception
SpGIFImage.o: /usr/include/g++/iostream.h /usr/include/g++/streambuf.h
SpGIFImage.o: /usr/include/libio.h
SpGIFImage.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/stdarg.h
SpGIFImage.o: /usr/include/g++/stl_iterator.h /usr/include/g++/stl_alloc.h
SpGIFImage.o: /usr/include/assert.h /usr/include/pthread.h
SpGIFImage.o: /usr/include/sched.h /usr/include/bits/sched.h
SpGIFImage.o: /usr/include/signal.h /usr/include/bits/pthreadtypes.h
SpGIFImage.o: /usr/include/bits/sigthread.h /usr/include/g++/stl_construct.h
SpGIFImage.o: /usr/include/g++/stl_uninitialized.h
SpGIFImage.o: /usr/include/g++/stl_list.h ../SpFile.h ../SpPath.h
SpGIFImage.o: /usr/include/g++/string /usr/include/g++/std/bastring.h
SpGIFImage.o: /usr/include/g++/cstddef /usr/include/g++/std/straits.h
SpGIFImage.o: /usr/include/g++/cctype /usr/include/ctype.h
SpGIFImage.o: /usr/include/g++/cstring /usr/include/g++/alloc.h
SpGIFImage.o: /usr/include/g++/iterator /usr/include/g++/cassert
SpGIFImage.o: /usr/include/g++/std/bastring.cc ../SpTime.h ../SpSize.h
SpGIFImage.o: ../SpUid.h ../SpGid.h ../SpFsObject.h /usr/include/sys/stat.h
SpGIFImage.o: /usr/include/bits/stat.h ../SpFsObjectHandle.h ../SpImageDim.h
SpGIFImage.o: ../SpImageFormat.h ../SpLibLoader.h /usr/include/dlfcn.h
SpGIFImage.o: /usr/include/bits/dlfcn.h
SpPRMANZImage.o: SpPRMANZImage.h ../SpImage.h /usr/include/g++/list
SpPRMANZImage.o: /usr/include/g++/stl_algobase.h
SpPRMANZImage.o: /usr/include/g++/stl_config.h /usr/include/_G_config.h
SpPRMANZImage.o: /usr/include/bits/types.h /usr/include/features.h
SpPRMANZImage.o: /usr/include/sys/cdefs.h /usr/include/gnu/stubs.h
SpPRMANZImage.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/stddef.h
SpPRMANZImage.o: /usr/include/g++/stl_relops.h /usr/include/g++/stl_pair.h
SpPRMANZImage.o: /usr/include/g++/type_traits.h /usr/include/string.h
SpPRMANZImage.o: /usr/include/limits.h /usr/include/bits/posix1_lim.h
SpPRMANZImage.o: /usr/include/bits/local_lim.h /usr/include/linux/limits.h
SpPRMANZImage.o: /usr/include/bits/posix2_lim.h /usr/include/stdlib.h
SpPRMANZImage.o: /usr/include/sys/types.h /usr/include/time.h
SpPRMANZImage.o: /usr/include/endian.h /usr/include/bits/endian.h
SpPRMANZImage.o: /usr/include/sys/select.h /usr/include/bits/select.h
SpPRMANZImage.o: /usr/include/bits/sigset.h /usr/include/sys/sysmacros.h
SpPRMANZImage.o: /usr/include/alloca.h
SpPRMANZImage.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/new.h
SpPRMANZImage.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/new
SpPRMANZImage.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/exception
SpPRMANZImage.o: /usr/include/g++/iostream.h /usr/include/g++/streambuf.h
SpPRMANZImage.o: /usr/include/libio.h
SpPRMANZImage.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/stdarg.h
SpPRMANZImage.o: /usr/include/g++/stl_iterator.h /usr/include/g++/stl_alloc.h
SpPRMANZImage.o: /usr/include/assert.h /usr/include/pthread.h
SpPRMANZImage.o: /usr/include/sched.h /usr/include/bits/sched.h
SpPRMANZImage.o: /usr/include/signal.h /usr/include/bits/pthreadtypes.h
SpPRMANZImage.o: /usr/include/bits/sigthread.h
SpPRMANZImage.o: /usr/include/g++/stl_construct.h
SpPRMANZImage.o: /usr/include/g++/stl_uninitialized.h
SpPRMANZImage.o: /usr/include/g++/stl_list.h ../SpFile.h ../SpPath.h
SpPRMANZImage.o: /usr/include/g++/string /usr/include/g++/std/bastring.h
SpPRMANZImage.o: /usr/include/g++/cstddef /usr/include/g++/std/straits.h
SpPRMANZImage.o: /usr/include/g++/cctype /usr/include/ctype.h
SpPRMANZImage.o: /usr/include/g++/cstring /usr/include/g++/alloc.h
SpPRMANZImage.o: /usr/include/g++/iterator /usr/include/g++/cassert
SpPRMANZImage.o: /usr/include/g++/std/bastring.cc ../SpTime.h ../SpSize.h
SpPRMANZImage.o: ../SpUid.h ../SpGid.h ../SpFsObject.h
SpPRMANZImage.o: /usr/include/sys/stat.h /usr/include/bits/stat.h
SpPRMANZImage.o: ../SpFsObjectHandle.h ../SpImageDim.h ../SpImageFormat.h
SpPRMANZImage.o: ../SpLibLoader.h /usr/include/dlfcn.h
SpPRMANZImage.o: /usr/include/bits/dlfcn.h
SpSGIImage.o: SpSGIImage.h ../SpImage.h /usr/include/g++/list
SpSGIImage.o: /usr/include/g++/stl_algobase.h /usr/include/g++/stl_config.h
SpSGIImage.o: /usr/include/_G_config.h /usr/include/bits/types.h
SpSGIImage.o: /usr/include/features.h /usr/include/sys/cdefs.h
SpSGIImage.o: /usr/include/gnu/stubs.h
SpSGIImage.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/stddef.h
SpSGIImage.o: /usr/include/g++/stl_relops.h /usr/include/g++/stl_pair.h
SpSGIImage.o: /usr/include/g++/type_traits.h /usr/include/string.h
SpSGIImage.o: /usr/include/limits.h /usr/include/bits/posix1_lim.h
SpSGIImage.o: /usr/include/bits/local_lim.h /usr/include/linux/limits.h
SpSGIImage.o: /usr/include/bits/posix2_lim.h /usr/include/stdlib.h
SpSGIImage.o: /usr/include/sys/types.h /usr/include/time.h
SpSGIImage.o: /usr/include/endian.h /usr/include/bits/endian.h
SpSGIImage.o: /usr/include/sys/select.h /usr/include/bits/select.h
SpSGIImage.o: /usr/include/bits/sigset.h /usr/include/sys/sysmacros.h
SpSGIImage.o: /usr/include/alloca.h
SpSGIImage.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/new.h
SpSGIImage.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/new
SpSGIImage.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/exception
SpSGIImage.o: /usr/include/g++/iostream.h /usr/include/g++/streambuf.h
SpSGIImage.o: /usr/include/libio.h
SpSGIImage.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/stdarg.h
SpSGIImage.o: /usr/include/g++/stl_iterator.h /usr/include/g++/stl_alloc.h
SpSGIImage.o: /usr/include/assert.h /usr/include/pthread.h
SpSGIImage.o: /usr/include/sched.h /usr/include/bits/sched.h
SpSGIImage.o: /usr/include/signal.h /usr/include/bits/pthreadtypes.h
SpSGIImage.o: /usr/include/bits/sigthread.h /usr/include/g++/stl_construct.h
SpSGIImage.o: /usr/include/g++/stl_uninitialized.h
SpSGIImage.o: /usr/include/g++/stl_list.h ../SpFile.h ../SpPath.h
SpSGIImage.o: /usr/include/g++/string /usr/include/g++/std/bastring.h
SpSGIImage.o: /usr/include/g++/cstddef /usr/include/g++/std/straits.h
SpSGIImage.o: /usr/include/g++/cctype /usr/include/ctype.h
SpSGIImage.o: /usr/include/g++/cstring /usr/include/g++/alloc.h
SpSGIImage.o: /usr/include/g++/iterator /usr/include/g++/cassert
SpSGIImage.o: /usr/include/g++/std/bastring.cc ../SpTime.h ../SpSize.h
SpSGIImage.o: ../SpUid.h ../SpGid.h ../SpFsObject.h /usr/include/sys/stat.h
SpSGIImage.o: /usr/include/bits/stat.h ../SpFsObjectHandle.h ../SpImageDim.h
SpSGIImage.o: ../SpImageFormat.h ../SpLibLoader.h /usr/include/dlfcn.h
SpSGIImage.o: /usr/include/bits/dlfcn.h
SpFITImage.o: SpFITImage.h ../SpImage.h /usr/include/g++/list
SpFITImage.o: /usr/include/g++/stl_algobase.h /usr/include/g++/stl_config.h
SpFITImage.o: /usr/include/_G_config.h /usr/include/bits/types.h
SpFITImage.o: /usr/include/features.h /usr/include/sys/cdefs.h
SpFITImage.o: /usr/include/gnu/stubs.h
SpFITImage.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/stddef.h
SpFITImage.o: /usr/include/g++/stl_relops.h /usr/include/g++/stl_pair.h
SpFITImage.o: /usr/include/g++/type_traits.h /usr/include/string.h
SpFITImage.o: /usr/include/limits.h /usr/include/bits/posix1_lim.h
SpFITImage.o: /usr/include/bits/local_lim.h /usr/include/linux/limits.h
SpFITImage.o: /usr/include/bits/posix2_lim.h /usr/include/stdlib.h
SpFITImage.o: /usr/include/sys/types.h /usr/include/time.h
SpFITImage.o: /usr/include/endian.h /usr/include/bits/endian.h
SpFITImage.o: /usr/include/sys/select.h /usr/include/bits/select.h
SpFITImage.o: /usr/include/bits/sigset.h /usr/include/sys/sysmacros.h
SpFITImage.o: /usr/include/alloca.h
SpFITImage.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/new.h
SpFITImage.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/new
SpFITImage.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/exception
SpFITImage.o: /usr/include/g++/iostream.h /usr/include/g++/streambuf.h
SpFITImage.o: /usr/include/libio.h
SpFITImage.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/stdarg.h
SpFITImage.o: /usr/include/g++/stl_iterator.h /usr/include/g++/stl_alloc.h
SpFITImage.o: /usr/include/assert.h /usr/include/pthread.h
SpFITImage.o: /usr/include/sched.h /usr/include/bits/sched.h
SpFITImage.o: /usr/include/signal.h /usr/include/bits/pthreadtypes.h
SpFITImage.o: /usr/include/bits/sigthread.h /usr/include/g++/stl_construct.h
SpFITImage.o: /usr/include/g++/stl_uninitialized.h
SpFITImage.o: /usr/include/g++/stl_list.h ../SpFile.h ../SpPath.h
SpFITImage.o: /usr/include/g++/string /usr/include/g++/std/bastring.h
SpFITImage.o: /usr/include/g++/cstddef /usr/include/g++/std/straits.h
SpFITImage.o: /usr/include/g++/cctype /usr/include/ctype.h
SpFITImage.o: /usr/include/g++/cstring /usr/include/g++/alloc.h
SpFITImage.o: /usr/include/g++/iterator /usr/include/g++/cassert
SpFITImage.o: /usr/include/g++/std/bastring.cc ../SpTime.h ../SpSize.h
SpFITImage.o: ../SpUid.h ../SpGid.h ../SpFsObject.h /usr/include/sys/stat.h
SpFITImage.o: /usr/include/bits/stat.h ../SpFsObjectHandle.h ../SpImageDim.h
SpFITImage.o: ../SpImageFormat.h ../SpLibLoader.h /usr/include/dlfcn.h
SpFITImage.o: /usr/include/bits/dlfcn.h /usr/include/g++/stream.h
SpIFFImage.o: SpIFFImage.h ../SpImage.h /usr/include/g++/list
SpIFFImage.o: /usr/include/g++/stl_algobase.h /usr/include/g++/stl_config.h
SpIFFImage.o: /usr/include/_G_config.h /usr/include/bits/types.h
SpIFFImage.o: /usr/include/features.h /usr/include/sys/cdefs.h
SpIFFImage.o: /usr/include/gnu/stubs.h
SpIFFImage.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/stddef.h
SpIFFImage.o: /usr/include/g++/stl_relops.h /usr/include/g++/stl_pair.h
SpIFFImage.o: /usr/include/g++/type_traits.h /usr/include/string.h
SpIFFImage.o: /usr/include/limits.h /usr/include/bits/posix1_lim.h
SpIFFImage.o: /usr/include/bits/local_lim.h /usr/include/linux/limits.h
SpIFFImage.o: /usr/include/bits/posix2_lim.h /usr/include/stdlib.h
SpIFFImage.o: /usr/include/sys/types.h /usr/include/time.h
SpIFFImage.o: /usr/include/endian.h /usr/include/bits/endian.h
SpIFFImage.o: /usr/include/sys/select.h /usr/include/bits/select.h
SpIFFImage.o: /usr/include/bits/sigset.h /usr/include/sys/sysmacros.h
SpIFFImage.o: /usr/include/alloca.h
SpIFFImage.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/new.h
SpIFFImage.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/new
SpIFFImage.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/exception
SpIFFImage.o: /usr/include/g++/iostream.h /usr/include/g++/streambuf.h
SpIFFImage.o: /usr/include/libio.h
SpIFFImage.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/stdarg.h
SpIFFImage.o: /usr/include/g++/stl_iterator.h /usr/include/g++/stl_alloc.h
SpIFFImage.o: /usr/include/assert.h /usr/include/pthread.h
SpIFFImage.o: /usr/include/sched.h /usr/include/bits/sched.h
SpIFFImage.o: /usr/include/signal.h /usr/include/bits/pthreadtypes.h
SpIFFImage.o: /usr/include/bits/sigthread.h /usr/include/g++/stl_construct.h
SpIFFImage.o: /usr/include/g++/stl_uninitialized.h
SpIFFImage.o: /usr/include/g++/stl_list.h ../SpFile.h ../SpPath.h
SpIFFImage.o: /usr/include/g++/string /usr/include/g++/std/bastring.h
SpIFFImage.o: /usr/include/g++/cstddef /usr/include/g++/std/straits.h
SpIFFImage.o: /usr/include/g++/cctype /usr/include/ctype.h
SpIFFImage.o: /usr/include/g++/cstring /usr/include/g++/alloc.h
SpIFFImage.o: /usr/include/g++/iterator /usr/include/g++/cassert
SpIFFImage.o: /usr/include/g++/std/bastring.cc ../SpTime.h ../SpSize.h
SpIFFImage.o: ../SpUid.h ../SpGid.h ../SpFsObject.h /usr/include/sys/stat.h
SpIFFImage.o: /usr/include/bits/stat.h ../SpFsObjectHandle.h ../SpImageDim.h
SpIFFImage.o: ../SpImageFormat.h ../SpLibLoader.h /usr/include/dlfcn.h
SpIFFImage.o: /usr/include/bits/dlfcn.h
SpPRTEXImage.o: /usr/include/math.h /usr/include/features.h
SpPRTEXImage.o: /usr/include/sys/cdefs.h /usr/include/gnu/stubs.h
SpPRTEXImage.o: /usr/include/bits/huge_val.h /usr/include/bits/mathdef.h
SpPRTEXImage.o: /usr/include/bits/mathcalls.h
SpPRTEXImage.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/float.h
SpPRTEXImage.o: SpPRTEXImage.h ../SpImage.h /usr/include/g++/list
SpPRTEXImage.o: /usr/include/g++/stl_algobase.h /usr/include/g++/stl_config.h
SpPRTEXImage.o: /usr/include/_G_config.h /usr/include/bits/types.h
SpPRTEXImage.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/stddef.h
SpPRTEXImage.o: /usr/include/g++/stl_relops.h /usr/include/g++/stl_pair.h
SpPRTEXImage.o: /usr/include/g++/type_traits.h /usr/include/string.h
SpPRTEXImage.o: /usr/include/limits.h /usr/include/bits/posix1_lim.h
SpPRTEXImage.o: /usr/include/bits/local_lim.h /usr/include/linux/limits.h
SpPRTEXImage.o: /usr/include/bits/posix2_lim.h /usr/include/stdlib.h
SpPRTEXImage.o: /usr/include/sys/types.h /usr/include/time.h
SpPRTEXImage.o: /usr/include/endian.h /usr/include/bits/endian.h
SpPRTEXImage.o: /usr/include/sys/select.h /usr/include/bits/select.h
SpPRTEXImage.o: /usr/include/bits/sigset.h /usr/include/sys/sysmacros.h
SpPRTEXImage.o: /usr/include/alloca.h
SpPRTEXImage.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/new.h
SpPRTEXImage.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/new
SpPRTEXImage.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/exception
SpPRTEXImage.o: /usr/include/g++/iostream.h /usr/include/g++/streambuf.h
SpPRTEXImage.o: /usr/include/libio.h
SpPRTEXImage.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/stdarg.h
SpPRTEXImage.o: /usr/include/g++/stl_iterator.h /usr/include/g++/stl_alloc.h
SpPRTEXImage.o: /usr/include/assert.h /usr/include/pthread.h
SpPRTEXImage.o: /usr/include/sched.h /usr/include/bits/sched.h
SpPRTEXImage.o: /usr/include/signal.h /usr/include/bits/pthreadtypes.h
SpPRTEXImage.o: /usr/include/bits/sigthread.h
SpPRTEXImage.o: /usr/include/g++/stl_construct.h
SpPRTEXImage.o: /usr/include/g++/stl_uninitialized.h
SpPRTEXImage.o: /usr/include/g++/stl_list.h ../SpFile.h ../SpPath.h
SpPRTEXImage.o: /usr/include/g++/string /usr/include/g++/std/bastring.h
SpPRTEXImage.o: /usr/include/g++/cstddef /usr/include/g++/std/straits.h
SpPRTEXImage.o: /usr/include/g++/cctype /usr/include/ctype.h
SpPRTEXImage.o: /usr/include/g++/cstring /usr/include/g++/alloc.h
SpPRTEXImage.o: /usr/include/g++/iterator /usr/include/g++/cassert
SpPRTEXImage.o: /usr/include/g++/std/bastring.cc ../SpTime.h ../SpSize.h
SpPRTEXImage.o: ../SpUid.h ../SpGid.h ../SpFsObject.h /usr/include/sys/stat.h
SpPRTEXImage.o: /usr/include/bits/stat.h ../SpFsObjectHandle.h
SpPRTEXImage.o: ../SpImageDim.h ../SpImageFormat.h ../SpLibLoader.h
SpPRTEXImage.o: /usr/include/dlfcn.h /usr/include/bits/dlfcn.h
SpTIFFImage.o: SpTIFFImage.h ../SpImage.h /usr/include/g++/list
SpTIFFImage.o: /usr/include/g++/stl_algobase.h /usr/include/g++/stl_config.h
SpTIFFImage.o: /usr/include/_G_config.h /usr/include/bits/types.h
SpTIFFImage.o: /usr/include/features.h /usr/include/sys/cdefs.h
SpTIFFImage.o: /usr/include/gnu/stubs.h
SpTIFFImage.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/stddef.h
SpTIFFImage.o: /usr/include/g++/stl_relops.h /usr/include/g++/stl_pair.h
SpTIFFImage.o: /usr/include/g++/type_traits.h /usr/include/string.h
SpTIFFImage.o: /usr/include/limits.h /usr/include/bits/posix1_lim.h
SpTIFFImage.o: /usr/include/bits/local_lim.h /usr/include/linux/limits.h
SpTIFFImage.o: /usr/include/bits/posix2_lim.h /usr/include/stdlib.h
SpTIFFImage.o: /usr/include/sys/types.h /usr/include/time.h
SpTIFFImage.o: /usr/include/endian.h /usr/include/bits/endian.h
SpTIFFImage.o: /usr/include/sys/select.h /usr/include/bits/select.h
SpTIFFImage.o: /usr/include/bits/sigset.h /usr/include/sys/sysmacros.h
SpTIFFImage.o: /usr/include/alloca.h
SpTIFFImage.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/new.h
SpTIFFImage.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/new
SpTIFFImage.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/exception
SpTIFFImage.o: /usr/include/g++/iostream.h /usr/include/g++/streambuf.h
SpTIFFImage.o: /usr/include/libio.h
SpTIFFImage.o: /usr/lib/gcc-lib/i386-linux/egcs-2.91.66/include/stdarg.h
SpTIFFImage.o: /usr/include/g++/stl_iterator.h /usr/include/g++/stl_alloc.h
SpTIFFImage.o: /usr/include/assert.h /usr/include/pthread.h
SpTIFFImage.o: /usr/include/sched.h /usr/include/bits/sched.h
SpTIFFImage.o: /usr/include/signal.h /usr/include/bits/pthreadtypes.h
SpTIFFImage.o: /usr/include/bits/sigthread.h /usr/include/g++/stl_construct.h
SpTIFFImage.o: /usr/include/g++/stl_uninitialized.h
SpTIFFImage.o: /usr/include/g++/stl_list.h ../SpFile.h ../SpPath.h
SpTIFFImage.o: /usr/include/g++/string /usr/include/g++/std/bastring.h
SpTIFFImage.o: /usr/include/g++/cstddef /usr/include/g++/std/straits.h
SpTIFFImage.o: /usr/include/g++/cctype /usr/include/ctype.h
SpTIFFImage.o: /usr/include/g++/cstring /usr/include/g++/alloc.h
SpTIFFImage.o: /usr/include/g++/iterator /usr/include/g++/cassert
SpTIFFImage.o: /usr/include/g++/std/bastring.cc ../SpTime.h ../SpSize.h
SpTIFFImage.o: ../SpUid.h ../SpGid.h ../SpFsObject.h /usr/include/sys/stat.h
SpTIFFImage.o: /usr/include/bits/stat.h ../SpFsObjectHandle.h ../SpImageDim.h
SpTIFFImage.o: ../SpImageFormat.h ../SpLibLoader.h /usr/include/dlfcn.h
SpTIFFImage.o: /usr/include/bits/dlfcn.h /usr/include/g++/stream.h

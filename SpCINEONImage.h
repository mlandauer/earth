// $Id$

#ifndef _spcineonimage_h_
#define _spcineonimage_h_

#include "SpImage.h"
#include "SpImageDim.h"

class SpCINEONImageFormat: public SpImageFormat
{
	public:
		virtual string formatString() { return (string("Cineon")); };
		virtual SpImage* constructImage();
		virtual bool recognise(unsigned char *buf);
		virtual int sizeToRecognise() { return 4; };
};

class SpCINEONImage : public SpImage
{
	public:
		SpCINEONImage() { };
		~SpCINEONImage() { };
		SpImageDim dim();
		string formatString() { return format.formatString(); };
		bool valid() { return true; };
		int sizeToRecognise() {return format.sizeToRecognise(); };
		bool recognise(unsigned char *buf) { return format.recognise(buf); };
		SpImage* clone() { return (format.constructImage()); };
	private:
		SpCINEONImageFormat format;
};


#endif

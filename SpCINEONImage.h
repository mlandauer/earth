// $Id$

#ifndef _spcineonimage_h_
#define _spcineonimage_h_

#include "SpImage.h"
#include "SpImageDim.h"

class SpCINEONImageFormat: public SpImageFormat
{
	public:
		virtual string formatString() { return "Cineon"; };
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
		bool valid() { return true; };
		string formatString() { return format.formatString(); };
		SpImage* clone() { return (format.constructImage()); };
		bool recognise(unsigned char *buf) { return format.recognise(buf); };
		int sizeToRecognise() {return format.sizeToRecognise(); };
	private:
		SpCINEONImageFormat format;
};


#endif

// $Id$

#ifndef _spprmanzimage_h_
#define _spprmanzimage_h_

#include "SpImage.h"
#include "SpImageDim.h"

class SpPRMANZImageFormat: public SpImageFormat
{
	public:
		virtual string formatString() { return "PRMANZ"; };
		virtual SpImage* constructImage();
		virtual bool recognise(unsigned char *buf);
		virtual int sizeToRecognise() { return 4; };
};

class SpPRMANZImage : public SpImage
{
	public:
		SpPRMANZImage() { };
		~SpPRMANZImage() { };
		SpImageDim dim();
		bool valid() { return (true); };
		string formatString() { return format.formatString(); };
		SpImage* clone() { return format.constructImage(); };
		bool recognise(unsigned char *buf) { return format.recognise(buf); };
		int sizeToRecognise() { return format.sizeToRecognise(); };
	private:
		SpPRMANZImageFormat format;
};

#endif

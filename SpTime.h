// $Id$

// Basic class for keeping track of date and time stuff, comparing dates,
// making it all human readable but doing this in a way that the unix
// specific code (relating to time and date) is wrapped up in this class.

#ifndef _sptime_h_
#define _sptime_h_

#include <time.h>
#include <string>

class SpTime
{
	public:
		SpTime();
		~SpTime();
		void setUnixTime(time_t t);
		string timeAndDateString();
		void setCurrentTime();
		int dayOfWeek();
		int dayOfMonth();
		int year();
		int month();
		int hour();
		int minute();
		int second();
		string monthStringShort();
		string monthString();
		string dayOfWeekStringShort();
		string dayOfWeekString();
		string timeString();
		string dayOfMonthString();
		string yearString();
	private:
		time_t time;
};

#endif
